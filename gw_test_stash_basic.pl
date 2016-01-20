#!/usr/bin/env perl

# To launch it : morbo  --listen "http://*:5555" test_stash.pl

use Diapos::Schema;
use Mojolicious::Lite;

# database
	my $schema = Diapos::Schema->connect('dbi:SQLite:diapos.db', '', '',{ sqlite_unicode => 1});

# plugins
#	plugin 'TagHelpers';

	
# helpers

	helper db => sub { 
		return $schema;
	};

	helper getallboxes => sub {
		return  $schema->resultset('Box')->search( { } )->hashref_pk;
	};

# /foo/test
# /foo/test123
# route :ok
get '/boxes' => sub {
	my $c   = shift;
	my $boxes = $schema->resultset('Box')->search( { } )->hashref_pk;
	$c->stash(bo => $boxes);
#  $c->render(text => "From route '/foo/:id', boxid is $boxid ");
} => 'bo';

#get '/bixes' => sub {
#	my $c   = shift;
#	my $boxes = $schema->resultset('Box')->search( { } )->hashref_pk;
#	$c->stash(bo => $boxes);
#  $c->render(text => "From route '/foo/:id', boxid is $boxid ");
#} => 'bi';

#get '/buxes' => sub {
#	my $c   = shift;
#	my $boxes = getallboxes;
#	$c->stash(bo => $boxes);
#  $c->render(text => "From route '/foo/:id', boxid is $boxid ");
#} => 'bi';

# route :ok
get '/box/:id' => sub {
  my $c   = shift;
	$c->stash(prenoms => ['Bertrand', 'Luc', 'Fernand', 'Albert']);
	$c->render(template=>'box');
};

# route :ok
get '/bix/:id' => sub {
  my $c   = shift;
	$c->stash(prenoms => ['Bertrand', 'Luc', 'Fernand', 'Albert']);
	$c->render(template=>'bix');
};

# route :ok
get '/bax/:id' => sub {
  my $c   = shift;
	$c->stash(prenoms => ['Bertrand', 'Luc', 'Fernand', 'Albert']);
	$c->render(template=>'bax');
};

# /testsomething/foo
# /test123something/foo
get '/(:bar)something/foo' => sub {
  my $c   = shift;
  my $bar = $c->param('bar');
  $c->render(text => "Our :bar placeholder matched $bar");
};

app->start;

__DATA__
@@ box.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>

Le numéro de Boxid est : <br><%= $id %></br>
<%# for my $name in ( stash->{prenoms} ) { %>

Mon prénom est <br><%= join(", ", @{ stash->{prenoms} }) %></br> 

<%# } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>

@@ bix.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>

Le numéro de Boxid est : <br><%= $id %></br>
<% for my $name ( @{ stash->{prenoms} } ) { %>

Ma liste de prénoms se compose de <br><%= $name %></br> 

<% } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>

@@ bax.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>

Le numéro de Boxid est : <br><%= $id %></br>
<% for my $name ( @{ $prenoms } ) { %>

Ma liste de prénoms se compose de <br><%= $name %></br> 

<% } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>

@@ bo.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>
<% use Sort::Naturally; %>
<% for my $box_pk ( nsort keys %{ $bo } ) { %>

	<ul> Box <br><%= $box_pk  %></br></ul> 

<% } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>

@@ bi.html.ep

<!DOCTYPE html>
<html>
<body>

<h1>Diapos Lite App</h1>
<% use Sort::Naturally; %>
<% for my $box_pk ( nsort keys %{ $bo } ) { %>

	<ul> Box N°<br><%= $box_pk  %></br>nommée <%= ${ $bo }{$box_pk}->{box_name} %></ul> 

<% } %>

@@ footer.html.ep
<hr>
%= tag footer => begin
	%= tag p => "Based on: Mojolicious" 
	%= link_to 'https://mojolicious.us' => begin %>Mojolicious<% end 
%end

</body>
</html>
