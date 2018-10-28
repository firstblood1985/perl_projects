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
    my $module = $data_sources{$data_source}->{datatype};
    my $pm = "$module\.pm";
    eval{
        require "$pm";
        $module->import();

        print "Loaded $pm\n";
        1;
    };
    my $processor = $module->new()->process($datasources{$data_source});
}else{
    die "unsupported data source\n";
}


