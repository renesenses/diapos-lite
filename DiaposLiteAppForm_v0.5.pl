#!/usr/bin/env perl

use Mojolicious::Lite;
use Diapos::Schema;
use Mojolicious::Plugin::TagHelpers;
use Mojolicious::Plugin::PDFRenderer;
use Carp;
use Sort::Naturally;
use Data::Dumper;
# database
	my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

# plugins
	plugin 'TagHelpers';
	plugin 'PDFRenderer';
	
# helpers

	helper db => sub { 
		return $schema;
	};

	helper selectallboxespk => sub { 
		my $self = shift;
		my $rs_boxespk = $self->db->resultset('Box')->search( { } )->hashref_pk;	
		return $rs_boxespk;
	};
	
	helper selectallboxes => sub { 
		my $self = shift;
		my $rs_boxes = $self->db->resultset('Box')->search( { } )->all;	
		return $rs_boxes;
	};
	
	helper selectallboxesid => sub { 
		my $self = shift;
		my $rs_boxes = $self->db->resultset('Box')->search( { } )->all;	
		my $boxesid = map { $_->get_column('box_id') } $rs_boxes;
		return $boxesid;
	};
	
	helper array_selectalleventsbybox => sub { 
		my $self = shift;
		my $boxid = shift;
		my $rse = $self->db->resultset('Event')->search( {'box_id' => $boxid} )->hashref_array;
#		my %rse_pk = ();
#		%rse_pk = map { $_->{event_id} => $_ } $rse->all;
#		return %rse_pk;
		return $rse;
	};
	
	helper hash_selectalleventsbybox => sub { 
		my $self = shift;
		my $boxid = shift;
		my $rse = $self->db->resultset('Event')->search( {'box_id' => $boxid} )->hashref_array;
		my $rse_pk = map { $_->{event_id} } ( @{ $rse } );
		return $rse_pk;
	};
	
	helper select => sub {
		my $self = shift;
		my $sth = eval { $self->db->prepare('SELECT * FROM people') } || return undef;
		$sth->execute;
		return $sth->fetchall_arrayref;
	};
	

	helper subeventcmp => sub {
		$_[0] =~ /^([0-9]+)/;
		my $A = $1;
		$_[1]=~ /^([0-9]+)/;
		my $B = $1;
		return $A <=> $B;
	};

# route(s)
	# SHOW ALL CONTENT box, event, sub
	get '/' => sub {
		my $c = shift;
	} => 'all';	
	
	get '/all' => sub {
		my $c = shift;
	} => 'all';	

	get '/allevents' => sub {
		my $c = shift;
	} => 'allevents';	

	get '/menu' => sub {
		my $c = shift;
	} => 'menu';	

	get '/boxes' => sub {
		my $c = shift;
  		my $boxes = $c->selectallboxespk;
  		$c->stash(boxes => $boxes);
	} => 'boxes';	

	any '/insertbox' => sub {
		my $c = shift;
		my $boxid = $c->param('box_id');
		my $boxname = $c->param('box_name');
  		my $insert = $c->db->resultset('Box')->find_or_create({
				box_id 		=> $boxid,
				box_name	=> $boxname,
		});
		$c->redirect_to('/boxes');
	};	
	
	##############################################################################
	
	post '/displaybox' => sub {
		my $c = shift;
		my $boxid = $c->stash('boxid');
		$c->redirect_to('/showbox');
#		Model::Entries->delete_where( 'id=?', $id );
	};


	any '/insertevent' => sub {
		my $c = shift;
		my $boxid = $c->param('box_id');
		my $eventyear = $c->param('event_year');
		my $eventmonth = $c->param('event_month');
		my $eventname = $c->param('event_name');
		my $eventnb = $c->param('event_nb');

  		my $insert = $c->db->resultset('Event')->find_or_create({
				box_id 		=> $boxid,
				event_id	=> ,
				event_year	=> $eventyear,
				event_month	=> $eventmonth,
				event_name	=> $eventname,
				event_nb	=> $eventnb,
		});
		$c->redirect_to('/events');
	};	
	get "/diapos\.css" => {
		template => 'diapos', format => 'css'
	} => 'diapos-css';

	get '/box' => sub {
		my $c = shift;
  		my $rs_boxes = $c->db->resultset('Box')->search({});
  		my @boxesid;
		while (my $box = $rs_boxes->next){
			push @boxesid, $box->get_column('box_id');
		}
#		print Dumper(@boxesid);
 		$c->stash(boxes => \@boxesid);
	} => 'fboxes';	



	get '/fboxes' => sub {
		my $c = shift;
  		my $boxes = $c->selectallboxespk;
  		$c->stash(boxes => $boxes);
	} => 'fboxes';	

	get '/events/:id' => sub {
		my $c = shift;
		my $id = $c->param('id');
  		my $events = $c->array_selectalleventsbybox($id);
  		
  		$c->stash(events => $events);
	} => 'events';	

	get '/dumpevents/:id' => sub {
		my $c = shift;
		my $id = $c->param('id');
  		my $events = $c->hash_selectalleventsbybox($id);
#  		my %rse_pk = map { $_->{event_id} => $_ } ( @{ $events } );
  		$c->stash(hash => $events);
	} => 'dumpevents';	

	get '/box1/:id' => sub {

	} => 'box1';	


	
	get '/showbox/:id' => sub {
		my $c = shift;
		my $id = $c->stash('id');
	} => 'showbox';

