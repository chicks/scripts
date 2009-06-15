#! /usr/bin/perl -w

use strict;

my $input = shift;

open( INPUT, $input ) || die "Couldn't open $input: $!";

while(<INPUT>) {
  my ($mnc, $mcc, $lac, $rac, $ci);
  if ($_ =~ /^(\d{1,3})\-(\d{1,3})\-(\d{1,7})\-(\d{1,2})\-(\d{1,9})$/) {
    $mcc = $1;
    $mnc = $2;
    $lac = $3;
    $rac = $4;
    $ci = $5;
    print "gsh set_nrr_lai $mcc-$mnc-$lac -nrrg 21 22\n";
  }
}
