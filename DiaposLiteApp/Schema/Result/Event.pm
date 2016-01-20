package DiaposLiteApp::Schema::Result::Event;
	use base qw/DBIx::Class::Core/;
		__PACKAGE__->table('event');
		__PACKAGE__->add_columns(qw/ box_id event_id event_year event_month event_name event_nb /);
		__PACKAGE__->set_primary_key(qw/ box_id event_id /);
		__PACKAGE__->has_many('subs' => 'DiaposLiteApp::Schema::Result::Sub');
		__PACKAGE__->belongs_to('box_id' => 'DiaposLiteApp::Schema::Result::Box');
		__PACKAGE__->resultset_class('DBIx::Class::ResultSet::HashRef');

1;