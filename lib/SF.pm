#!/usr/bin/perl -w
package SF;
use strict;
use Text::CSV;
use XML::LibXML;
use Config::Simple;
use Data::Dumper;
use utf8;

sub new{
    my $class = shift;
    my $self->{datatype}='SF';
    $self->{handler} = {
    SF=>\&process_SF,
    };
    bless $self,$class;
    return $self;
}

sub process{
    my ($self,$ds) = @_;
    my $ds_name = $ds->{name};
    $self->{handler}->{$ds_name}->($ds);
}
sub get_conf{

}

sub process_SF{
    print "processing SF\n";
    my $ds = shift;
    my $conf = $ds->{config} ||"SF_config";
    my $cfg = new Config::Simple($conf);

    my $input = $cfg->param('input');
    my $output = $cfg->param('output');
    my $start_date = $cfg->param('start_date');
    my $time_range = $cfg->param('time_range');
    my $sf_code = $cfg->param('sf_code');
    my $header = $cfg->param('header');

    #remove the first line of data
    open my $input_fh, "<:encoding(UTF-8)", $input or die "$input: $!";

    open my $output_fh, ">:encoding(UTF-8)", $output or die "$output: $!";
    my $csv = Text::CSV->new ( { binary => 1,sep_char => "|"} )  # should set binary attribute.
                    or die "Cannot use CSV: ".Text::CSV->error_diag ();

    while ( my $row = $csv->getline( $input_fh) ) {
        #skip row 1 and 2
        if(1!= $. && 2!= $.)
        {
            print "@$row";
        }
      }
}

1;
