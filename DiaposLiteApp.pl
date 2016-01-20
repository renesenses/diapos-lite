#!/usr/bin/env perl
use Mojolicious::Lite;
#use DiaposLiteApp::Schema;
use Diapos::Schema;
use Mojolicious::Plugin::TagHelpers;
use Mojo::Collection;
use Carp;

# database
	my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});
#	my $schema = DiaposLiteApp::Schema->connect('dbi:SQLite:diapos.db', '', '');
	helper db => sub { 
		return $schema;
	};

	helper hashify => sub {
		my ($hash, $pk) = shift;
		my %hash_pk = ();
		my @primary_columns = $schema->source('Event')->primary_columns;
		my %pkeys;
		foreach my $col (@primary_columns ) {
			$pkeys{$col}++;
		}
		croak "Not a column key." if ($pkeys{$pk} != 0 );
		
		%hash_pk = map { $_->{$pk} => $_ } $hash;
    	return %hash_pk ;
	};


# route(s)
	get '/' => sub {
  		my $c = shift;
  		$c->render;
	} => 'default';	

	get '/box' => sub {
  		my $c = shift;
  		$c->render;
	} => 'box';	


# CARE IF CALLED FROM URL ID NOT VERIFIED OR INSIDE THE APP AND ID IN DATABASE
# ????
# View a box content
	get '/showbox/:id' => sub {
		my $c = shift;
#		my $boxid = $c->param('id');
		$c->render(template=>'showbox');
	};
	
app->start;

__DATA__
@@ default.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>

%= include 'table'; 
%= include 'footer'; 

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</div>
</body>
</html>


@@ table.html.ep

<table>
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
<%	while (my $boite = $rsb->next) { %>
<%		my $rse = db->resultset('Event')->search( {'box.box_id' => $boite->{box_id}},{join => [qw/ box /],}); %>
<%			if ( $rse->count == 0 ) { %>
				<tr><td>
					%=$boite->{box_id}
				</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
<%			} else {%>
<%				while (my $evenement = $rse->next) { %>
<%					my $rss = db->resultset('Sub')->search({'event.event_id' => $evenement->event_id},{join => [qw/ event /],}); %>
<%						if ( $rss->count == 0) { %>
							<tr><td>
								%=$boite->{box_id}
							<td>
<%								if (defined $evenement->event_year ) { %>	
									%=$evenement->event_year
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $evenement->event_month ) { %>	
									%=$evenement->event_month
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $evenement->event_name ) { %>	
									%=$evenement->event_name
<%								} else { %>
<%								} %>
							</td>
							<td>
<%								if (defined $evenement->event_nb ) { %>	
									%=$evenement->event_nb
									 images
<%								} else { %>
									? images
<%								} %>
							</td>
							<td></td><td></td></tr>
<%						} else { %>
<%							while (my $sub = $rss->next) { %>
								<tr><td>
									%=$boite->{box_id}
								</td>
								<td>
<%									if (defined $evenement->event_year ) { %>	
										%=$evenement->event_year
<%									} else { %>
<%									} %>
								</td>
								<td>
<%									if (defined $evenement->event_month ) { %>	
										%=$evenement->event_month
<%									} else { %>
<%									} %>
								</td>
								<td>
<%									if (defined $evenement->event_name ) { %>	
										%=$evenement->event_name
<%									} else { %>
<%									} %>
								</td>
								<td>
<%									if (defined $evenement->event_nb ) { %>	
										%=$evenement->event_nb
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
								<td>
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

@@ box.html.ep

<html>
<body>

<div>
<h1>Boîte de diapositives n°</h1>
</div>

<% my @boxes = db->resultset('Box')->search( { } )->hashref_array; %>
<% my $collection = Mojo::Collection->new(@boxes); %>
<% my $boxes_collection = $collection->map( sub {$_->{box_id} }); %>

<form>
	<select name="Boite : ?">
<% 		for my $box ( @boxes ) { %>
			<option value="
			%=$box->{box_id}
			">
			%=$box	->{box_id}
			</option>
<% 		} %>
	</select>
	<button type="submit">Afficher!</button>
</form>

%= select_field box_field => $boxes_collection


%= form_for show_box => begin
	%= label_for id => 'Choisir le n° de la boîte dans la liste déroulante'
	%= select_field id => $boxes_collection
	%= submit_button 'Affiche_boite'
% end

%= include 'footer'; 

</body>
</html>

@@ showbox.html.ep
<html>
<body>


@@ showbox.html.ep
<html>
<body>

<%	my $rse = db->resultset('Event')->search( {'box_id' => $id} )->hashref_rs; %>
<%  my %hrse = hashify($rse->all, 'event_id'); %>


<%	if ( $rse->count == 0 ) { %>
		La boîte n° <%=$id %> est vide !
<%	} else { %>
<%		for my $event sort { $hrse{$a} <=> $hrse{$b} } ( keys %hrse ){ %>
			<ul>
				<li> (
					%=$event->{event_id}
					) 
					%=$event->{event_year}
					 (
					%=$event->{event_month}
					 ) 
					%=$event->{event_name}
					 
					%=$event->{event_nb}
					 images. 	
				</li>
			</ul>
<%		} %>
<%	} %>
`
</body>
</html>

@@ showbox1.html.ep
<html>
<body>
<%	my $rse = db->resultset('Event')->search({'box.box_id' => $id},{join => [qw/ box /],}); %>
<%	if ( $rse->count == 0 ) { %>
		La boîte n°
		%=$id
		 est vide
<%	} else { %>
<%		while (my $event = $rse->next) {
			<ul>
				<li>
					(
					%=$event->{event_id}
					) 
					%=$event->{event_year}
					 ( 
					%=$event->{event_month}
					 ) 
					%=$event->{event_name}
					 
					%=$event->{event_nb}
					 images	
<%					my $rss = db->resultset('Sub')->search({'event.event_id' => $event->{event_id}},{join => [qw/ event /],}); %>
<%					while (my $sub = $rss->next) {
						<ol>
							%=$sub->{sub_range}
							 
							%=$sub->{sub_name}
						</ol>
<%					} %>
				</li>
			</ul>
<%		} %>
<%	} %>

%= include 'footer'; 
</body>
</html>
