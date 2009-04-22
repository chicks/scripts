#! /usr/bin/env ruby

require 'rubygems'

RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'

total_created = 0

invalid_entries = File.new("bad_accounts.csv", "w")

File.open("accounts.csv", "r") do |line|
  while (gal_entry = line.gets)

    valid_entry = false

    gal_entry.strip!
    gal_entry.gsub!(/\r\n/,'\n')
    gal_entry.gsub!(/\r/,'\n')
    gal_entry.gsub!(/\"([\w\s\#]+)\,([\w\s\#]+)\"/,"\\1 \\2")

    user = gal_entry.split(/,/)

    gu = GalUser.find_by_username(user[0])
    gu = GalUser.new if gu == nil

    gu.username         = user[0]
    gu.email            = user[1]
    gu.real_name        = user[2]
    gu.display_name     = user[3]
    gu.first_name       = user[4]
    gu.last_name        = user[5]
    gu.telephone        = user[6]
    gu.mobile_phone     = user[7]
    gu.organization     = user[8]
    gu.department       = user[9]
    gu.street_address   = user[10]
    gu.city             = user[11]
    gu.state            = user[12]
    gu.postal_code      = user[13]
    gu.country          = user[14]
    gu.office           = user[15]
    gu.title            = user[16]
    gu.company          = user[17]
    gu.manager          = user[18]

    if user.length < 18
      invalid_entries.puts user.join(',')
      next
    end

    if gu.username.include? " "
      invalid_entries.puts user.join(',')
      next
    end

    gu.save

    puts "Processed Record: #{total_created}"
    total_created = total_created.next
  end
end

puts "Total Records Created: #{total_created}"

