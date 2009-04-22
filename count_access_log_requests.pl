#! /usr/bin/perl

use strict;
use Getopt::Long;
use IO::File;
use Data::Dumper;
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
  process_access_log_file_list($file_list);
} 

if ($file){
  read_access_log_file($file);
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

sub read_access_log_file {

  my $filereport = {};
  my $f_start_time = [gettimeofday];
  my $entry_file = $_[0];

  my %mon2num = qw(
  jan 1  feb 2  mar 3  apr 4  may 5  jun 6
  jul 7  aug 8  sep 9  oct 10 nov 11 dec 12
  );

  chomp $entry_file;
  open(FILE, $entry_file) || die("Couldn't open: $!\n");
  #logger("Processing File: $entry_file");
  
  my $line_number = 1;
  foreach my $line (<FILE>) {
    # - "69.147.111.119, 216.9.250.83" "BlackBerry8100/4.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/102" [26/Jul/2008:18:59:58 -0500] "GET /primary/_DGutmc-iTecYhy2Q HTTP/1.1" 200 11390

    # Some worms like to write \" into a request string... convert them to somethign else so they don't break our request processing
    # e.g.: "\xa4~1\x85\xd0\xef\x1bP4F\xad\xe5\xb2\xfd\xe8\xfe<@\x7f\v\xed*Cookie: "
    $line =~ s/\\\"/\;quote/;

    my @fields      = split(/\"/, $line);
    my $ip          = $fields[1] or die "$entry_file: line $line_number: Couldn't parse IP Address: \"$fields[1]\"\n";
    
    my $user_agent;
    if ($fields[3] =~ /(\w+|\-)(\/)*.*/) {
      $user_agent = $1;
    } elsif (length($fields[3]) == 0) {
      $user_agent = "null";
    } else {
      die "$entry_file: line $line_number: Couldn't parse User-Agent: \"$fields[3]\"\n";
    }

    my $timestamp   = $fields[4] or die "$entry_file: line $line_number: Couldn't parse Timestamp: \"$fields[4]\"\n";
    my $url;
    
    if (length($fields[5]) > 0){
      $url = $fields[5];
    } else {
      $url = "null";
    }

    chomp $fields[6];
    my $status      = $1 if ($fields[6] =~ /\ (\d{3})\ (\d+|\-)/) or die "$entry_file: line $line_number: Couldn't parse Status: \"$fields[6]\"\n";
    my $size        = $1 if ($fields[6] =~ /\ \d{3}\ (\d+|\-)/);

    my ($year,$mon,$mday,$hour);
    # [01/Aug/2008:18:59:29 -0500] 
    if ($timestamp =~ /.*\ \[(\d{1,2})\/(\w{1,3})\/(\d{4})\:(\d{1,2})\:(\d{1,2})\:(\d{1,2})\ .*$/){
      $year = $3;
      $mon  = $mon2num{ lc substr($2, 0, 3)}; 
      $mday = $1;
      $hour = $4;      
    
      $mon   = sprintf("%02d", $mon) or die "$entry_file: line $line_number: Couldn't parse Month\n";
      $mday  = sprintf("%02d", $mday) or die "$entry_file: line $line_number: Couldn't parse Day\n";
      $hour  = sprintf("%02d", $hour) or die "$entry_file: line $line_number: Couldn't parse Hour\n";

      # populate the hash
      $hitreport->{'hitcount'}++;
      $hitreport->{'status'}{$status}{'hitcount'}++;
      $hitreport->{$year}{'hitcount'}++;
      $hitreport->{$year}{$mon}{'hitcount'}++;
      $hitreport->{$year}{$mon}{$mday}{'hitcount'}++;
      $hitreport->{$year}{$mon}{$mday}{$hour}{'hitcount'}++;
      $hitreport->{$year}{$mon}{$mday}{$hour}{'status'}{$status}{'hitcount'}++;
      $hitreport->{$year}{$mon}{$mday}{$hour}{'user_agent'}{$user_agent}{'hitcount'}++;
 
      $filereport->{'hitcount'}++;
      $filereport->{$year}{'hitcount'}++;
      $filereport->{$year}{$mon}{'hitcount'}++;
      $filereport->{$year}{$mon}{$mday}{'hitcount'}++;
      $filereport->{$year}{$mon}{$mday}{$hour}{'hitcount'}++;
    } else {
      die "ERROR: $entry_file: line $line_number: Couldn't parse timestamp in file: $line \n";
    }
    $line_number++;
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
sub process_access_log_file_list {
  my $file_list = $_[0];
  open(FILELIST, $file_list) || die("Couldn't open: $!\n");
  logger("Processing File List: $file_list");
  foreach  my $entry_file (<FILELIST>) {
    read_access_log_file($entry_file);
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
          logger("Processed File: $entry_file -> $year-$mon-$mday-$hour:00:00\t$hits");
        }
      }
    }
  }
}

sub pad {
  my $to_pad  = $_[0];
  my $pad_len = $_[1];
  return sprintf("%${pad_len}s", $to_pad);
}

sub print_hitreport {
  # Print the results
  my @seen_statuses = sort keys %{$hitreport->{'status'}};
  my $header = "Time              \tStatus ";
  $header .= pad("Total", length($hitreport->{'hitcount'})) . " ";
  for my $status (@seen_statuses){
    $header .= pad($status, length($hitreport->{'status'}->{$status}->{'hitcount'})) . " ";
  }
  print $header . "\n";
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
          my @hits;
          my $pad_len = length($hitreport->{'hitcount'});
          if (length($hitreport->{'hitcount'}) < length("Total")){
            $pad_len = length("Total");
          }
          my $hits = $hitreport->{$year}->{$mon}->{$mday}->{$hour}->{'hitcount'};
          my $hits .= pad($hits, $pad_len);
          push(@hits, $hits);

          my @statuses = sort keys %{$hitreport->{$year}->{$mon}->{$mday}->{$hour}->{'status'}};
          for my $seen_status (@seen_statuses){
            $hitreport->{$year}{$mon}{$mday}{$hour}{'status'}{$seen_status}{'hitcount'} = 0 unless exists $hitreport->{$year}{$mon}{$mday}{$hour}{'status'}{$seen_status}{'hitcount'};
          }

          for my $attrib ( sort keys %{$hitreport->{$year}->{$mon}->{$mday}->{$hour}} ) {
            #print "Scanning /$attrib/\n";
            if ($attrib =~ /user_agent/){
            }
            if ($attrib =~ /status/){
              @statuses = sort keys %{$hitreport->{$year}->{$mon}->{$mday}->{$hour}->{'status'}};
              for my $status ( @statuses ){
                next unless ($status =~ /\d{3}/);
                my $status_hits = $hitreport->{$year}->{$mon}->{$mday}->{$hour}->{$attrib}->{$status}->{'hitcount'};
                my $pad_len = length($hitreport->{'status'}->{$status}->{'hitcount'});
                if ($pad_len < length($status)) {
                  $pad_len = length($status);
                }
                my $status_hits_padded = sprintf("%${pad_len}s", $status_hits);
                push(@hits, $status_hits_padded);
              }
            }
          }
          # stuff
          $hits = join(" ", @hits);
          my $seen = join(" ", @seen_statuses);
          my $timestamp = "$year-$mon-$mday $hour:00:00";
          print "$year-$mon-$mday $hour:00:00\t       $hits\n";
        }
      }
    }
  }
}
#print Dumper($hitreport);
