package EmpireLogistics::Schema::Result;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(
    "InflateColumn::DateTime", "InflateColumn::DateTime::Duration",
    "TimeStamp",               "FilterColumn",
    "Helper::Row::ToJSON",     "Core",
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
    warn "I am around insert";

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
        warn "My geometry is $geometry";
        $self->geometry($geometry);
    }
    $self->$orig(@_);
};

__PACKAGE__->meta->make_immutable;

1;
