use utf8;
package Diapos::Schema::Result::Sub;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Diapos::Schema::Result::Sub

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<sub>

=cut

__PACKAGE__->table("sub");

=head1 ACCESSORS

=head2 box_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 event_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sub_range

  data_type: 'text'
  is_nullable: 0

=head2 sub_name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "box_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "event_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sub_range",
  { data_type => "text", is_nullable => 0 },
  "sub_name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</box_id>

=item * L</event_id>

=item * L</sub_range>

=back

=cut

__PACKAGE__->set_primary_key("box_id", "event_id", "sub_range");

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

=head2 event

Type: belongs_to

Related object: L<Diapos::Schema::Result::Event>

=cut

__PACKAGE__->belongs_to(
  "event",
  "Diapos::Schema::Result::Event",
  { event_id => "event_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-08 19:24:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LWKmhuV06AfyypCMuAWkaw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
