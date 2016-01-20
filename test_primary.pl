#!/usr/bin/env perl
# GW

use Diapos::Schema;
use Data::Dumper;
use Carp;





my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

my @primary_columns = $schema->source('Event')->primary_columns;

my %pkeys;
foreach my $col (@primary_columns ) {
	$pkeys{$col}++;
	}
	
print Dumper %pkeys;

croak "Not a column key." if ($pkeys{'event_id'} != 1 );
	
#print Dumper @primary_columns;