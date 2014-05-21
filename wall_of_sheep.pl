#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Term::ANSIColor;

use constant REVEAL_DIVISOR => 30;
use constant PASS_LENGTH => 20;
use constant PASS_SUFFIX => '*' x PASS_LENGTH;
use constant WHITELIST_FILE => '.whitelist';

my (%idiots, %whitelist);

# Newline delimited list of hostnames
if ( -f WHITELIST_FILE) {
	open (my $fh, WHITELIST_FILE);
	my @liney_parts;
	foreach my $line (<$fh>) {
		@liney_parts = split /\s+/,$line;
		$whitelist{$liney_parts[0]} =  [ @liney_parts[1 .. $#liney_parts] ];
	}
	close $fh;
}

#Attempt to prevent screen blanking
printf ("\033[9;%ld]", 0);

#Reset colors to normal white on black
print color("reset");

#super legit cross-platform screen clear
system(($^O eq 'MSWin32') ? 'cls' : 'clear');

while(my $line = <>){
	#Hope you like regexp.
	if ($line =~ /^(\w+) : (\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}):(\d{1,10}) -> USER: (.+) PASS: (.*)/){
		my $protocol = $1;
		my $ip = "$2.$3.$4.$5";
		my $port = $6;
		my $user = $7;
		my $pass = $8;
		my $ip_addr = pack("C4", $2,$3,$4,$5);
		my ($hostname) = (gethostbyaddr($ip_addr, 2))[0];

		next if ($protocol ~~ @{$whitelist{$hostname}});
		next if ($protocol ~~ @{$whitelist{$ip}});

		$idiots{$ip}++;
		
		my $scrubbed_pass = "";
		if(length($pass) > 1){
			$scrubbed_pass=substr($pass,0,($idiots{$ip} / REVEAL_DIVISOR) + 1).PASS_SUFFIX;
			$scrubbed_pass = $pass if ($scrubbed_pass =~ /$pass/);
		}
		else{
# What the hell, this user is an idiot. Let him suffer.
			$scrubbed_pass = $pass;
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
		$pass = sprintf '%.*s', PASS_LENGTH, $scrubbed_pass;
		say pack("A10 A16 A29 A17 A".PASS_LENGTH, $protocol, $ip, $hostname, $user, $pass);
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
