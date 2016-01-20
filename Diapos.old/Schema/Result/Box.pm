use utf8;
package Diapos::Schema::Result::Box;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Diapos::Schema::Result::Box

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<box>

=cut

__PACKAGE__->table("box");

=head1 ACCESSORS

=head2 box_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 box_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "box_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "box_name",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</box_id>

=back

=cut

__PACKAGE__->set_primary_key("box_id");

=head1 RELATIONS

=head2 events

Type: has_many

Related object: L<Diapos::Schema::Result::Event>

=cut

__PACKAGE__->has_many(
  "events",
  "Diapos::Schema::Result::Event",
  { "foreign.box_id" => "self.box_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 subs

Type: has_many

Related object: L<Diapos::Schema::Result::Sub>

=cut

__PACKAGE__->has_many(
  "subs",
  "Diapos::Schema::Result::Sub",
  { "foreign.box_id" => "self.box_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-08 20:34:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cvECBPZKsS97v8zWk9MyPQ


__PACKAGE__->resultset_class('DBIx::Class::ResultSet::HashRef');
1;
