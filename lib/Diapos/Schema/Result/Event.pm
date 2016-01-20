use utf8;
package Diapos::Schema::Result::Event;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Diapos::Schema::Result::Event

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<event>

=cut

__PACKAGE__->table("event");

=head1 ACCESSORS

=head2 box_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 event_id

  data_type: 'integer'
  is_nullable: 0

=head2 event_year

  data_type: 'integer'
  is_nullable: 0

=head2 event_month

  data_type: 'text'
  is_nullable: 0

=head2 event_name

  data_type: 'text'
  is_nullable: 0

=head2 event_nb

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "box_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "event_id",
  { data_type => "integer", is_nullable => 0 },
  "event_year",
  { data_type => "integer", is_nullable => 0 },
  "event_month",
  { data_type => "text", is_nullable => 0 },
  "event_name",
  { data_type => "text", is_nullable => 0 },
  "event_nb",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</box_id>

=item * L</event_id>

=back

=cut

__PACKAGE__->set_primary_key("box_id", "event_id");

=head1 RELATIONS

=head2 box

Type: belongs_to

Related object: L<Diapos::Schema::Result::Box>

=cut

__PACKAGE__->belongs_to(
  "box",
  "Diapos::Schema::Result::Box",
  { box_id => "box_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 subs

Type: has_many

Related object: L<Diapos::Schema::Result::Sub>

=cut

__PACKAGE__->has_many(
  "subs",
  "Diapos::Schema::Result::Sub",
  { "foreign.event_id" => "self.event_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-08 19:24:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9zu7MB6otkkORwNq5wElmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
