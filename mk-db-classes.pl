#!/usr/bin/env perl
	# NOT USED
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
make_schema_at(
	'Diapos::Schema',
	{ 	debug => 1,
		dump_directory => '.',
#		dump_directory => './DiaposLiteApp',
	},
	[ 'dbi:SQLite:diapos.db', '', '',
	],
);