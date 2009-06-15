#! /usr/bin/perl 

use warnings;
use strict;

my $passwd_file = "/etc/passwd";
my $shadow_file = "/etc/shadow";
my $group_file  = "/etc/group";

  my $user = $ARGV[0];
  # qchahic:x:500:500:Charles Hicks:/home/qchahic:/bin/bash
  my @passwd_details = split(/:/,`grep $user $passwd_file`);
  my @shadow_details = split(/:/, `grep $user $shadow_file`);
  my @group_details = split(/:/, `grep $passwd_details[3] $group_file`);

  my $uname = $passwd_details[0];
  my $uid = $passwd_details[2];
  my $gid = $passwd_details[3];
  my $gname = $group_details[0];
  my $comments = $passwd_details[4];
  my $home_dir = $passwd_details[5];
  my $shell = $passwd_details[6];
  my $pass_status = $shadow_details[1];
  chomp $shell;

  if ($pass_status =~ /!!/) {
    $pass_status = "NP";
  } elsif ( $pass_status =~ /^[\!]/ ) {
    $pass_status = "LK";
  } elsif ( $pass_status =~ /^$/ ) {
    $pass_status = "NP";
  } else {
    $pass_status = "PS";
  }   

  # dman:105:dman:103::/export/home/dman:/usr/bin/bash:LK:061008:-1:-1:-1:-1:0
  
  print "$uname:$uid:$gname:$gid:$comments:$home_dir:$shell:$pass_status:000000:-1:-1:-1:-1:000000\n";
  

