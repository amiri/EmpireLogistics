package EmpireLogistics::Schema::Result;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(
    "InflateColumn::DateTime",
    "InflateColumn::DateTime::Duration",
    "TimeStamp",
    "Helper::Row::ToJSON",
    "Core",
);

around delete => sub {
    my ( $orig, $self ) = ( shift, shift );

    if ( $self->can('delete_time') ) {
        $self->delete_time( DateTime->now );
        $self->update;
        return $self;
    }

    return $self->orig(@_);
};

around insert => sub {
    my ( $orig, $self ) = ( shift, shift );

    if (    $self->can('geometry')
        and $self->can('latitude')
        and $self->can('longitude')
        and not defined $self->geometry
        and defined $self->latitude
        and defined $self->longitude )
    {
        my ($geometry) = $self->result_source->schema->storage->dbh_do(
            sub {
                my ( $storage, $dbh, $lon, $lat ) = @_;
                $dbh->selectrow_array(
                    "select ST_Transform(ST_SetSRID(ST_MakePoint($lon, $lat), 4326), 900913)"
                );
            },
            ( $self->longitude, $self->latitude )
        );
        $self->geometry($geometry);
    }
    $self->$orig(@_);
};

sub edit_history_save {
    my $self = shift;
    my ( $user_id, $edit_history_fields, $notes ) = @_;

    return 0 unless ( defined $user_id );

    $self->create_related(
        edits => {
            object              => $self->id,
            object_type         => $self->object_type->id,
            user                => $user_id,
            notes               => $notes,
            edit_history_fields => $edit_history_fields,
        }
    );

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
