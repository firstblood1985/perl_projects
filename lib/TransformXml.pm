#!/usr/bin/perl -w
#
package XML;
use strict;

sub new{
    my $class = shift;
    bless $self,$class;
    return $self;
}

sub process{
    print "process\n";
}
1;
