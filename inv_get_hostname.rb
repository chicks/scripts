#! /usr/bin/ruby

require 'rubygems'
require 'net/ssh'
require 'net/sftp'
require 'net/ping'
require 'net/telnet'
require 'ifconfig'

#
# Globals
#
$log          = File.open("inventory.log", "w")
$outfile_name = "inv-" << Time.new.strftime("%Y-%m-%d") << ".csv"
$outfile      = File.open($outfile_name, "w")
$backup_suffix= Time.new.strftime("%Y-%m-%dT%H.%M.%S")

def log(message)
  timestamp = Time.new.strftime("%Y-%m-%dT%H:%M:%S")
  log_message = timestamp << ": " << message
  $log.puts(log_message)
  puts log_message
end

class IfconfigWrapper
end

class InventoryEntry
  attr :type, true
  attr :location, true
  attr :row, true
  attr :rack, true
  attr :low_ru, true
  attr :high_ru, true
  attr :hostname, true
  attr :alias, true
  attr :platform, true
  attr :component, true
  attr :status, true
  attr :make, true
  attr :model, true
  attr :cpu_arch, true
  attr :owner, true
  attr :os_type, true
  attr :os_name, true
  attr :os_version, true
  attr :interfaces, true
  attr :oam_ip, true
  attr :user, true
  attr :password, true
  attr :ssh, true
  attr :telnet, true
  attr :rdp, true
  attr :ping, true
  attr :sudo, true
  attr :errors, true
  attr :shell, true
  attr :accessible, true

  def initialize(oam_ip, user, password)
    @oam_ip = oam_ip
    @user   = user
    @password = password
    @ssh    = false
    @telnet = false
    @rdp    = false
    @ping   = false
    @sudo   = false
    @shell  = nil
    @accessible = false
    @errors  = []
    discover_mgmt_ports    
  end

  def xfer_file(from, to)
    log("#{@oam_ip}: scp #{from} #{@user}@#{@oam_ip}:#{to}")
    Net::SSH.start(@oam_ip, @user, @password) do |session|
      session.sftp.connect do |sftp|
        sftp.put_file from, to
      end
    end
  end

  def run_ssh_cmd(cmd, can_return_null)
    begin
      Net::SSH.start( @oam_ip, @user, @password, :log => "net-ssh.log", :verbose => :debug, :timeout => 5) do |session|
        #cmd << "; echo $?" if can_return_null
        #cmd << "; echo $?" 
        
        shell = session.shell.sync
        cmd_stuff =  shell.send_command(cmd)
        puts cmd_stuff
        output = cmd_stuff.stdout
        #input, output, error = session.process.popen3( cmd ) 
        #my_output = output.read
        #my_output << output.read 
        #my_error  = error.read
        log("#{oam_ip} SSH: #{cmd}: #{output}")
        session.close
        return output
      end
    rescue Net::SSH::HostKeyMismatch
      @errors << "SSH: Host Key Mismatch"
      return false
    rescue Net::SSH::AuthenticationFailed
      @errors << "SSH: Login Failure"
      return false
    rescue Errno::ECONNREFUSED
      @errors << "SSH: Connection Refused"
    end
  end

  def run_telnet_cmd(cmd)
    #puts "Attempting to Telnet to: #{@oam_ip}"
    output = Array.new
    clean_output = ""
    begin
      @shell = Net::Telnet::new("Host" => @oam_ip, "Output_log" => "inv.log", "Timeout" => 5)
      @shell.login(@user, @password)
      @shell.cmd(cmd) { |o| output << o }
      @shell.close  
      if output && output.length > 1
        output.each do |line|
          next if line.match(cmd)
          line = line.chomp
          line = line.gsub(/^[$%#>]/, '')
          line = line.gsub(/^[\r\n]/, '')
          clean_output << line
        end 
        log("#{oam_ip} Telnet: #{cmd}: #{clean_output}")
        return clean_output
      else
        @errors << "Telnet: Login Failure"
        return false
      end
    rescue Timeout::Error
      @errors << "Telnet: Connection Timeout"
      return false
    rescue Errno::ECONNREFUSED
      @errors << "Telnet: Connection Refused"
      return false
    end
  end


  #
  # TODO: add an optional argument where you can pass in an existing connection
  # 
  def run_cmd(cmd, can_return_null)
    #log("#{@oam_ip}: #{cmd}")
    output = false
    if @ssh && @accessible
      output = run_ssh_cmd(cmd, can_return_null )
      if !output
        @ssh = false
        output = run_telnet_cmd(cmd)
      end
    elsif @telnet && @accessible
      output = run_telnet_cmd(cmd)
      if !output
        @telnet = false
      end
    else
      #@errors << "Not accessible via SSH/Telnet " 
    end 
    if !output || (!@ssh && !@telnet)
      @errors << "Not accessible via SSH/Telnet"
      @accessible = false
    end
    return output
  end

  def iface_to_ssv
    ssv = Array.new
    @interfaces.each do |iface|
      if iface.up? 
        ssv << [iface.name, iface.addresses('inet')].join(":")
      end
    end
    return ssv.join(";")
  end

  def discover_mgmt_ports
    log("#{@oam_ip}: Discovering Management Ports")
    # Determine what ports are open for management access
    telnet = Net::PingTCP.new(@oam_ip,23)
    ssh    = Net::PingTCP.new(@oam_ip,22)
    rdp    = Net::PingTCP.new(@oam_ip,3389)
    ping   = Net::PingExternal.new(@oam_ip)

    @telnet = true if telnet.ping
    @ssh    = true if ssh.ping
    @rdp    = true if rdp.ping
    @ping   = true if ping.ping

    @accessible = true if @telnet || @ssh
  end

  def discover_hostname_and_os
    log("#{@oam_ip}: Attempting to Discover Hostname and Operating System")
    uname = run_cmd("uname -a", false)
    if uname && uname.length > 1 
      uname_parts = uname.split(/ /)
      @hostname    = uname_parts[1]
      @os_name     = uname_parts[0]

      if (@os_name.match(/SunOS/))
        puts "Matched SunOS"
        @os_version   = uname_parts[2].split(/\./)[1].chomp
        @os_type      = "Unix"
        @os_name      = "Solaris"
        @make         = "SUN"
        @model        = uname_parts[6].split(/,/)[1].chomp
        @cpu_arch     = uname_parts[5]
      elsif (@os_name.match(/Linux/))
        @os_type      = "Linux"
        
      end
    end
  end

  def validate_logins
    # Put code here to login via ssh or telnet
  end

  #
  # TODO: I need to clean this up.  SSH is hanging whenever a command returns no output!
  # TODO: Add a command timeout
  #
  def ssh_enable_root_login
    root_login = false
  
    # TODO: Write a grep function that returns the matched string, or false 
    grep = run_cmd("grep \"PermitRootLogin\" /etc/ssh/sshd_config | grep -i \"yes\"")
    root_login = true if grep && grep.match(/^\#*\s*PermitRootLogin\s+[Yy]es/)
    if !root_login
      # Backup the old config file
      run_cmd "cp /etc/ssh/sshd_config /etc/ssh/sshd_config." << $backup_suffix 
      # Search and replace the line in the config that disables root login
      run_cmd "perl -p -i -e 's/PermitRootLogin [Nn]o/PermitRootLogin yes/g' /etc/ssh/sshd_config" 
      # Restart sshd
      run_cmd "/etc/init.d/sshd restart"
    end
    return true
  end

  def ssh_enable_banner
    banner = false
    banner = true if (run_cmd("grep \"Banner /etc/issue\" /etc/ssh/sshd_config", true).match(/^Banner\ \/etc\/issue/))
    if !banner
      # Backup the old config file
      run_cmd "cp /etc/ssh/sshd_config /etc/ssh/sshd_config." << $backup_suffix, true
      # Search and replace the line in the config that handles the banner
      run_cmd "perl -p -i -e 's/^#Banner \\/etc\\/issue/Banner \\/etc\\/issue/' /etc/ssh/sshd_config", true
      # Backup the old banner file
      run_cmd "cp /etc/issue /etc/issue." << $backup_suffix, true
      # Install the new banner file
      xfer_file("/etc/motd","/etc/issue")
      # Restart sshd
      run_cmd "/etc/init.d/sshd restart", true
    end
    return true
  end

  def has_sudo
    log("#{@oam_ip}: Attempting to Locate \"sudo\"")
    sudo = false
    sudo = run_cmd("find /bin /sbin /usr/bin /usr/sbin -name sudo -print", true)
    @sudo = true if sudo && sudo.match(/^\/+.*sudo/)
    log("#{@oam_ip}: Found sudo: #{sudo}") if @sudo
    return @sudo 
  end

  def discover_ip_and_iface
    log("#{@oam_ip}: Discovering IP address information")
    ifconfig = false
    if @os_type && @os_name.match(/Solaris/)
      ifconfig = run_cmd("netstat -in", false)
      @interfaces = IfconfigWrapper.new('SunOS',ifconfig).parse if ifconfig
      return true
    elsif @os_type && os_type.match(/Linux/)
      ifconfig = run_cmd("ifconfig -a", false)
      @interfaces = IfconfigWrapper.new('Linux',ifconfig).parse if ifconfig
      return true
    else
      return ifconfig
    end
  end

  def inventory
    #validate_logins
    discover_hostname_and_os
    discover_ip_and_iface
    has_sudo
  end

  def baseline
    #ssh_enable_root_login
    #ssh_enable_banner
  end

  def InventoryEntry.to_csv_header
    return %w{Type,Location,Row,Rack,LowRU,HighRU,Alias,Hostname,Platform,Component,Status,Make,Model,Owner,OSType,OSName,OSVersion,OAMIP,Interfaces,User,Password,SSH,Telnet,RDP,Ping,SUDO,Errors}
  end
  
  def to_csv
    attrs = [@type,@location,@row,@rack,@low_ru,@high_ru,@alias,@hostname,@platform,@component,@status,@make,@model,@owner,@os_type,@os_name,@os_version,@oam_ip,iface_to_ssv,@user,@password,@ssh,@telnet,@rdp,@ping,@sudo,@errors.join("; ")]
    return attrs.join(",")
  end

end

$outfile.puts InventoryEntry.to_csv_header
File.open("pps_host", "r") do |servers|
#File.open("pps_hosts_and_pw.list", "r") do |servers|
  while (system = servers.gets)
    
    system_details  = system.split(/,/)

    system          = InventoryEntry.new(system_details[4],system_details[5],system_details[6].chomp)
    system.platform = system_details[0]
    system.component= system_details[1]
    system.type     = "Server"
    system.location = system_details[2]
    system.alias    = system_details[3]

    system.inventory
    system.baseline
    $outfile.puts system.to_csv

  end
end

log "Wrote inventory to: #{$outfile_name}"
$outfile.close
$log.close
