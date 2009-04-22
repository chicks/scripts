#! /usr/bin/perl -w

use strict;
use Net::Ping;

my $ip_prefix = "172.30.1.";
my $ip_cur = 1;
my $ip_end = 255;

while($ip_cur <= $ip_end) {
        my $host = $ip_prefix . $ip_cur;

        my $p = Net::Ping->new("icmp");
        my $result = $p->ping($host, 1);

        my @arp = split / /, `arp $host`;

        my $mac = $arp[3];
        chomp $mac;

        if ($result) {
                print "$host\talive\t$mac\n";
        } else {
                print "$host\tdown\t$mac\n";
        }
        $p->close();
        $ip_cur++;
}

