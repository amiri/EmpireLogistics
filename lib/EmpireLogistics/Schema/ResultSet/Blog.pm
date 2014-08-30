package EmpireLogistics::Schema::ResultSet::Blog;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'EmpireLogistics::Schema::ResultSet';

sub BUILDARGS { $_[2] }

has 'labels' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_labels',
);

sub _build_labels {
    my $self = shift;
    return {
        id          => "ID",
        create_time => "Create Time",
        update_time => "Update Time",
        delete_time => "Deleted",
        title       => "Title",
        url_title   => "URL Title",
        body        => "Body",
        author      => "Author",
    };
}

sub published {
    my $self = shift;
    return $self->search({"me.publish_time" => {"!=" => undef}});
}

__PACKAGE__->meta->make_immutable;

1;