=begin comment
# A FAIRE ADDING SUB TO showbox déjà fait
	get '/showboxwithsub/:id' => sub {
		my $c = shift;
		my $id = $c->stash('id');
	} => 'showbox';

=end comment
=cut

	post '/montrebox/*id' => sub {
		my $c = shift;
		my $id = $c->stash('id');

	} => 'showbox';
	
app->start;

__DATA__

@@ titre.html.ep
%= stylesheet '/styles.css'
<!DOCTYPE html>
<html>
<body>
<h1>Diapos Lite App</h1>
<hr>

@@ bas.html.ep
<hr>
</html>
</body>

@@ all.html.ep
%= include 'titre';
<h2>Tout le contenu</h2> 
%= include 'table'; 
%= include 'bas'; 


@@ allevents.html.ep
%= include 'titre';
<h2>Les évènements</h2> 
<table align="Center">
	<tr>
		<th>N° Box </th>
		<th>Année </th>
		<th>Mois </th>
		<th>Nom </th>
		<th>Nb de photos</th>
	</tr>
<% my $rsb = db->resultset('Box')->search( { } )->hashref_rs; %>
<%	while (my $box = $rsb->next) { %>
<%		my $rse = db->resultset('Event')->search( {'box.box_id' => $box->{box_id}},{join => [qw/ box /],}); %>
<% 	while ( my $event = $rse->next ){ %>
		<tr>
			<td>
				<%=$event->box_id()%>
			</td>
			<td>
				<%=$event->event_year()%>
			</td>
			<td>
				<%=$event->event_month()%>
			</td>
			<td>
				<%=$event->event_name()%>
			</td>
			<td>
				<%=$event->event_nb()%>
				 images
			</td>
		</tr>
<%	} %>
<%	} %>
</table>
%= include 'bas'; 

@@ menu.html.ep
%= include 'titre';
<h2>Menu</h2> 
%= include 'selectboxbyurl';
%= include 'bas'; 

@@ showbox.html.ep
%= include 'titre';
<h2>Contenu de la boîte N°
%=$id
</h2>
<table align="Center">
	<tr>
		<th>N°évènement </th>
		<th>Année </th>
		<th>Mois </th>
		<th>Nom </th>
		<th>Nb de photos</th>
	</tr>

<% use Sort::Naturally; %>
<% my $rse = db->resultset('Event')->search( {'box_id' => $id} )->hashref_rs; %>
<% while ( my $event = $rse->next ){ %>
<tr>
	<td>
		<%=$event->{event_id}%>
	</td> 
	<td>
		<%=$event->{event_year}%>
	</td> 
	<td>
		<%=$event->{event_month}%>
	</td> 
	<td>
		<%=$event->{event_name}%>
	</td> 
	<td>
		<%=$event->{event_nb}%>
		images.
	</td> 
</tr>
<% } %>
%= include 'bas'; 


@@ table.html.ep

<table align="Center">
	<tr>
		<th>N° de boite</th>
		<th>Année</th>
		<th>Mois</th>
		<th>Evènement</th>
		<th>Nb diapos</th>
		<th>Rang</th>
		<th>Descriptif</th>
	</tr>
