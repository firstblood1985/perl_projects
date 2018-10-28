package Configuration;
use strict;

use Exporter 'import';
our @EXPORT_OK = qw(get_datasources);

my  %data_sources = (
    'AsianMetal'=>{
        'name'=>'AsinaMetal',
        'datatype'=>'XML',
        'header'=>['PriceId','PriceName','PriceLow','PriceHigh','PriceAvg']
    }
);

sub call{
    print "hello\n";
}

sub get_datasources{
    return %data_sources; 
}

1;
