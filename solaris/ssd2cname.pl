#! /usr/bin/perl -w

use strict;

my @ssd_disk_list = split(/\n/, `iostat -xp 1 1`);
my @c_disk_list   = split(/\n/, `iostat -xnp 1 1`);

my $index;
for ($index = 0; $index <= $#ssd_disk_list; $index++) {
  my @ssd_line = split(/ /, $ssd_disk_list[$index]);
  my @c_line   = split(/ /, $c_disk_list[$index]);

  my $ssd = $ssd_line[0];
  my $c   = $c_line[-1];
  print "$ssd = $c\n";
}

