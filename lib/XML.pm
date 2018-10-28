#!/usr/bin/perl -w
package XML;
use strict;

sub new{
    my $class = shift;
    my $self->{datatype}='XML';
    bless $self,$class;
    return $self;
}

sub process{
    print "process\n";
    my $ds = shift;

    my $ds_name = $ds->{name};
}
1;
