#!/usr/bin/env perl
# GW

use Diapos::Schema;
use Data::Dumper;
use Carp;
use Sort::Naturally;

my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

sub subeventcmp {
	$_[0] =~ /^([0-9]+)/;
	$A = $1;
	$_[1]=~ /^([0-9]+)/;
	$B = $1;
	
	return $A <=> $B;
}

my $hashref_boxes_pk = $schema->resultset('Box')->search( {} )->hashref_pk;


foreach my $boxid (nsort ( keys $hashref_boxes_pk )) {
	print $boxid,"\n";
#	$hashref_boxes_pk{$boxid}->{box_id},"\n";
}