#!/usr/bin/perl -w 
#
use Text::CSV;
use XML::LibXML;
use Data::Dumper;
use Getopt::Long;


use FindBin qw($Bin);
use lib "$Bin/../lib";

use Configuration qw(get_datasources);
my $input_file;
my $output_file;
my $data_source;

binmode STDOUT, ":utf8";

GetOptions(
    "input_file=s"=>\$input_file,
    "output_file=s"=>\$output_file,
    "data_source=s"=>\$data_source
) or die "error in input options\n";

print "input file: $input_file\noutput file: $output_file\ndata source: $data_source\n";

my %data_sources = get_datasources();

if(exists $data_sources{$data_source})
{
    my $func = $data_source.$data_sources{$data_source}->{datatype};
    # print "$func\n";
    my $module;
    eval{
        require "$data_sources{$data_source}->{datatype}";
        $module = Module->import("$data_sources{$data_source}->{datatype}");
    }
    my $processor = $module->new();
    $processor->process();

}else{
    die "unsupported data source\n";
}

=cut
my $parser = XML::LibXML->new();


my $doc = $parser->parse_file('sample_xml_data.xml');

my @nodes = $doc->getElementsByTagName('AMPrice');
open my $fh, ">:encoding(UTF-8)", "out.csv" or die "out.csv: $!";
my $csv = Text::CSV->new ({ binary => 1 });
my @header = ('PriceId','PriceName','PriceSpec','PriceUnit','PriceNumber',"PriceShowDataTime");
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
=cut

