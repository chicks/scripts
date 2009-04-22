#! /usr/bin/perl -w

use Data::Dumper;

# some Objects to help out

package Helper;
sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub dec2bin {
    my $str = unpack("B32", pack("N", shift));
    $str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
    return $str;
}

package TCPStream;

package TCPStreamFactory;
# takes a bunch of TCPPackets and returns an array containing the reassembled TCP streams

sub new {
	
	my $self = {
	};
};

package HTTPPacket;

sub new {
	my $self = {
		status	=> $status,
		header	=> $header,
		body	=> $body	
	};
	bless $self, 'HTTPPacket';
	return $self;
}

package TCPPacket;

#  TCP Header Format
#
#    0                   1                   2                   3   
#    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |          Source Port          |       Destination Port        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                        Sequence Number                        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Acknowledgment Number                      |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |  Data |           |U|A|P|R|S|F|                               |
#   | Offset| Reserved  |R|C|S|S|Y|I|            Window             |
#   |       |           |G|K|H|T|N|N|                               |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |           Checksum            |         Urgent Pointer        |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                    Options                    |    Padding    |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#   |                             data                              |
#   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

sub new {
	($src_port,$dst_port,$seq_num,$ack_num,$data_offset_reserved_flags,$window,$checksum,$urgent_pointer,$payload) = unpack('nnNNB16nH4na*',$_[1]);

	# Header Length
	
	# Split things up
	$data_offset = ( Helper::bin2dec(substr($data_offset_reserved_flags,0,4)) * 32 ) / 8; 
	$reserved = substr($data_offset_reserved_flags,4,10);
	$flags = substr($data_offset_reserved_flags,10,16);
	#print "FLAGS: $flags\n";
	
	my $self = {
		source_port	 => $src_port,
		destination_port => $dst_port,
		seq_number	 => $seq_num,
		ack_number	 => $ack_num,
		header_length	 => $data_offset,
		flags		 => $flags,
		window		 => $window,
		checksum 	 => $checksum,
		payload 	 => $payload
	};
	bless $self, 'TCPPacket';
	return $self;
}

sub source_port {
    my $obj = shift;
    @_ ? $obj->{source_port} = shift            # modify attribute
       : $obj->{source_port};                   # retrieve attribute
}

sub destination_port {
    my $obj = shift;
    @_ ? $obj->{destination_port} = shift            # modify attribute
       : $obj->{destination_port};                   # retrieve attribute
}

sub seq_number {
    my $obj = shift;
    @_ ? $obj->{seq_number} = shift            # modify attribute
       : $obj->{seq_number};                   # retrieve attribute
}

sub ack_number {
    my $obj = shift;
    @_ ? $obj->{ack_number} = shift            # modify attribute
       : $obj->{ack_number};                   # retrieve attribute
}

sub header_length {
    my $obj = shift;
    @_ ? $obj->{header_length} = shift            # modify attribute
       : $obj->{header_length};                   # retrieve attribute
}

sub flags {
    my $obj = shift;
    @_ ? $obj->{flags} = shift            # modify attribute
       : $obj->{flags};                   # retrieve attribute
}

sub window {
    my $obj = shift;
    @_ ? $obj->{window} = shift            # modify attribute
       : $obj->{window};                   # retrieve attribute
}

sub checksum {
    my $obj = shift;
    @_ ? $obj->{checksum} = shift            # modify attribute
       : $obj->{checksum};                   # retrieve attribute
}

sub payload {
    my $obj = shift;
    @_ ? $obj->{payload} = shift            # modify attribute
       : $obj->{payload};                   # retrieve attribute
}

sub compute_checksum {
	
}

