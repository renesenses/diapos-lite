#!/usr/bin/env perl

# test using pdf 

use PDF::WebKit;

my $kit = PDF::WebKit->new('http://localhost:3000/showbox/11');
my $file = $kit->to_file('/Users/bertrand/MY_GITHUB/diapos-lite/PRINTS/pdf');