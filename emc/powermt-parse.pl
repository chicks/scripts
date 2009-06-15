#! /usr/bin/perl -w

use strict;

#my $powermt_out = `powermt display dev=all`;
my $powermt_out = <<'EOF';

Pseudo name=emcpower23a
CLARiiON ID=HK190074900068 [PLADWS002SM]
Logical device ID=6006016082E71E0009B10334FA67DD11 [LUN 113]
state=alive; policy=CLAROpt; priority=0; queued-IOs=0
Owner: default=SP A, current=SP A       Array failover mode: 1
==============================================================================
---------------- Host ---------------   - Stor -   -- I/O Path -  -- Stats ---
###  HW Path                I/O Paths    Interf.   Mode    State  Q-IOs Errors
==============================================================================
3082 ssm@0,0/pci@19,700000/QLGC,qlc@1/fp@0,0 c14t0d6s0 SP A2     active  alive      0      0
3083 ssm@0,0/pci@19,700000/QLGC,qlc@1,1/fp@0,0 c15t0d6s0 SP B2     active  alive      0      2
3084 ssm@0,0/pci@1b,700000/QLGC,qlc@1/fp@0,0 c16t0d6s0 SP B0     active  alive      0      2
3085 ssm@0,0/pci@1b,700000/QLGC,qlc@1,1/fp@0,0 c17t0d6s0 SP A0     active  alive      0      0

Pseudo name=emcpower75a
CLARiiON ID=HK190074900068 [PLADWS002SM]
Logical device ID=6006016082E71E0016E86893FA67DD11 [LUN 146]
state=alive; policy=CLAROpt; priority=0; queued-IOs=0
Owner: default=SP A, current=SP A       Array failover mode: 1
==============================================================================
---------------- Host ---------------   - Stor -   -- I/O Path -  -- Stats ---
###  HW Path                I/O Paths    Interf.   Mode    State  Q-IOs Errors
==============================================================================
3082 ssm@0,0/pci@19,700000/QLGC,qlc@1/fp@0,0 c14t0d24s0 SP A2     active  alive      0      0
3083 ssm@0,0/pci@19,700000/QLGC,qlc@1,1/fp@0,0 c15t0d24s0 SP B2     active  alive      0      2
3084 ssm@0,0/pci@1b,700000/QLGC,qlc@1/fp@0,0 c16t0d24s0 SP B0     active  alive      0      2
3085 ssm@0,0/pci@1b,700000/QLGC,qlc@1,1/fp@0,0 c17t0d24s0 SP A0     active  alive      0      0

Pseudo name=emcpower37a
CLARiiON ID=HK190074900068 [PLADWS002SM]
Logical device ID=6006016082E71E00188721BE5B5ADD11 [LUN 280 - Swap]
state=alive; policy=CLAROpt; priority=0; queued-IOs=0
Owner: default=SP A, current=SP A       Array failover mode: 1
==============================================================================
---------------- Host ---------------   - Stor -   -- I/O Path -  -- Stats ---
###  HW Path                I/O Paths    Interf.   Mode    State  Q-IOs Errors
==============================================================================
3082 ssm@0,0/pci@19,700000/QLGC,qlc@1/fp@0,0 c14t0d71s0 SP A2     active  alive      0      0
3083 ssm@0,0/pci@19,700000/QLGC,qlc@1,1/fp@0,0 c15t0d71s0 SP B2     active  alive      0      2
3084 ssm@0,0/pci@1b,700000/QLGC,qlc@1/fp@0,0 c16t0d71s0 SP B0     active  alive      0      2
3085 ssm@0,0/pci@1b,700000/QLGC,qlc@1,1/fp@0,0 c17t0d71s0 SP A0     active  alive      0      0

Pseudo name=emcpower43a
CLARiiON ID=HK190074900068 [PLADWS002SM]
Logical device ID=6006016082E71E00198721BE5B5ADD11 [LUN 290 - redo]
state=alive; policy=CLAROpt; priority=0; queued-IOs=7
Owner: default=SP A, current=SP A       Array failover mode: 1
==============================================================================
---------------- Host ---------------   - Stor -   -- I/O Path -  -- Stats ---
###  HW Path                I/O Paths    Interf.   Mode    State  Q-IOs Errors
==============================================================================
3082 ssm@0,0/pci@19,700000/QLGC,qlc@1/fp@0,0 c14t0d73s0 SP A2     active  alive      3      0
3083 ssm@0,0/pci@19,700000/QLGC,qlc@1,1/fp@0,0 c15t0d73s0 SP B2     active  alive      0      2
3084 ssm@0,0/pci@1b,700000/QLGC,qlc@1/fp@0,0 c16t0d73s0 SP B0     active  alive      0      2
3085 ssm@0,0/pci@1b,700000/QLGC,qlc@1,1/fp@0,0 c17t0d73s0 SP A0     active  alive      4      0

