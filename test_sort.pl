#!/usr/bin/env perl
# GW

use Diapos::Schema;
use Data::Dumper;
use Carp;
use Sort::Naturally;

my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

my $boxid = '4';
my $rse = $schema->resultset('Event')->search( {'box_id' => $boxid} )->hashref_rs;

my %hash_pk = ();

my @primary_columns = $schema->source('Event')->primary_columns;
	
my %pkeys;
foreach my $col (@primary_columns ) {
	$pkeys{$col}++;
}
croak "Not a column key." if ($pkeys{event_id} != 1 );
		
%hash_pk = map { $_->{event_id} => $_ } $rse->all;

#print Dumper(%hash_pk);

sub subeventcmp {
	$_[0] =~ /^([0-9]+)/;
	$A = $1;
	$_[1]=~ /^([0-9]+)/;
	$B = $1;
	
	return $A <=> $B;
}

for my $event ( nsort ( keys ( %hash_pk )) ){
#for my $event ( sort { $hash_pk{$a}->{event_id} <=> $hash_pk{$b}->{event_id} } keys ( %hash_pk ) ){
#	print $hash_pk{$event}->{event_id},"\n";
	my $rss = $schema->resultset('Sub')->search({'event.event_id' => $event},{join => [qw/ event /],})->hashref_rs;

#	print Dumper($rss);

	my %hashsub_pk = map { $_->{sub_range} => $_ } $rss->all;
	
	print $event,"\n";

	for my $sub ( sort { subeventcmp($a, $b) } keys ( %hashsub_pk ) ){
		
#	for my $sub ( nsort ( keys ( %hashsub_pk )) ){
		print "\t",$sub,"\n";
	}
}







#while (my $row = $rse->next) {
#    print Dumper $row;
#}
#my $hashref_firstevents = $schema->resultset('Event')->search( {'box_id' => $boxid} )->hashref_first;
#print Dumper $hashref_firstevents;


#print Dumper keys (@hashref_events);

# Lets build event_id ARRAY

#my @hashref_events_pk;
# for my $hash ( 0.. $#hashref_events-1 ) {
#	push @hashref_events_pk, $hashref_events[$hash]->{event_name};
# }


#my @hashref_events_pk = map { $_->{event_id} } @hashref_events;
#print Dumper @hashref_events_pk;