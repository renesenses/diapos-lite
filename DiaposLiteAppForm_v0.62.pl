#!/usr/bin/env perl

use Mojolicious::Lite;
use Diapos::Schema;
use Mojolicious::Plugin::TagHelpers;
use Mojolicious::Plugin::PDFRenderer;
use Carp;
use Sort::Naturally;
use Data::Dumper;
use Mojo::Collection;

# database
	my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

# plugins
	plugin 'TagHelpers';
	plugin 'PDFRenderer';
	plugin 'DefaultHelpers';
	
# helpers

	helper db => sub { $schema };

	helper boxcollection => sub { 
		my $c = shift;
		my @boxes = $c->db->resultset('Box')->search({ })->all;	
		my $boxes_col = Mojo::Collection->new;
		foreach my $box ( @boxes ){
			push @{ $boxes_col}, $box->get_column('box_id');
		} 
  		return $boxes_col->sort(sub {$a <=> $b});
	};

	helper eventcollection => sub { 
		my $c = shift;
		my $box_id = shift;
#		my @events = $c->db->resultset('Event')->search( {'box.box_id' => $box_id},{join => [qw/ box /],},{ order_by => { -asc => 'event_id' } });
		
		my @events = $c->db->resultset('Event')->search({'box_id' => $box_id},{ order_by => { -asc => [qw/event_year event_month/] } })->all;	
		my $events_col = Mojo::Collection->new;
		foreach my $event ( @events ){
			push @{ $events_col}, $event->get_column('event_name');
		} 
#		return $events_col->sort(sub {$a cmp $b});
  		return $events_col;
	};

	helper selectallboxespk => sub { 
		my $self = shift;
		my $rs_boxespk = $self->db->resultset('Box')->search({})->hashref_pk;	
		return $rs_boxespk;
	};
	
	helper selectallboxes => sub { 
		my $self = shift;
		my $rs_boxes = $self->db->resultset('Box')->search({})->hashref_rs;	
		return $rs_boxes;
	};
	
	helper selectallboxesid => sub { 
		my $self = shift;
		my $rs_boxes = $self->db->resultset('Box')->search({})->all;	
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

#	helper check_token => sub {
#		my $self			= shift;
#		my $validation 		= $self->validation;
#		return $self->render( text => 'Bad CSRF token!', status => 403 )
#		if $validation->csrf_protect->has_error('csrf_token');
#	};

# route(s)
	# SHOW ALL CONTENT box, event, sub
	get '/' => sub {
		my $c = shift;
	} => 'menu';	
	
	get '/all' => sub {
		my $c = shift;
	} => 'all';	

	get '/allevents' => sub {
		my $c = shift;
	} => 'allevents';	

	get '/boxes' => sub {
		my $c = shift;
  		my $boxes = $c->selectallboxespk;
  		$c->stash(boxes => $boxes);
	} => 'boxes';	

	post '/insertbox' => sub {
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
	
	get '/search' => sub {
		my $c = shift;
  		$c->stash( boxes_col => $c->boxcollection );
	} => 'select';	
	
	get '/menu' => sub {
		my $c = shift;
  		$c->stash( boxes_col => $c->boxcollection );
	} => 'showbox';	
	
#	any '/display/box' => sub {
#		my $c = shift;
#		my $box_id = $c->req->body_params->param('box_id');
#		my $boxid = $c->stash('boxid');
#		print Dumper($box_id);
#		$c->redirect_to('/displaybox', box_id => $box_id );
#		Model::Entries->delete_where( 'id=?', $id );
#	};


	post '/insertevent' => sub {
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

	get '/box/' =>  sub {
		my $c = shift;
#		my $box_id = $c->param('box_id');
		my $box_id = $c->req->query_params->param('box_id');
		print Dumper($box_id);
		$c->render('box', box_id => $box_id);
	};
	
	get '/display/box/:box_id' => sub {
		my $c = shift;
#		my $box_id = $c->req->query_params->param('box_id');
		my $box_id = $c->param('box_id');
		print Dumper($box_id);
#		my $id = $c->stash('id');
	} => 'box';

=begin comment
# A FAIRE ADDING SUB TO showbox déjà fait
	get '/showboxwithsub/:id' => sub {
		my $c = shift;
		my $id = $c->stash('id');
	} => 'showbox';

=end comment
=cut
	
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

@@ box.html.ep
%= include 'titre';
%= include 'menu';
<h2>Contenu de la boîte N°
%=$box_id
</h2>
<table align="Center">
	<tr>
		<th>N°évènement </th>
		<th>Année </th>
		<th>Mois </th>
		<th>Nom </th>
		<th>Nb de photos</th>
	</tr>

<% my $rse = db->resultset('Event')->search( {'box_id' => $box_id}, { order_by => { -asc => 'event_id' } })->hashref_rs; %>
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
%= include 'events'; 
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
%= include 'titre';
<h2>Les boîtes</h2> 
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

%= include 'bas'; 


@@ select.html.ep
%= include 'titre';
<h2>Sélection</h2>
%= include 'titre';
<h2>Menu</h2>
<div class="box">
%=form_for '/select/box' => begin
	%=select_field box_id => $boxes_col
 	%=submit_button 'Choisir box'
%end
</div>
<div class="event">
	%=select_field event_name => <%== eventcollection($box_id) 
	%=submit_button 'Choisir event'
</div>
<%# 	%=select_field sub_name => $subs_col %>
	
	%=submit_button 'Afficher'

%= include 'bas'; 

@@ showbox.html.ep
%= include 'titre';
<h2>Menu</h2>
%=form_for '/box/' => begin
	%=select_field box_id => $boxes_col
	%=submit_button 'Afficher'
%end
%= include 'bas'; 

@@ menu.html.ep
%= include 'titre';

<h2>Menu</h2>
<h3>Taper 1 pour Consulter la liste des boîtes et en ajouter</h3>  
<h3>Taper 2 pour Consulter le contenu d'une boîte et ajouter des évènements</h3>  
%=form_for '/' => begin
	%=text_field 'choice' => '1'
	%=submit_button 'Ok'
%end
<hr>
%= include 'bas'; 


@@ menuold.html.ep
%= include 'titre';
<h2>Menu</h2>
%=form_for '/box/' => begin
	%=select_field box_id => $boxes_col
	%=submit_button 'Afficher'
%end
%= include 'bas'; 

@@ search.html.ep

<form action="/display/box/<%== $$box_id %>" method="POST">
	%= select_field box_id => $boxes_col
	%= submit_button 'Show box'
</form>

@@ selectboxbyform.html.ep

<div class ="insert" align="Center">
%= form_for 'fshowbox' => (method => 'post') => begin
	%= select_field 'id' => [qw(1 2 3)]
	%= submit_button 'Show box'
% end
</form>
</div>



@@ events22.html.ep
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













@@ addevents.html.ep
<hr>
<h2>Ajouter un évènement</h2>
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
