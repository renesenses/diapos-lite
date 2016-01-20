#!/usr/bin/env perl
use Mojolicious::Lite;
#use DiaposLiteApp::Schema;
use Diapos::Schema;

# database
	my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});
#	my $schema = DiaposLiteApp::Schema->connect('dbi:SQLite:diapos.db', '', '');
	helper db => sub { 
		return $schema;
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

app->start;

__DATA__
@@ box.html.ep

<!DOCTYPE html>
<html lang="fr">
% content_for header => begin
	<meta charset="utf-8">
	<meta name="description" content="Diapos Lite App">
	<meta name="author" content="René Senses">
%end

%= stylesheet './styles.css'
%= stylesheet begin
body {
  padding-top: 50px;
  padding-bottom: 20px;
 }
%end
<body>

%= tag div => class => 'container' => begin
  %= tag h1 => 'Diapos Lite Appl'
%end
<div class="container">

%= include 'table'; 

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</div>
</body>
</html>

@@ default.html.ep

<!DOCTYPE html>
<html lang="fr">
% content_for header => begin
	<meta charset="utf-8">
	<meta name="description" content="Diapos Lite App">
	<meta name="author" content="René Senses">
%end

%= stylesheet './styles.css'
%= stylesheet begin
body {
  padding-top: 50px;
  padding-bottom: 20px;
 }
%end
<body>

%= tag div => class => 'container' => begin
  %= tag h1 => 'Diapos Lite Appl'
%end
<div class="container">

%= include 'table'; 

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
