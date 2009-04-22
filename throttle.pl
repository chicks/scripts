#! /usr/bin/perl -w

use strict;

sub trim($) {
        my $string = shift;
        chomp $string;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}

sub timestamp {
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
        my $timestamp = sprintf("%4d-%02d-%02dT%02d:%02d:%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
        return $timestamp;
}

my %DRS = (
#    AIR => {
#        backup    => "/opt/temp/AIR_backup",
#        incoming  => "/export/home/minsat/DRS/AIR",
#       max_files => 20,
#       pad       => "   ",
#       filter    => "AIR",
#    },
    CDR => {
        backup    => "/opt/temp/CDR_backup",
        incoming  => "/export/home/minsat/DRS/CDR",
        max_files => 10,
        pad       => "   ",
        filter    => "TTFILE",
    },
    SDPAdj => {
        backup    => "/opt/temp/SDPAdj_backup",
        incoming  => "/export/home/minsat/DRS/SDPAdj",
        max_files => 30,
        pad       => "",
        filter    => "SDPCDR",
    },
#    SDPLC => {
#        backup    => "/opt/temp/SDPLC_backup",
#        incoming  => "/export/home/minsat/DRS/SDPLC",
#       max_files => 20,
#       pad       => " ",
#       filter    => "SDPCDR",
#    },
);

open (LOG, ">>throttle.log");
for my $drs_type ( keys %DRS ) {
    # Translate the Hash Values for cleaner code.
    my $backup     = $DRS{$drs_type}{'backup'};
    my $incoming   = $DRS{$drs_type}{'incoming'};
    my $max_files  = $DRS{$drs_type}{'max_files'};
    my $pad        = $DRS{$drs_type}{'pad'};
    my $filter     = $DRS{$drs_type}{'filter'};
    my $pad_str    = $drs_type . $pad;

    # Filesystem Operations
    my $file_count = trim(`ls $incoming | grep $filter | wc -l`);
    my $backlog    = trim(`ls $backup | grep $filter | wc -l`);
    my $total      = $file_count + $backlog;

    print LOG &timestamp . " [   Status: $pad_str ] Queue = $file_count, Backlog = $backlog, Total = $total  \n";

    # If the number of files in the incoming directory exceeds the max limit
    # determine the delta, and move that many files into the Incoming Queue directory
    if ($file_count < $max_files) {

        my $file_delta = $max_files - $file_count;
        my @next_files = split(/\n/, `ls -rt $backup | grep $filter | tail -$file_delta`);
        print LOG &timestamp . " [ Globbing: $pad_str ] Selected $file_delta files!\n";

        # Loop through the list of files and move them.
        foreach my $next_file (@next_files) {

            $next_file = trim($next_file);
            my $cmd    = "mv $backup/$next_file $incoming";
            `$cmd`;
            print LOG &timestamp . " [   Moving: $pad_str ] $cmd\n";

        }

    } else {
        print LOG &timestamp . " [ Skipping: $pad_str ] $file_count >= $max_files \n";
    }
}
print LOG "\n";
close (LOG);
