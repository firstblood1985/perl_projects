#!/usr/bin/perl -w
package XML;
use strict;
use Text::CSV;
use XML::LibXML;
use Data::Dumper;

sub new{
    my $class = shift;
    my $self->{datatype}='XML';
    bless $self,$class;
    return $self;
}

sub process{
    my ($self,$ds) = @_;

    my $ds_name = $ds->{name};
    print "process $ds_name\n";

    #eval("process_$ds_name($ds);"); warn $@ if $@;

    process_AsianMetal($ds);
}
sub process_AsianMetal{
    print "inside process_AsianMetal\n";
    my $ds = shift;
    my $input = $ds->{input};
    my $output= $ds->{output};
    my $parser = XML::LibXML->new();
    my $doc = $parser->parse_file($input);

    my @nodes = $doc->getElementsByTagName('AMPrice');
    open my $fh, ">:encoding(UTF-8)", $output or die "$output: $!";
    my $csv = Text::CSV->new ({ binary => 1 });

    my $header = $ds->{header};
    $csv->print($fh,$header);
    print $fh "\n";

    foreach my $node(@nodes)
    {
     my $data;
     foreach my $child($node->findnodes('*'))
     {
         if($child->nodeName eq 'priceId')
         {
            $data->{PriceId} = $child->textContent;
         }
         if($child->nodeName eq 'priceShowDateTime')
         {
            $data->{PriceShowDateTime} = $child->textContent;
         }
     
         if($child->nodeName eq 'priceNumber')
         {
             #$data->{PriceShowDataTime} = $child->textContent;
             my ($low,$high) = split '-',$child->textContent;
             my $avg = ($low+$high)/2;
             $data->{PriceLow} = $low;
             $data->{PriceHigh} = $high;
             $data->{PriceAvg} = $avg;
         }
     }
      my @csv_data;
        foreach my $head(@$header)
        {
            push @csv_data,$data->{$head};
        }
        $csv->print($fh,\@csv_data);
        print $fh "\n";
     }

     print "process AsianMetal success\n";
}

1;
