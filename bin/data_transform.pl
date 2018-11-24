#!/usr/bin/perl -w 
#
use Data::Dumper;
use Getopt::Long;


use FindBin qw($Bin);
use lib "$Bin/../lib";

use Configuration qw(get_datasources);
my $input_file;
my $output_file;
my $data_source;
my $help;

binmode STDOUT, ":utf8";

GetOptions(
    "help"=>\$help,
    "input_file=s"=>\$input_file,
    "output_file=s"=>\$output_file,
    "data_source=s"=>\$data_source
) or die "error in input options\n";
if($help)
{
    print "./data_transform.pl -input_file <input_file> -output_file <output_file> -data_source <AsianMetal|SF>\n";
    exit 0;
    
}
print "input file: $input_file\noutput file: $output_file\ndata source: $data_source\n";

my %data_sources = get_datasources();

if(exists $data_sources{$data_source})
{
    my $module = $data_sources{$data_source}->{datatype};
    my $pm = "$module\.pm";
    my $ds = $data_sources{$data_source};

    $ds->{name} = $data_source;
    $ds->{input} = $input_file;
    $ds->{output} = $output_file;
    eval{
        require "$pm";
        $module->import();

        print "Loaded $pm\n";
        1;
    };
    die $@ if $@;
    my $processor = $module->new()->process($ds);
}else{
    die "unsupported data source\n";
}


