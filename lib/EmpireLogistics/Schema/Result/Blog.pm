package EmpireLogistics::Schema::Result::Blog;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use HTML::TreeBuilder 5 -weak;
use HTML::Query 'query';
use Data::Printer;
extends 'EmpireLogistics::Schema::Result';

has 'treebuilder' => (
    is => 'ro',
    isa => 'HTML::TreeBuilder',
    lazy => 1,
    builder => '_build_treebuilder',
);

sub _build_treebuilder {
    my $self = shift;
    return HTML::TreeBuilder->new();
}

__PACKAGE__->table("blog");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "blog_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "url_title",
  { data_type => "text", is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "author",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("blog_url_title_unique", ["url_title"]);
__PACKAGE__->belongs_to(
  "author",
  "EmpireLogistics::Schema::Result::User",
  { id => "author" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

__PACKAGE__->belongs_to(
    "object_type" =>
    "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " => { -ident => "$args->{self_resultsource}.name" },
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.name" => $args->{self_resultsource}->name,
            },
        );
    },
);

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

sub excerpt {
    my $self = shift;
    my $parsed = $self->treebuilder->parse($self->body);
    my @ps = $parsed->query('p')->get_elements;
    my $first_p = $ps[0];
    my $excerpt = $first_p->as_trimmed_text;
    return $excerpt;
}

__PACKAGE__->meta->make_immutable;

1;

