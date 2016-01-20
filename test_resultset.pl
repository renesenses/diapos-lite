#!/usr/bin/env perl
# GW

use Diapos::Schema;
use Data::Dumper;
use Carp;

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

print Dumper(%hash_pk);

for my $event ( sort { $hash_pk{$a}->{event_id} <=> $hash_pk{$b}->{event_id} } keys ( %hash_pk ) ){
#	print $hash_pk{$event}->{event_id},"\n";
	print $event,"\n";
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