<% my $rsb = db->resultset('Box')->search( { } )->hashref_rs; %>
<%	while (my $box = $rsb->next) { %>
<%		my $rse = db->resultset('Event')->search( {'box.box_id' => $box->{box_id}},{join => [qw/ box /],}); %>
<%			if ( $rse->count == 0 ) { %>
				<tr><td>
					%=$box->{box_id}
				</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
<%			} else {%>
<%				while (my $event = $rse->next) { %>
<%					my $rss = db->resultset('Sub')->search({'event_id' => $event->event_id, 'box_id' =>  $box->{box_id} }); %>
<%						if ( $rss->count == 0) { %>
							<tr><td>
								%=$box->{box_id}
							<td>
<%								if (defined $event->event_year ) { %>	
									%=$event->event_year
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $event->event_month ) { %>	
									%=$event->event_month
<%								} else { %>
<%								} %>
							</td>
							<td align="left">
<%								if (defined $event->event_name ) { %>	
									%=$event->event_name
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $event->event_nb ) { %>	
									%=$event->event_nb
									 images
<%								} else { %>
									? images
<%								} %>
							</td>
							<td></td><td></td></tr>
<%						} else { %>
<%							while (my $sub = $rss->next) { %>
								<tr><td>
									%=$box->{box_id}
								</td>
								<td>
<%									if (defined $event->event_year ) { %>	
										%=$event->event_year
<%									} else { %>
<%									} %>
								</td>
								<td>
<%									if (defined $event->event_month ) { %>	
										%=$event->event_month
<%									} else { %>
<%									} %>
								</td>
								<td align="left">
<%									if (defined $event->event_name ) { %>	
										%=$event->event_name
<%									} else { %>
<%									} %>
								</td>
								<td>
<%									if (defined $event->event_nb ) { %>	
										%=$event->event_nb
										 images
<%									} else { %>
										? images
<%									} %>
								</td>
								<td>
<%									if (defined $sub->sub_range ) { %>	
										%=$sub->sub_range
<%									} else { %>
										Impossible
<%									} %>
								</td>
								<td align="left">
<%									if (defined $sub->sub_name ) { %>	
										%=$sub->sub_name
<%									} else { %>
<%									} %>
								</td>
								</tr>
<%							} %>
<%						} %>
<%				} %>
<%			} %>
<%	} %>
</table>



@@ boxes.html.ep
%= stylesheet '/styles.css'
<!DOCTYPE html>
<html>
<body>
<h1>Diapos Lite App : les boîtes</h1>
<div class ="insert" align="Center">
<form action="<%=url_for('insertbox')->to_abs%>" method="post">
	N° Box: <input type="text" name="box_id"> 
	Descriptif: <input type="text" name="box_name"> 
	<input type="submit" value="Add">
</form>
</div>
<table align="Center">
	<tr>
		<th>N°</th>
		<th>Decriptif</th>
	</tr>
<% use Sort::Naturally; %>

<% my $rsb = db->resultset('Box')->search( { } )->hashref_rs; %>
<%	while (my $box = $rsb->next) { %>
	<tr><td>
		<%=$box->{box_id} %>
	</td>
	<td><%= $box->{box_name} %>
	</td>
<% } %>



@@ selectboxbyurl.html.ep
<form action="<%=url_for('/displaybox',id =>$boxid )->to_abs%>" method="post">
	%= select_field 'boxid' => [qw(1 2 3)]
	%= submit_button 'Show box'
</form>

@@ selectboxbyform.html.ep
%= stylesheet '/styles.css'
<!DOCTYPE html>
<html>
<body>
<h1>Diapos Lite App : Sélection par boîte</h1>
<div class ="insert" align="Center">
%= form_for 'fshowbox' => (method => 'post') => begin
	%= select_field 'id' => [qw(1 2 3)]
	%= submit_button 'Show box'
% end
</form>
</div>
</body>
</html>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</div>
</body>
</html>


@@ box.html.ep
%= stylesheet '/styles.css'
<html>
<body>

<div>
<h1>Liste des boîtes de diapositives</h1>
</div>


<form>
	<select name="Boite : ?">
<%		my @boxes = map { $_->{box_id} } $boxes; %>
<% 		for my $box ( @boxes ) { %>
			<option value="<%=$boxes{$box}->{box_id}%>"><%=$boxes{$box}->{box_id}%></option>
<% 		} %>
	</select>
	<button type="submit">Afficher!</button>
</form>

</body>
</html>



@@ events.html.ep
<table align="Center">
	<tr>
		<th>N° Box </th>
		<th>Année </th>
		<th>Mois </th>
		<th>Nom </th>
		<th>Nb de photos</th>
	</tr>
