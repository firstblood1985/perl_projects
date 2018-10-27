#!/usr/bin/perl -w
package Person;
use strict;

sub new {
    my $class = shift;
    my $self->{"name"} = shift;
    $self->{"sex"} = shift;
    bless $self, $class;
    return $self;
}


1;
