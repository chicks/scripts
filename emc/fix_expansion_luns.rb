#! /usr/bin/env ruby

CMD         = "/opt/Navisphere/bin/naviseccli -User emc -Password emc -Scope 0 "
SP_A        = "-h 10.40.7.113 "
SP_B        = "-h 10.40.7.114 "
ST_GROUP    = "PLADWS002SM"
CONTROLLERS = (14..17).to_a

all_luns  = []
r6_luns   = []
r10_luns  = []

r6_luns.concat((405..428).to_a)
#r6_luns.concat((400..404).to_a)
r10_luns.concat((306..329).to_a)
#r10_luns.concat((300..304).to_a)
all_luns.concat r6_luns
all_luns.concat r10_luns

# Get ALU/HLU Mappings
def hlu_alu_map
  get_sg = CMD + SP_A + "storagegroup -list -gname #{ST_GROUP}"
#  sg_out = `#{get_sg}`
  sg_out = <<'EOF'

Storage Group Name:    PLADWS002SM
Storage Group UID:     72:98:30:D7:63:5A:DD:11:97:04:00:60:16:1E:08:76
HBA/SP Pairs:

  HBA UID                                          SP Name     SPPort
  -------                                          -------     ------
  20:00:00:1B:32:10:95:A3:21:00:00:1B:32:10:95:A3   SP B         0
  20:00:00:1B:32:10:D7:9D:21:00:00:1B:32:10:D7:9D   SP A         2
  20:01:00:1B:32:30:95:A3:21:01:00:1B:32:30:95:A3   SP A         0
  20:01:00:1B:32:30:D7:9D:21:01:00:1B:32:30:D7:9D   SP B         2

HLU/ALU Pairs:

  HLU Number     ALU Number
  ----------     ----------
    7               107
    8               108
    9               109
    17              117
    18              118
    19              119
    27              127
    28              128
    29              129
    37              137
    38              138
    39              139
    47              147
    48              148
    49              149
    50              150
    51              151
    52              152
    53              153
    54              154
    55              155
    56              156
    57              157
    58              158
    59              159
    60              160
    61              161
    62              162
    63              163
    64              164
    65              165
    66              166
    67              260
    68              261
    69              270
    70              271
    71              280
    72              281
    73              290
    1               101
    0               100
    2               102
    3               104
    4               106
    5               111
    6               113
    10              115
    11              120
    12              122
    13              124
    14              126
    15              131
    16              133
    20              135
    21              140
    22              142
    23              144
    24              146
    25              103
    26              105
    30              110
    31              112
    32              114
    33              116
    34              121
    35              123
    36              125
    40              130
    41              132
    42              134
    43              136
    44              141
    45              143
    46              145
    76              300
    77              301
    78              302
    79              303
    80              304
    81              400
    82              401
    83              402
    84              403
    85              404
    86              405
Shareable:             YES

EOF

  hlu_start = false
  hlu_map   = {}
  sg_out.split(/\n/).each do |line|

    # Start parsing when we see this line
    if line =~ /^HLU\/ALU\ Pairs\:/
      hlu_start = true
    end

    if hlu_start
      if line =~ /\s+(\d+)\s+(\d+)/
        hlu = $1
        alu = $2
        hlu_map[$1.to_i] = $2.to_i
      end
    end

  end
  return hlu_map
end

def even?(number)
  if( number%2 == 0)
    return true
  else
    return false
  end
end


all_luns.sort!

# Odd LUNs live on SPB, Even LUNs live on SPA
all_luns.each do |lun|
  if even?(lun)
    puts CMD + SP_A + "chglun -l #{lun} -d 0 -r Medium -v Low"
  else
    puts CMD + SP_B + "chglun -l #{lun} -d 1 -r Medium -v Low"
  end
end

hlu_map = hlu_alu_map
hlu_idx = hlu_map.sort{|a,b| a[0].to_i<=>b[0].to_i}.last[0].to_i
all_luns.each do |lun|
  if ! hlu_map.has_value? lun
    hlu_idx += 1
    if even?(lun)
      puts CMD + SP_A + "storagegroup -addhlu -gname \"#{ST_GROUP}\" -hlu #{hlu_idx} -alu #{lun}"
    else
      puts CMD + SP_B + "storagegroup -addhlu -gname \"#{ST_GROUP}\" -hlu #{hlu_idx} -alu #{lun}"
    end
    hlu_map[hlu_idx] = lun
  end
end

hlu_map.sort{|a,b| a[1].to_i<=>b[1].to_i}.each { |hlu, alu| 
  os_lun = "c#{CONTROLLERS.first}t0d#{hlu.to_i}"
  if r6_luns.include? alu
    puts "format -f r6.cmd #{os_lun}"
  elsif r10_luns.include? alu
#    puts "# r10 LUN: #{alu} = #{os_lun}"
    puts "format -f r10.cmd #{os_lun}"
  end
}

hlu_map.sort{|a,b| a[1].to_i<=>b[1].to_i}.each { |hlu, alu| 
  os_lun = "c#{CONTROLLERS.first}t0d#{hlu.to_i}"
  if r6_luns.include? alu
    puts "fmthard -s vxvm-1098.44GB.vtoc /dev/rdsk/#{os_lun}s2"
  end
  if r10_luns.include? alu
    puts "fmthard -s asm-984.51GB.vtoc /dev/rdsk/#{os_lun}s2"
  end
}

#hlu_map.sort{|a,b| a[0].to_i<=>b[0].to_i}.each {|key, value| puts "#{key}\t#{value}"}

