package EmpireLogistics::Schema::ResultSet;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::ResultSet';

has 'form_options' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_form_options',
);

sub BUILDARGS { $_[2] }

sub active {
    my $self = shift;
    return $self->search({"me.delete_time" => undef});
}

sub _build_form_options {
    my $self = shift;
    return [ map { { value => $_->id, label => $_->name } }
            $self->active->all ];
}


__PACKAGE__->meta->make_immutable;

1;

