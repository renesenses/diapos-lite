#!/usr/bin/env perl

use Diapos::Schema;
use Data::Dumper;

my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

my $boxes_pk = $schema->resultset('Box')->search( { } )->hashref_pk;
#print Dumper $boxes_pk ;

foreach my $ key (sort (keys $boxes_pk) ) {
	print $key,"\n";
}	

=begin comment
 
my $rse = $schema->resultset('Event')->search( {'box_id' => $boxid} )->hashref_rs;
if ( $rse->count == 0 ) {
	print "BOITE VIDE \n";
} else {	
	while (my $event = $rse->next) {
		print $event->{event_id}, "\t", $event->{event_year}, "\t",$event->{event_month}, "\t",$event->{event_name}, "\t",$event->{event_nb}, "\n";
	}
}
=end comment
=cut 
#print Dumper @hashref_events;


#print Dumper keys (@hashref_events);

# Lets build event_id ARRAY

#my @hashref_events_pk;
# for my $hash ( 0.. $#hashref_events-1 ) {
#	push @hashref_events_pk, $hashref_events[$hash]->{event_name};
# }


#my @hashref_events_pk = map { $_->{event_id} } @hashref_events;
#print Dumper @hashref_events_pk;