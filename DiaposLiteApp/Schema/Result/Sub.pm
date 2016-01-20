package DiaposLiteApp::Schema::Result::Sub;
use base qw/DBIx::Class::Core/;
		__PACKAGE__->table('sub');
		__PACKAGE__->add_columns(qw/ box_id event_id sub_range sub_name/);
		__PACKAGE__->set_primary_key(qw/ box_id event_id sub_name /);
		__PACKAGE__->belongs_to('event_id' => 'DiaposLiteApp::Schema::Result::Event');
		__PACKAGE__->resultset_class('DBIx::Class::ResultSet::HashRef');

1;