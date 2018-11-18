#!/usr/bin/perl -w
package SF;
use strict;
use Text::CSV;
use XML::LibXML;
use Config::Simple;
use Data::Dumper;
use Date::Simple;
use Date::Range;
use String::Util 'trim';
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
sub in_time_range{
    my ($start_date,$date_from_file,$time_range) = @_;
    my $start = new Date::Simple($start_date);
    my $end = $start+$time_range;
    my $date = new Date::Simple($date_from_file);

    my $range = new Date::Range($start,$end);
    if($range->includes($date))
    {
        return 1;
    }else{
        return 0;
    }

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

    my $print_csv = Text::CSV->new ( { binary => 1} )  # should set binary attribute.
                    or die "Cannot use CSV: ".Text::CSV->error_diag ();

    my @header_to_print;
    push(@header_to_print,$ds->{header}->{2});
    push(@header_to_print,$ds->{header}->{1});

    foreach(@$header)
    {
    push(@header_to_print,$ds->{header}->{$_});
    }

    $print_csv->print($output_fh,\@header_to_print);
    print $output_fh "\n";

    while ( my $row = $csv->getline( $input_fh) ) {
        #skip row 1 and 2
        if(1!= $. && 2!= $. && scalar(@$row) > 1)
        {
            my @results;
            my $sf_code_from_file = trim($row->[1]);
            if($sf_code_from_file eq $sf_code)
            {
                my $date_from_file = trim($row->[0]);
                if(in_time_range($start_date,$date_from_file,$time_range))
                {
                    push (@results,$sf_code);
                    push (@results,$date_from_file);
                    foreach(@$header)
                    {
                        push @results,trim($row->[$_-1]);
                    }
           $print_csv->print($output_fh,\@results);
           print $output_fh "\n";
                }
            }
        }
      }
}

1;
