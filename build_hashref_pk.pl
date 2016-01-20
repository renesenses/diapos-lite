#!/usr/bin/env perl

use Diapos::Schema;
use Data::Dumper;

my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

my $boxid = '1';
my @hashref_events = $schema->resultset('Event')->search( {'box_id' => $boxid} )->hashref_rs->all;
print Dumper @hashref_events;


#print Dumper keys (@hashref_events);

# Lets build event_id ARRAY

my @hashref_events_pk;
# for my $hash ( 0.. $#hashref_events-1 ) {
#	push @hashref_events_pk, $hashref_events[$hash]->{event_name};
# }


my @hashref_events_pk = map { $_->{event_name} } @hashref_events;
print Dumper @hashref_events_pk;


# Check how to get event_name from event_id in @hashref_events_pk
# or build the complete @hashref_event_pk

my @hashref_events_pk = map { $_->{event_name}->{event_name};  } @hashref_events;


sub build_event { 
	foreach my $id (@hashref_events_pk) {
		@hashref_event_pk{$_->{event_id}->{event_id};
	$_->{event_id}->{event_name};
	$_->{event_id}->{event_year};
	$_->{event_id}->{event_month};
	$_->{event_id}->{event_nb};