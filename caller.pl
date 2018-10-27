#!/usr/bin/perl -w

use strict;
use IO::Pty::Easy;
my $call = "./test.pl";

my $pty = IO::Pty::Easy->new;
#open(TS,$call) || die "cannot execute $call: $!";
#while(<TS>){
#	print "$_";
#}
#close(TS) or die "error while running $call: $!";

$pty->spawn($call);
my $output='';
while($pty->is_active)
{
	$output = $pty->read(0);
	if(defined $output)
	{
		print "$output";
	}
}

$pty->close;