<% my $rse = db->resultset('Event')->search( {'box_id' => $id} )->hashref_rs; %>
<% while ( my $event = $rse->next ){ %>

							<tr><td>
								%=$event->{box_id}
							<td>
<%								if (defined $event->event_year ) { %>	
									%=$event->event_year
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $event->event_month ) { %>	
									%=$event->event_month
<%								} else { %>
<%								} %>
							</td>
							<td align="left">
<%								if (defined $event->event_name ) { %>	
									%=$event->event_name
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $event->event_nb ) { %>	
									%=$event->event_nb
									 images
<%								} else { %>
									? images
<%								} %>
							</td>

<%# DON'T WORK MISSING p%>
@@ fboxes.html.ep
%= stylesheet '/styles.css'
<!DOCTYPE html>
<html>
<body>
<h1>Diapos Lite App : les boîtes</h1>
<div class ="insert" align="Center">
%= form_for 'fshowbox' => (method => 'post') => begin
	%= select_field 'id' => [qw(1 2 3)]
	%= submit_button 'Show box'
% end
</form>
</div>
</body>
</html>

@@ showboxold.html.ep
%= stylesheet '/styles.css'
<%# WORKING BUT NO DESIGN%>
<html>
<body>
<h1>Diapos Lite App</h1>
<h2>Contenu de la boîte N°
%=$id
</h2>
<% use Sort::Naturally; %>
<% my $rse = db->resultset('Event')->search( {'box_id' => $id} )->hashref_rs; %>
<% my %hash_pk = map { $_->{event_id} => $_ } $rse->all; %>

<% for my $event ( nsort ( keys ( %hash_pk )) ){ %>

	<ul>
		<li> (
				%=$hash_pk{$event}->{event_id}
			 ) 
				%=$hash_pk{$event}->{event_year}
			 (
				%=$hash_pk{$event}->{event_month}
			 ) 
				%=$hash_pk{$event}->{event_name} 
			  
				%=$hash_pk{$event}->{event_nb}
			 images. 	
			 
<%			my $rss = db->resultset('Sub')->search( {'event_id' => $event, 'box_id' => $id} )->hashref_rs; %>
<%			my %hashsub_pk = map { $_->{sub_range} => $_ } $rss->all; %>
<%#		for my $sub ( sort { subeventcmp($a, $b) } keys ( %hashsub_pk ) ){ %>
<%			for my $sub ( nsort keys ( %hashsub_pk ) ){ %>
				<ol>
					%=$hashsub_pk{$sub}->{sub_range}
					 - 
					%=$hashsub_pk{$sub}->{sub_name}
				</ol>
<%			} %>
		</li>
	</ul>
<%} %>




@@ events.html.ep
%= stylesheet '/styles.css'
<!DOCTYPE html>
<html>
<body>
<h1>Diapos Lite App : les évènements</h1>
<div class ="insert" align="Center">
<form action="<%=url_for('insertevent')->to_abs%>" method="post">
	N° Box: <input type="text" name="box_id">
	Année:  <input type="text" name="event_year">
	Mois: 	<input type="text" name="event_month">
	Nom: 	<input type="text" name="event_name">
	Nb de photos: <input type="text" name="event_nb"> 
	<input type="submit" value="Add">
</form>
</div>
<table align="Center">
	<tr>
		<th>N° Box </th>
		<th>Année </th>
		<th>Mois </th>
		<th>Nom </th>
		<th>Nb de photos</th>
	</tr>
<% use Sort::Naturally; %>

<% my $rse = db->resultset('Event')->search( {'box_id' => $id} )->hashref_rs; %>
<% while ( my $event = $rse->next ){ %>
<tr>
	<td>(
		<%=$event->{event_id}%>
		)
	</td> 
	<td>
		<%=$event->{event_year}%>
	</td> 
	<td>(
		<%=$event->{event_month}%>
		)
	</td> 
	<td>
		<%=$event->{event_name}%>
	</td> 
	<td>
		<%=$event->{event_nb}%>
		images.
	</td> 
<% } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>



@@ eventsold.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>
<% use Sort::Naturally; %>

<h2>Box N°<br><%= $id  %></br> contient : </h2>
<% for my $event_pk ( nsort keys %{ $events } ) { %>
<div id="event">
	<ul class="event-ul">
		<li class="event-id-li">(<%=${ $events }{$event_pk}->{event_id}%>)</li> 
		<li class="event-year-li"><%=${ $events }{$event_pk}->{event_year}%></li>
		<li class="event-month-li">(<%=${ $events }{$event_pk}->{event_month}%>)</li>
		<li class="event-name-li"><%=${ $events }{$event_pk}->{event_name}%></li> 
		<li class="event-nb-li"><%=${ $events }{$event_pk}->{event_nb}%> images.</li> 	
	</ul> 
</div> 
<% } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>

@@ dumpevents.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>
<% use Sort::Naturally; %>

<h2>Box N°<br><%= $id  %></br> contient : </h2>
%= dumper $hashes

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>