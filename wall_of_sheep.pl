#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Term::ANSIColor;

#Attempt to prevent screen blanking
printf ("\033[9;%ld]", 0);

#Reset colors to normal white on black
print color("reset");

#super legit cross-platform screen clear
system(($^O eq 'MSWin32') ? 'cls' : 'clear');

while(my $line = <>){
	#Hope you like regexp.
	if ($line =~ /^(\w+) : (\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}):(\d{1,10}) -> USER: (.+) PASS: (.+)/){
		my $protocol = $1;
		my $ip = "$2.$3.$4.$5";
		my $port = $6;
		my $user = $7;
		my $pass = $8;
		my $ip_addr = pack("C4", $2,$3,$4,$5);
		my ($hostname) = (gethostbyaddr($ip_addr, 2))[0];
		
		my $scrubbed_pass = "";
		if(length($pass) > 1){
			$scrubbed_pass=substr($pass,0,1)."*****";
		}
		else{
			$scrubbed_pass="*******";
		}
		
		pick_color($protocol);	
		$protocol = sprintf '%9s', $protocol;
		$ip = sprintf '%15s', $ip;
		if(defined($hostname)){
			$hostname = sprintf '(%.*s)', 26, $hostname;
		}
		else{
			$hostname = "";
		}
		$user = sprintf '%.*s', 16, $user;
		$pass = sprintf '%.*s', 7, $scrubbed_pass;
		print pack("A10 A16 A29 A17 A8", $protocol, $ip, $hostname, $user, $pass);
		print "\n";
		print color("reset");
	}
}

sub pick_color{
	my $protocol = shift;
	given ($protocol) {
		when (/TELNET/) { print color("red") }
		when (/RLOGIN/) { print color("red") }
		when (/SSH/) { print color("red") }
		when (/VNC/) { print color("red") }
		
		when (/SMB/) { print color("magenta") }
		when (/LDAP/) { print color("magenta") }
	
		when (/ICQ/) { print color("green") }
		when (/MSN/) { print color("green") }
		when (/YMSG/) { print color("green") }
		when (/IRC/) { print color("green") }

		when (/HTTP/) { print color("blue") }
		when (/FTP/) { print color("blue") }
		when (/MYSQL/) { print color("blue") }
	
		when (/POP/) { print color("yellow") }
		when (/IMAP/) { print color("yellow") }
		when (/SMTP/) { print color("yellow") }
		when (/NNTP/) { print color("yellow") }

		when (/SOCKS5/) {print color("cyan") }
		when (/CVS/) {print color("cyan") }
	}
}
