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
};

my $id = '1';

my $rse = $schema->resultset('Event')->search( {'box_id' => $id} )->hashref_rs;
my %hash_pk = map { $_->{event_id} => $_ } $rse->all; 

my @elist = keys (%hash_pk);
my @esorted_list = nsort( @elist );

print "E LIST :\n";
foreach my $e (@elist) {
	print "\t",$e,"\n";
}

print "E SORTED :\n";
foreach my $e (@esorted_list) {
	print "\t",$e,"\n";
}

for my $event (@esorted_list) {
	print "EVENT N° :",$event,"\n";
	my $rss = $schema->resultset('Sub')->search(
		box_id => { -in => $rse->get_column('box_id')->as_query },
		event_id => { -in => $rse->get_column('event_id')->as_query },
	)->hashref_rs;
	my %hashsub_pk = map { $_->{sub_range} => $_ } $rss->all;

	my @slist = keys (%hashsub_pk);
	my @ssorted_list = sort {subeventcmp($a,$b) }( @slist );

	print "S LIST :\n";
	foreach my $s (@slist) {
		print "\t",$s,"\n";
	}

	print "E SORTED :\n";
	foreach my $s (@ssorted_list) {
		print "\t",$s,"\n";
	}
}