sub decode_binary_flags {
	@bits = split(//,$_[0]);
	#print "Bits: " . join(",",@bits);
	#@key = ("U","A","P","R","S","F");
	$return_string = " ";

	for ($position=0; $position<6; $position++) {
		if ($position==0 && $bits[0] == 1) {
			$return_string=$return_string . "URG ";
		} elsif ($position==1 && $bits[1] == 1) {
			$return_string=$return_string . "ACK ";
		} elsif ($position==2 && $bits[2] == 1) {
			$return_string=$return_string . "PSH ";
		} elsif ($position==3 && $bits[3] == 1) {
			$return_string=$return_string . "RST ";
		} elsif ($position==4 && $bits[4] == 1) {
			$return_string=$return_string . "SYN ";
		} elsif ($position==5 && $bits[5] == 1) {
			$return_string=$return_string . "FIN ";
		} else {
		}
	}
	
	return $return_string;
}

sub to_s {
    	my $obj = shift;
	$to_r = "\tSource Port: " . $obj->source_port . "\n";
	$to_r = $to_r . "\tDestination Port: " . $obj->destination_port . "\n";
	$to_r = $to_r . "\tSeq. Number: " . $obj->seq_number . "\n";
	$to_r = $to_r . "\tAck. Number: " . $obj->ack_number . "\n";
	$to_r = $to_r . "\tFlags: |" . $obj->flags ."| (" . decode_binary_flags($obj->flags) . ")" . "\n";
	$to_r = $to_r . "\t       |UAPRSF|\n";
	$to_r = $to_r . "\tWindow: " . $obj->window . "\n";
	$to_r = $to_r . "\tChecksum: " . $obj->checksum . "\n";
	$to_r = $to_r . "\tPayload Size: " . length($obj->payload) . "\n\n";
	return $to_r;
}

package IPPacket;

sub new {
	# we're REALLY only interested in the source, destination, payload, and protocol
	($version_and_hdr_len,$tos,$total_len,$id,$flags_and_offset,$ttl,$protocol,$checksum,$src_addr1,$src_addr2,$src_addr3,$src_addr4,$dst_addr1,$dst_addr2,$dst_addr3,$dst_addr4,$payload) = unpack('B8B8B16H4B16B8H2H4CCCCCCCCa*',$_[1]);
	
	# Version is first 4 bits
	$version = Helper::bin2dec(substr($version_and_hdr_len,0,4));
	# Header Length is last 4 bits
	$hdr_len = (Helper::bin2dec(substr($version_and_hdr_len,5,8)) * 4);
	# Total Length
	$total_len = (Helper::bin2dec($total_len));
	#print "VER and HEADER: $version_and_hdr_len\nVER: $version\nHEADER: $hdr_len\n";
	
	# Flags is first 3 bits
	$flags = Helper::bin2dec(substr($flags_and_offset,0,3));
	# Offset is last 13 bits
	$offset = Helper::bin2dec(substr($flags_and_offset,3,16));
	#print "FLAGS AND OFFSET: $flags_and_offset\nFLAGS: $flags\nOFFSET: $offset\n";

	# TTL
	$ttl = Helper::bin2dec($ttl);

	# join the addresses
	$src_addr=join(".", $src_addr1, $src_addr2, $src_addr3, $src_addr4);
	$dst_addr=join(".", $dst_addr1, $dst_addr2, $dst_addr3, $dst_addr4);
	
	#print "----------------\nProtocol: $protocol\nChecksum: $checksum\nSource: $src_addr\nDestination: $dst_addr\n";
	my $self = {
		version		=> $version,
		header_length	=> $hdr_len,
		tos		=> $tos,
		total_length	=> $total_len,
		id		=> $id,
		flags		=> $flags,
		fragment_offset	=> $offset,
		ttl		=> $ttl,
		protocol	=> $protocol,
		header_checksum	=> $checksum,
		source_ip	=> $src_addr,
		destination_ip	=> $dst_addr,
		#options	=> undef,
		payload	=> $payload
	};
	bless $self, 'IPPacket';
	return $self;
}

sub version {
    my $obj = shift;
    @_ ? $obj->{version} = shift            # modify attribute
       : $obj->{version};                   # retrieve attribute
}

sub header_length {
    my $obj = shift;
    @_ ? $obj->{header_length} = shift            # modify attribute
       : $obj->{header_length};                   # retrieve attribute
}

sub tos {
    my $obj = shift;
    @_ ? $obj->{tos} = shift            # modify attribute
       : $obj->{tos};                   # retrieve attribute
}

sub total_length {
    my $obj = shift;
    @_ ? $obj->{total_length} = shift            # modify attribute
       : $obj->{total_length};                   # retrieve attribute
}

sub id {
    my $obj = shift;
    @_ ? $obj->{id} = shift            # modify attribute
       : $obj->{id};                   # retrieve attribute
}

sub flags {
    my $obj = shift;
    @_ ? $obj->{flags} = shift            # modify attribute
       : $obj->{flags};                   # retrieve attribute
}

sub fragment_offset {
    my $obj = shift;
    @_ ? $obj->{fragment_offset} = shift            # modify attribute
       : $obj->{fragment_offset};                   # retrieve attribute
}

sub ttl {
    my $obj = shift;
    @_ ? $obj->{ttl} = shift            # modify attribute
       : $obj->{ttl};                   # retrieve attribute
}

sub protocol {
    my $obj = shift;
    @_ ? $obj->{protocol} = shift            # modify attribute
       : $obj->{protocol};                   # retrieve attribute
}

sub header_checksum {
    my $obj = shift;
    @_ ? $obj->{header_checksum} = shift            # modify attribute
       : $obj->{header_checksum};                   # retrieve attribute
}

sub source_ip {
    my $obj = shift;
    @_ ? $obj->{source_ip} = shift            # modify attribute
       : $obj->{source_ip};                   # retrieve attribute
}

sub destination_ip {
    my $obj = shift;
    @_ ? $obj->{destination_ip} = shift            # modify attribute
       : $obj->{destination_ip};                   # retrieve attribute
}

sub payload {
    my $obj = shift;
    @_ ? $obj->{payload} = shift            # modify attribute
       : $obj->{payload};                   # retrieve attribute
}

sub decode_protocol {
	$protocol_in = $_[0];
	$protocol_out = "";
	if ( $protocol_in == 06 ) {
		$protocol_out = "TCP";
	} elsif ( $protocol_in == 17 ) {
		$protocol_out = "UDP";
	} elsif ( $protocol_in == 01 ) {
		$protocol_out = "ICMP";
	} else {
		$protocol_out = "Unsupported";
	}
	return $protocol_out;
}
sub to_s {
    	my $obj = shift;
	$to_r = "Source IP: " . $obj->source_ip . "\n";
	$to_r = $to_r . "Destination IP: " . $obj->destination_ip . "\n";
	$to_r = $to_r . "Protocol: " . decode_protocol($obj->protocol) . "\n";
	#$to_r = $to_r . "Protocol: " . $obj->protocol . " (" . decode_protocol($obj->protocol) . ")\n";
	return $to_r;
}

package EthernetFrame;

sub new {
	($ether_dest,$ether_src,$ether_type,$ether_data) = unpack('H12H12H4a*',$_[1]);
	my $self = {
		source_mac    => $ether_src,
		destination_mac      => $ether_dest,
		type      => $ether_type,
		payload   => $ether_data
	};
	bless $self, 'EthernetFrame';
	return $self;
}

sub source_mac {
    my $obj = shift;
    @_ ? $obj->{source_mac} = shift            # modify attribute
       : $obj->{source_mac};                   # retrieve attribute
}

sub destination_mac {
    my $obj = shift;
    @_ ? $obj->{destination_mac} = shift            # modify attribute
       : $obj->{destination_mac};                   # retrieve attribute
}

sub type {
    my $obj = shift;
    @_ ? $obj->{type} = shift            # modify attribute
       : $obj->{type};                   # retrieve attribute
}

sub payload {
    my $obj = shift;
    @_ ? $obj->{payload} = shift            # modify attribute
       : $obj->{payload};                   # retrieve attribute
}

sub to_s {
}

package AGW;

use Net::TcpDumpLog;

$log=Net::TcpDumpLog->new();
#print Data::Dumper->Dump([$log]);
$log->read("sample.out.tcpdump");

@indexes=$log->indexes;

@tcp_packets = undef;

foreach $index (@indexes) {
	# TCPDump Header (not the packet header)
	($length_orig,$length_incl,$drops,$secs,$msecs) = $log->header($index);
	

	# Full Decode
	$data=$log->data($index);

	# Build an EthernetFrame object
	my $ef = new EthernetFrame($data);

	# Build an IPPacket object
	my $ip_packet = new IPPacket($ef->payload);

	# Scope our TCP object
	my $tcp_packet = undef;	

	# format our timestamp Month Date, Year Hour:Minute:Second.Microsecond
	#@arrival_time = localtime($secs);
	#$arrival_time = "$arrival_time[4] $arrival_time[7], $arrival_time[5] $arrival_time[2]:$arrival_time[1]:$arrival_time[0].$msecs";
	use POSIX qw(strftime);
        $arrival_time = (strftime "%a %b %e %Y %H:%M:%S", localtime($secs)) . ".$msecs";
	
	# TCP?
	if ($ip_packet->protocol == 0x06) {
		$tcp_packet = new TCPPacket($ip_packet->payload);
	
		print "+--------------------------------------+\n";
		print "+ Frame Number: $index ($length_orig bytes on wire, $length_incl bytes captured)\n";	
		print "+\tArrival Time:\t$arrival_time\n";
		print "+\tFrame Number:\t$index\n";
		print "+\tPacket Length:\t$length_orig bytes\n";
		print "+\tCapture Length:\t$length_incl bytes\n";
		print "+ Layer 2: " . $ef->source_mac . " -> " . $ef->destination_mac . "\n";
		print "+\tSource MAC:\t" . $ef->source_mac . "\n";
		print "+\tDest. MAC:\t" . $ef->destination_mac . "\n";
		print "+\tType:\t\t0x" . $ef->type . "\n";
		print "+ Layer 3: " . $ip_packet->source_ip . ":" . $tcp_packet->source_port . " -> " . $ip_packet->destination_ip . ":" . $tcp_packet->destination_port . "\n";
		print "+\tVersion:\t" . $ip_packet->version . "\n";
		print "+\tHeader Length:\t" . $ip_packet->header_length . " bytes\n";
		print "+\tDiff Serv:\t" . $ip_packet->tos . "\n";
		print "+\tTotal Length:\t" . $ip_packet->total_length . " bytes\n";
		print "+\tIdentification:\t" . $ip_packet->id . "\n";
		print "+\tIP Flags:\t" . $ip_packet->flags . "\n";
		print "+\tFrag. Offset:\t" . $ip_packet->fragment_offset . "\n";
		print "+\tTime to Live:\t" . $ip_packet->ttl . "\n";
		print "+\tHeader Chksum:\t" . $ip_packet->header_checksum . "\n";
		print "+\tSource. IP:\t" . $ip_packet->source_ip . "\n";
		print "+\tDest. IP:\t" . $ip_packet->destination_ip . "\n";
		print "+ Layer 4: " . $tcp_packet->source_port . ":" . $tcp_packet->seq_number . " (seq) -> " . $tcp_packet->destination_port . ":" . $tcp_packet->ack_number . " (ack)\n";
		print "+\tSource Port:\t" . $tcp_packet->source_port . "\n";
		print "+\tDest. Port:\t" . $tcp_packet->destination_port . "\n";
		print "+\tSeq. Number:\t" . $tcp_packet->seq_number . "\n";
		print "+\tAck. Number:\t" . $tcp_packet->ack_number . "\n";
		print "+\tTCP Hdr Length:\t" . $tcp_packet->header_length . " bytes\n";
		print "+\tTCP Flags:\t" . $tcp_packet->flags . " (" . TCPPacket::decode_binary_flags($tcp_packet->flags) . ")\n";
		print "+\tTCP Window:\t" . $tcp_packet->window . "\n";
		print "+\tTCP Checksum:\t0x" . $tcp_packet->checksum . "\n";
	
		if ( length($tcp_packet->payload) > 10 ) {
		print "Payload:\n";
			print $tcp_packet->payload . "\n";
		};
	} else {
		print "Sorry! IP Protocol: " . $ip_packet->protocol . " is not supported!\n";
	}	
	
}
