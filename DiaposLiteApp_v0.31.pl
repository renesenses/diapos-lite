#!/usr/bin/env perl

use Mojolicious::Lite;
use Diapos::Schema;
use Mojolicious::Plugin::TagHelpers;
use Mojolicious::Plugin::PDFRenderer;
use Carp;

# database
	my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

# plugins
	plugin 'TagHelpers';
	plugin 'PDFRenderer';
	
# helpers

	helper db => sub { 
		return $schema;
	};

	helper subeventcmp => sub {
		$_[0] =~ /^([0-9]+)/;
		my $A = $1;
		$_[1]=~ /^([0-9]+)/;
		my $B = $1;
		return $A <=> $B;
	};

# route(s)
	get '/' => sub {
		my $c = shift;
	} => 'menu';	

	get "/diapos\.css" => {
		template => 'diapos', format => 'css'
	} => 'diapos-css';

	get '/box' => sub {
		my $c = shift;
  		my $boxes = $c->db->resultset('Box')->search( { } )->hashref_pk;
  		$c-	( boxes => $boxes );
	} => 'box';	

	get '/box1/:id' => sub {

	} => 'box1';	

	get '/showbox/:id' => sub {

	} => 'showbox';
	
app->start;

__DATA__

@@ diapos.css.ep
	body {
			font-family:Verdana,Arial,Sans;
			font-size:16px;
			background-color: white; 
			color:Black;
		}
		h1 {
			color: blue;
			font-size: 24px;
			text-align: center;
		}
		h2 {
			color: blue;
			font-size: 18px;
		}
		th {
			background-color: orange;
			color: white;
			text-align: left;
		}
		tr:hover {background-color: #f5f5f5}
		tr:nth-child(even) {background-color: #f2f2f2}
		ul {
			width:auto;
			height:auto;
			line-height:1.4em;
			margin-bottom: 0;
			overflow:hidden;
			border-top:1px solid #ccc;
		}
		li {
			width:auto;
			height:auto;
			line-height:1.4em;
			border-bottom:1px solid #ccc;
			float:left;
		}
		#box ul li {
			margin-left: 0;
			padding-left: 2px;
			border: none;
			list-style: none;
			display: inline;
		}
		#event ul li {
			margin-left: 0;
			padding-left: 0px;
			border: none;
			list-style: none;
			display: inline;
		}
		#sub ul li {
			margin-left: 150px;
			padding-left: 0px;
			border: none;
			list-style: none;
			display: inline;
		}
		.event-id-li {
			style: italic;
			text-align:center;
		}
		.event-ul {
		}
		.event-id-li {
			width: 10%;
		}
		.event-year-li {
			width: 15%;
		}
		.event-month-li {
			width: 20%;
		}
		.event-name-li {
			width: 35%;
			align: left;
		}
		.event-nb-li {
			width: 20%;
			align: right;
		}
		.sub-range-li {
			width: 100px;
		}
		.sub-name-li {
		
		}

@@ menu.html.ep

<!DOCTYPE html>
<html>
<body>
%= stylesheet begin
		body {
			font-family:Verdana,Arial,Sans;
			font-size:13px;
			background-color: lightgrey; 
			color:Black;
		}
		h1 {
			color: blue;
			font-size: 24px;
		}
		h2 {
			color: blue;
			font-size: 18px;
		}
		th {
			background-color: orange;
			color: white;
			text-align: left;
		}
		tr:hover {background-color: #f5f5f5}
		tr:nth-child(even) {background-color: #f2f2f2}
		ul {
					width:760px;
			margin-bottom:20px;
			overflow:hidden;
			border-top:1px solid #ccc;
		}
		li {
			line-height:1.5em;
			border-bottom:1px solid #ccc;
			float:left;
		}
		#box ul li {
			margin-left: 0;
			padding-left: 2px;
			border: none;
			list-style: none;
			display: inline;
		}
		ul.event-ul {
		}
		il.event-id-il {
		}
		il.event-year-il {
		}
		il.event-month-il {
		}
		il.event-name-il {
		}
		il.event-nb-il {
		}
% end
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

<table align="Center">
	<tr>
		<th align="Center">N° de boite</th>
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
				<tr><td align="Center">
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
							<td>
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
								<td>
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


@@ box1.html.ep

<html>
<body>

<div>
<h1>Boîte de diapositives n°</h1>
</div>

<%  %>
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

@@ showboxold.html.ep
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


@@ showbox.html.ep
<html>
<head>
	<link rel="stylesheet" type="text/css" href="<%= url_for 'diapos-css' %>">
</head>
<body>
<h1>Contenu de la boîte N°
%=$id
</h1>
<hr>
<% use Sort::Naturally; %>
<% my $rse = db->resultset('Event')->search( {'box_id' => $id} )->hashref_rs; %>
<% my %hash_pk = map { $_->{event_id} => $_ } $rse->all; %>
<% for my $event ( nsort ( keys ( %hash_pk )) ){ %>
<div id="event">
	<ul class="event-ul">
		<li class="event-id-li">(<%=$hash_pk{$event}->{event_id}%>)</li> 
		<li class="event-year-li"><%=$hash_pk{$event}->{event_year}%></li>
		<li class="event-month-li">(<%=$hash_pk{$event}->{event_month}%>)</li>
		<li class="event-name-li"><%=$hash_pk{$event}->{event_name}%></li> 
		<li class="event-nb-li"><%=$hash_pk{$event}->{event_nb}%> images.</li> 	
<%			my $rss = db->resultset('Sub')->search( {'event_id' => $event, 'box_id' => $id} )->hashref_rs; %>
<%			my %hashsub_pk = map { $_->{sub_range} => $_ } $rss->all; %>
<%			for my $sub ( nsort keys ( %hashsub_pk ) ){ %>
			<div id="sub">
				<ul class="sub-ul">
					<li class="sub-range-li"><%=$hashsub_pk{$sub}->{sub_range}%></li>
					<li class="sub-name-li"><%=$hashsub_pk{$sub}->{sub_name}%></li>
				</ul>
			</div>	
<%			} %>
	</ul>
<%} %>
</div>
</body>
</html>
