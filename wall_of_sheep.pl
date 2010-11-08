#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;
use Switch;

#Attempt to prevent screen blanking
printf ("\033[9;%ld]", 0);

#Reset colors to normal white on black
print color("reset");

#super legit cross-platform screen clear
system(($^O eq 'MSWin32') ? 'cls' : 'clear');

while(<>){
	my $line = $_;
	#Hope you like regex.
	if ($line =~ m/^(.*) : ([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3}).([0-9]{1,3}):([0-9]{1,10}) -> USER: (.*) PASS: (.*)/){
		my $protocol = $1;
		my $ip = $2.".".$3.".".$4.".".$5;
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
	switch ($protocol) {
		case /TELNET/ { print color("red") }
		case /RLOGIN/ { print color("red") }
		case /SSH/ { print color("red") }
		case /VNC/ { print color("red") }
		
		case /SMB/ { print color("magenta") }
		case /LDAP/ { print color("magenta") }
	
		case /ICQ/ { print color("green") }
		case /MSN/ { print color("green") }
		case /YMSG/ { print color("green") }
		case /IRC/ { print color("green") }

		case /HTTP/ { print color("blue") }
		case /FTP/ { print color("blue") }
		case /MYSQL/ { print color("blue") }
	
		case /POP/ { print color("yellow") }
		case /IMAP/ { print color("yellow") }
		case /SMTP/ { print color("yellow") }
		case /NNTP/ { print color("yellow") }

		case /SOCKS5/ {print color("cyan") }
		case /CVS/ {print color("cyan") }
	}
}
