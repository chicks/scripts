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
#$LOGFILE = IO::File->new("> $0-" . timestamp(). ".log") or die "Couldn't open logfile: $!\n";

if ($file_list) {
  process_access_log_file_list($file_list);
} 

if ($file){
  read_access_log_file($file);
}

$end_time = [gettimeofday];
$elapsed_time = (tv_interval $start_time, $end_time) * 1000;

#logger("Processing Time: $elapsed_time ms");


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

sub read_access_log_file {

  my $filereport = {};
  my $f_start_time = [gettimeofday];
  my $entry_file = $_[0];

  chomp $entry_file;
  open(FILE, $entry_file) || die("Couldn't open: $!\n");
  #logger("Processing File: $entry_file");
  foreach my $line (<FILE>) {
    # - "69.147.111.119, 216.9.250.83" "BlackBerry8100/4.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/102" [26/Jul/2008:18:59:58 -0500] "GET /primary/_DGutmc-iTecYhy2Q HTTP/1.1" 200 11390
    my @fields = split(/\"/, $line);
    my @source_ips = split(/\,\ /, $fields[1]);
    my $unique_ip = $source_ips[0];
    if ($unique_ip =~ /unknown/) {
      $unique_ip = $source_ips[1];
    }
    $fields[1] = $unique_ip;
    my $entry = join('"', @fields);
    print $entry;  
  }
  close(FILE);
  my $f_end_time = [gettimeofday];
  my $f_elapsed_time = (tv_interval $f_start_time, $f_end_time) * 1000;

}

# Real Program
sub process_access_log_file_list {
  my $file_list = $_[0];
  open(FILELIST, $file_list) || die("Couldn't open: $!\n");
  #logger("Processing File List: $file_list");
  foreach  my $entry_file (<FILELIST>) {
    read_access_log_file($entry_file);
  }
  close(FILELIST);
}


