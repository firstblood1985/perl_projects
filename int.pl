#!/usr/bin/perl -w
#
use strict;

sub findInt{
    my $metrics = shift;
    my $toFind = shift;
    my $rowCount= 0;
    my $colCount = 0;
    foreach my $row in (@$metrics)
    {
        #  if( grep $_ == $toFind @$row )
        #   {

        # }
            $colCount = 0;
            foreach my $num in (@$row)
                {
                    if ($num == $toFind)
                    {
                        return ($rowCount, $colCount);    
                   }
                $colCount ++;
                }
        $rowCount ++;
    }


}