EOF

#my $iostat_out = `iostat -eEn`;
my $iostat_out = <<'EOF';

c14t0d6         Soft Errors: 1 Hard Errors: 0 Transport Errors: 0
Vendor: DGC      Product: VRAID            Revision: 0326 Serial No:
Size: 1098.42GB <1098421108736 bytes>
Media Error: 0 Device Not Ready: 0 No Device: 0 Recoverable: 0
Illegal Request: 1 Predictive Failure Analysis: 0
c15t0d6         Soft Errors: 1 Hard Errors: 1 Transport Errors: 0
Vendor: DGC      Product: VRAID            Revision: 0326 Serial No:
Size: 1098.44GB <1098437885952 bytes>
Media Error: 0 Device Not Ready: 0 No Device: 1 Recoverable: 0
Illegal Request: 1 Predictive Failure Analysis: 0
c17t0d6         Soft Errors: 1 Hard Errors: 0 Transport Errors: 0
Vendor: DGC      Product: VRAID            Revision: 0326 Serial No:
Size: 1098.42GB <1098421108736 bytes>
Media Error: 0 Device Not Ready: 0 No Device: 0 Recoverable: 0
Illegal Request: 1 Predictive Failure Analysis: 0

EOF

my @lines = split(/\n/,$powermt_out);
my @iostat_lines = split(/\n/, $iostat_out);

my $VOLUMES = {};
my $vid = 0;
my $current_volume = 0;

foreach my $line (@iostat_lines) {
  if ($line =~ /^(c\d+t\d+d\d+)\s+Soft.*/) {
    $vid++;
    $current_volume = $1;
    $VOLUMES->{$current_volume}->{'ID'} = $vid;
  }
  if ($line =~ /^Size: (\d+\.\d+[MKG]B)\s\<\d+\sbytes\>.*/) {
    $VOLUMES->{$current_volume}->{'SIZE'} = $1;
  }
}

my $DEVICES = {};
my $id = 0;
my $current_device = 0;

foreach my $line (@lines) {
  if ($line =~ /^Pseudo name=emcpower(\d+)\w/) {
    $id++;
    $current_device = $1;
    $DEVICES->{$current_device}->{'ID'} = $id;
  }
  if ($line =~ /^Logical device ID=[\w\d]+ \[LUN (\d+).*\]/) {
    $DEVICES->{$current_device}->{'LUN'} = $1;
  }
  if ($line =~ /^state=(\w+)/ ) {
    $DEVICES->{$current_device}->{'STATE'} = $1;
  }
  if ($line =~ /^\d+ .+ (c\d+t\d+d\d+)(s\d+) SP (\w\d)\ +(\w+)\ +(\w+)/ ) {
    $DEVICES->{$current_device}->{'DEVICES'}->{$1}->{'PORT'} = $3;
    $DEVICES->{$current_device}->{'DEVICES'}->{$1}->{'MODE'} = $4;
    $DEVICES->{$current_device}->{'DEVICES'}->{$1}->{'STATE'} = $5;
  }
  if ($line =~ /^$/) {
    $current_device = 0;
  }
}


print "DEVICE   \tLUN\tSTATE\tSUB-DEVICE   \tPORT\tMODE\tSTATE\tSIZE\n";
for my $device ( sort {$a <=> $b } keys %$DEVICES ) {
  my $lun   = $DEVICES->{$device}->{'LUN'};
  my $state = $DEVICES->{$device}->{'STATE'};
  for my $sub_dev ( sort keys %{$DEVICES->{$device}->{'DEVICES'}} ) {
    my $sd_port  = $DEVICES->{$device}->{'DEVICES'}->{$sub_dev}->{'PORT'};
    my $sd_mode  = $DEVICES->{$device}->{'DEVICES'}->{$sub_dev}->{'MODE'};
    my $sd_state = $DEVICES->{$device}->{'DEVICES'}->{$sub_dev}->{'STATE'};
    my $sd_size  = $VOLUMES->{$sub_dev}->{'SIZE'} || "Unknown";
    my @line = ( "emcpower" . $device, $lun, $state, $sub_dev. " ", $sd_port, $sd_mode, $sd_state, $sd_size );
    my $line = join("\t", @line) ;
    print $line . "\n";
  }
}
