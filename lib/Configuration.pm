package Configuration;
use strict;

use Exporter 'import';
our @EXPORT_OK = qw(get_datasources);
use utf8;

my  %data_sources = (
    'AsianMetal'=>{
        'name'=>'AsinaMetal',
        'datatype'=>'XML',
        'header'=>['PriceId','PriceShowDateTime','PriceLow','PriceHigh','PriceAvg']
    },
    'SF'=>{
        'name'=>'SF',
        'datatype'=>'SF',
        'header'=>{1=>"交易日期",
                   2=>"品种代码",
                   3=>"昨结算",
                   4=>"今开盘",
                   5=>"最高价",
                   6=>"最低价",
                   7=>"今收盘",
                   8=>"今结算",
                   9=>"涨跌1",
                   10=>"涨跌2",
                   11=>"成交量（手）",
                   12=>"空盘量",
                   13=>"增减量",
                   14=>"成交额（万元）",
                   15=>"交割结算价"
               }
    }
);

sub get_datasources{
    return %data_sources; 
}

1;
