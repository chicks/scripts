#! /usr/bin/perl

use strict;
use Getopt::Long;
use IO::File;
use Time::HiRes qw(gettimeofday tv_interval);

# globals
use vars qw($DEBUG $ERROR $ERRNO $LOGFILE);
my $start_time;
my $end_time;
my $elapsed_time;
my $hitreport = {};

# arguments
my $help;
my $file;
my $file_list;

# Usage and args
die usage() if (($#ARGV < 1 ) or ( ! GetOptions ( 'help|?'          => \$help,
                                                  'd|debug'         => \$DEBUG,
                                                  'f|file=s'        => \$file,
                                                  'l|filelist=s'    => \$file_list, ))
                              or ( defined $file && defined $file_list )
                              or ( defined $help ));


# Start the clock
$start_time = [gettimeofday];

# set our logfile name
$LOGFILE = IO::File->new("> $0-" . timestamp(). ".log") or die "Couldn't open logfile: $!\n";

if ($file_list) {
  process_merged_file_list($file_list);
} 

if ($file){
  read_merged_file($file);
}

print_hitreport();

$end_time = [gettimeofday];
$elapsed_time = (tv_interval $start_time, $end_time) * 1000;

logger("Processing Time: $elapsed_time ms");


#
# Sub Routines
# 

sub logger {
  print $LOGFILE timestamp() . ": $_[0]\n";
}

sub usage {
  print "Unknown option: @_\n" if ( @_ );
  print STDERR << "EOF";

  Usage:
    $0 [OPTIONS]... [-f, --file <file name>]
  or
    $0 [OPTIONS]... [-l, --filelist <file name>]

  Valid options are:
       [-?, --help]

EOF
  exit;
}

sub timestamp {
  # Accept ARGV or just use the current date
  my $timestamp = time unless $_[0];        

  # convert epoch to readable
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timestamp);

  # simple conversions to make the date readable, and zero padded
  $year += 1900;
  $mon  += 1;
  $mon   = sprintf("%02d", $mon);
  $mday  = sprintf("%02d", $mday);
  $hour  = sprintf("%02d", $hour);
  $min   = sprintf("%02d", $min);
  $sec   = sprintf("%02d", $sec);

  return "$year-$mon-$mday\T$hour.$min.$sec";
}

sub read_merged_file {

  my $filereport = {};
  my $f_start_time = [gettimeofday];
  my $entry_file = $_[0];

  chomp $entry_file;
  open(FILE, $entry_file) || die("Couldn't open: $!\n");
  #logger("Processing File: $entry_file");
  foreach my $line (<FILE>) {
    my $timestamp;
    if ($line =~ /^S\;(\d+)$/) {

      # Java timestamps are in miliseconds
      $timestamp = $1 / 1000;

      # convert epoch to readable
      my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timestamp);

      # simple conversions to make the date readable, and zero padded
      $year += 1900;
      $mon  += 1;
      $mon   = sprintf("%02d", $mon);
      $mday  = sprintf("%02d", $mday);
      $hour  = sprintf("%02d", $hour);

      # populate the hash
      $hitreport->{'hitcount'}++;
      $hitreport->{$year}{'hitcount'}++;
      $hitreport->{$year}{$mon}{'hitcount'}++;
      $hitreport->{$year}{$mon}{$mday}{'hitcount'}++;
      $hitreport->{$year}{$mon}{$mday}{$hour}{'hitcount'}++;

      $filereport->{'hitcount'}++;
      $filereport->{$year}{'hitcount'}++;
      $filereport->{$year}{$mon}{'hitcount'}++;
      $filereport->{$year}{$mon}{$mday}{'hitcount'}++;
      $filereport->{$year}{$mon}{$mday}{$hour}{'hitcount'}++;
    }
  }
  close(FILE);
  my $f_end_time = [gettimeofday];
  my $f_elapsed_time = (tv_interval $f_start_time, $f_end_time) * 1000;

  print_filereport($entry_file, $filereport);

  logger("Processed File: $entry_file -> Time: $f_elapsed_time ms");
  logger("Processed File: $entry_file -> Reqs: " . $filereport->{'hitcount'});
  logger("Processed File: $entry_file -> Perf: " . scalar(int(($filereport->{'hitcount'} / $f_elapsed_time)) + .5) . " entries / ms" );

}

# Real Program
sub process_merged_file_list {
  my $file_list = $_[0];
  open(FILELIST, $file_list) || die("Couldn't open: $!\n");
  logger("Processing File List: $file_list");
  foreach  my $entry_file (<FILELIST>) {
    read_merged_file($entry_file);
  }
  close(FILELIST);
}


sub print_filereport {

  my $entry_file = $_[0];
  my $filereport = $_[1];

  # Print the results
  for my $year ( sort keys %$filereport ) {
    if ($year =~ /hitcount/){
      next;
    }
    for my $mon ( sort keys %{$filereport->{$year}} ) {
      if ($mon =~ /hitcount/){
        next;
      }
      for my $mday ( sort keys %{$filereport->{$year}->{$mon}} ) {
        if ($mday =~ /hitcount/){
          next;
        }
        for my $hour ( sort keys %{$filereport->{$year}->{$mon}->{$mday}} ) {
          if ($hour =~ /hitcount/){
            next;
          }
          my $hits = $filereport->{$year}->{$mon}->{$mday}->{$hour}->{'hitcount'};
          logger("Processed File: $entry_file -> $year-$mon-$mday-$hour:\t$hits");
        }
      }
    }
  }
}

sub print_hitreport {
  # Print the results
  for my $year ( sort keys %$hitreport ) {
    if ($year =~ /hitcount/){
      print "Total Hits Processed\t$hitreport->{$year}\n";
      next;
    }
    for my $mon ( sort keys %{$hitreport->{$year}} ) {
      if ($mon =~ /hitcount/){
        #print "$year: $hitreport->{$year}->{$mon}\n";
        next;
      }
      for my $mday ( sort keys %{$hitreport->{$year}->{$mon}} ) {
        if ($mday =~ /hitcount/){
          #print "$year-$mon: $hitreport->{$year}->{$mon}->{$mday}\n";
          next;
        }
        for my $hour ( sort keys %{$hitreport->{$year}->{$mon}->{$mday}} ) {
          if ($hour =~ /hitcount/){
            #print "$year-$mon-$mday: $hitreport->{$year}->{$mon}->{$mday}->{$hour}\n";
            next;
          }
          my $hits = $hitreport->{$year}->{$mon}->{$mday}->{$hour}->{'hitcount'};
          print "$year-$mon-$mday $hour:00:00\t$hits\n";
        }
      }
    }
  }
}

