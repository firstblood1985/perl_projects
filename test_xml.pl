#!/usr/bin/perl -w 
#
use Text::CSV;
use XML::LibXML;
use Data::Dumper;

binmode STDOUT, ":utf8";
my $parser = XML::LibXML->new();
my $doc = $parser->parse_file('sample_xml_data.xml');

my @nodes = $doc->getElementsByTagName('AMPrice');
open my $fh, ">:encoding(UTF-8)", "out.csv" or die "out.csv: $!";
my $csv = Text::CSV->new ({ binary => 1 });
my @header = ('PriceId','PriceName','PriceSpec','PriceUnit','PriceNumber','PriceShowDataTime');
$csv->print($fh,\@header);
print $fh "\n";

foreach my $node(@nodes)
{
    my @data;
    foreach my $child($node->findnodes('*'))
    {
        #print "node name: ".$child->nodeName." node value: ".$child->textContent."\n";
        push @data,$child->textContent;
    }
    $csv->print($fh,\@data);
    print $fh "\n";
}


