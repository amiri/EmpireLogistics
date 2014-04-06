package EmpireLogistics::Schema::Result;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::DateTime::Duration",
  "TimeStamp",
  "FilterColumn",
  "Helper::Row::ToJSON",
  "Core",
);

around delete => sub {
    my ($orig,$self) = (shift,shift);

    if ($self->can('delete_time')) {
        $self->delete_time(DateTime->now);
        $self->update;
        return $self;
    }

    return $self->orig(@_);
};

__PACKAGE__->meta->make_immutable;

1;
