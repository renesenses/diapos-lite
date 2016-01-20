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


foreach my $boxid (sort ( keys $hashref_boxes_pk )) {
	print $boxid,"\n";
 	my $rse = $schema->resultset('Event')->search( {'box_id' => $boxid} )->hashref_rs;

	%hash_pk = map { $_->{event_id} => $_ } $rse->all;

#print Dumper(%hash_pk);



for my $event ( nsort ( keys ( %hash_pk )) ){
#my $event = '1';
#	print $hash_pk{$event}->{event_id},"\n";
	my $rss = $schema->resultset('Sub')->search(
		{'box_id' => $boxid,
		'event_id' => $event}
		)->hashref_rs;

#	print Dumper($rss);

	my %hashsub_pk = map { $_->{sub_range} => $_ } $rss->all;
	
	print "\t",$event,"\n";

	for my $sub ( sort { subeventcmp($a, $b) } keys ( %hashsub_pk ) ){
		
#	for my $sub ( nsort ( keys ( %hashsub_pk )) ){
		print "\t\t",$sub,"\n";
	}
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