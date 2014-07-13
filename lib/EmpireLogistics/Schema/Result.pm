package EmpireLogistics::Schema::Result;

use Moose;
use MooseX::Types::URI qw/Uri/;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(
    "InflateColumn::DateTime", "InflateColumn::DateTime::Duration",
    "TimeStamp",               "Helper::Row::ToJSON",
    "Core",
);

has 'edit_url' => (
    is      => 'rw',
    isa     => Uri,
    coerce  => 1,
    lazy    => 1,
    builder => '_build_edit_url',
);

sub _build_edit_url {
    return '';
}

around delete => sub {
    my ( $orig, $self ) = ( shift, shift );

    if ( $self->can('delete_time') ) {
        $self->delete_time( DateTime->now );
        $self->update;
        return $self;
    }

    return $self->$orig(@_);
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

around update => sub {
    my ( $orig, $self ) = ( shift, shift );

    my %dirty_columns = $self->get_dirty_columns;
    if (defined $dirty_columns{latitude} or defined $dirty_columns{longitude}) {
        my ($geometry) = $self->result_source->schema->storage->dbh_do(
            sub {
                my ( $storage, $dbh, $lon, $lat ) = @_;
                $dbh->selectrow_array(
                    "select ST_Transform(ST_SetSRID(ST_MakePoint($lon, $lat), 4326), 900913)"
                );
            },
            ( ($dirty_columns{longitude}||$self->longitude),($dirty_columns{latitude} || $self->latitude) )
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

sub TO_JSON {
    my $self = shift;

    my $ret = { %{ $self->next::method } };
    if ( $self->can('create_time') and $self->create_time ) {
        $ret = {
            %{$ret},
            create_time => $self->create_time->strftime('%Y-%m-%d %r %z'),
        };
    }
    if ( $self->can('delete_time') and $self->delete_time ) {
        $ret = {
            %{$ret},
            delete_time => $self->delete_time->strftime('%Y-%m-%d %r %z'),
        };
    }
    if ( $self->can('update_time') and $self->update_time ) {
        $ret = {
            %{$ret},
            update_time => $self->update_time->strftime('%Y-%m-%d %r %z'),
        };
    }
    if ( $self->can('date_opened') and $self->date_opened) {
        $ret = {
            %{$ret},
            date_opened => $self->update_time->strftime('%Y-%m'),
        };
    }
    if ( $self->can('edit_url') and $self->edit_url) {
        $ret = {
            %{$ret},
            edit_url => $self->edit_url->as_string,
        };
    }
    if ( $self->can('date_established') and $self->date_established) {
        $ret = {
            %{$ret},
            date_established => $self->date_established->strftime('%Y'),
        };
    }
    if ( $self->can('owner') and $self->owner) {
        $ret = {
            %{$ret},
            owner => $self->owner->name,
        };
    }
    if ( $self->can('organization_type') and $self->organization_type) {
        $ret = {
            %{$ret},
            organization_type => $self->organization_type->name,
        };
    }

    return $ret;
}

sub _is_column_serializable {
    my ( $self, $column ) = @_;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
