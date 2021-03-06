package EmpireLogistics::Schema::Result;

use Moose;
use MooseX::Types::URI qw/Uri/;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;
use IPC::System::Simple qw/capturex/;

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

has 'details_url' => (
    is      => 'rw',
    isa     => Uri,
    coerce  => 1,
    lazy    => 1,
    builder => '_build_details_url',
);


has 'map_url' => (
    is => 'ro',
    isa => Uri,
    coerce => 1,
    lazy => 1,
    builder => '_build_map_url',
);

sub path_for_model {
    my $self = shift;
    return {
        RailLine => 'rail-line',
        RailNode => 'rail-node',
        Port => 'port',
        Warehouse => 'warehouse',
        RailInterline => 'rail-interline',
    };
}

sub _build_edit_url {
    return '';
}

sub _build_details_url {
    my $self = shift;
    my $model_name = $self->result_source->source_name;
    my $url = '/details/'.$self->path_for_model->{$model_name}.'/'.$self->id;
    return $url;
}

sub _build_map_url {
    my $self = shift;
    if ($self->result_source->source_name eq 'RailLine') {
        my ($coordinates) = $self->result_source->schema->storage->dbh_do(
            sub {
                my ( $storage, $dbh, $geometry ) = @_;
                $dbh->selectrow_arrayref(
                    "SELECT ST_Y(ST_Transform(ST_SetSRID(ST_StartPoint(ST_lineMerge('$geometry')),900913),4326)),ST_X(ST_Transform(ST_SetSRID(ST_StartPoint(ST_lineMerge('$geometry')),900913),4326)) from rail_line"
                );
            },
            ( $self->geometry )
        );
        my ($lat,$lon) = @$coordinates;
        return '/#13/'.$lat.'/'.$lon;
    }
    if ($self->result_source->source_name eq 'RailInterline') {
        my ($coordinates) = $self->result_source->schema->storage->dbh_do(
            sub {
                my ( $storage, $dbh, $geometry ) = @_;
                $dbh->selectrow_arrayref(
                    "SELECT ST_Y(ST_Transform(ST_SetSRID(ST_StartPoint(ST_lineMerge('$geometry')),900914),4326)),ST_X(ST_Transform(ST_SetSRID(ST_StartPoint(ST_lineMerge('$geometry')),900914),4326)) from rail_interline"
                );
            },
            ( $self->geometry )
        );
        my ($lat,$lon) = @$coordinates;
        return '/#13/'.$lat.'/'.$lon;
    }
    return '' unless $self->can('latitude') and $self->can('longitude');
    return '/#13/'.$self->latitude.'/'.$self->longitude;
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
    my $updated = $self->$orig(@_);
    $updated->invalidate_cache if $self->can('geometry');
    return $updated;
};

sub invalidate_cache {
    my $self = shift;
    my $layer_for_rs = {
        RailLine      => 'rail_lines',
        Port          => 'ports',
        RailInterline => 'rail_interlines',
        RailNode      => 'rail_nodes',
        Warehouse     => 'warehouses',
    };
    my ($coordinates) = $self->result_source->schema->storage->dbh_do(
        sub {
            my ( $storage, $dbh, $geometry ) = @_;
            $dbh->selectrow_arrayref(qq{
                select
                st_y(
                    st_transform(
                        st_setsrid(
                            st_makepoint(
                                st_xmin(
                                    st_extent('$geometry')
                                ),
                                st_ymin(
                                    st_extent('$geometry')
                                )
                            ),
                        900913),
                    4326)
                ),
                st_x(
                    st_transform(
                        st_setsrid(
                            st_makepoint(
                                st_xmin(
                                    st_extent('$geometry')
                                ),
                                st_ymin(
                                    st_extent('$geometry')
                                )
                            ),
                        900913),
                    4326)
                ),
                st_y(
                    st_transform(
                        st_setsrid(
                            st_makepoint(
                                st_xmax(
                                    st_extent('$geometry')
                                ),
                                st_ymax(
                                    st_extent('$geometry')
                                )
                            ),
                        900913),
                    4326)
                ),
                st_x(
                    st_transform(
                        st_setsrid(
                            st_makepoint(
                                st_xmax(
                                    st_extent('$geometry')
                                ),
                                st_ymax(
                                    st_extent('$geometry')
                                )
                            ),
                        900913),
                    4326)
                )
            });
        },
        ( $self->geometry )
    );
    my ($minlat, $minlon, $maxlat, $maxlon) = @$coordinates;
    #North: 30.0166666666667; west: -90.8333333333333; south: 30.0166666666667; east: -90.8333333333333
    my $north = $minlat + 0.01;
    my $west = $minlon + 0.01;
    my $south = $maxlat - 0.01;
    my $east = $maxlon - 0.01;
    warn "North: $north; west: $west; south: $south; east: $east";
    my @args = (
        "--config",
        EmpireLogistics::Config->srcroot . '/etc/empirelogistics_tiles.cfg',
        "--layer",
        $layer_for_rs->{$self->result_source->source_name},
        "--bbox",
        $north,$west,$south,$east,
        "--ignore-cached",
        (EmpireLogistics::Config->is_production ? () : ("--output-directory", EmpireLogistics::Config->srcroot . '/tiles')),
        "--extension",
        'json',
        (1 .. 16),
    );
    my $message = capturex(EmpireLogistics::Config->srcroot . '/bin/tilestache-seed.py', @args);
    warn "Tilestache-seed command: ", EmpireLogistics::Config->srcroot . '/bin/tilestache-seed.py', map {"$_ "} @args;
    warn "Tilestache-seed says: $message";
    return 1;
}


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
    if ( $self->can('publish_time') and $self->publish_time ) {
        $ret = {
            %{$ret},
            publish_time => $self->publish_time->strftime('%Y-%m-%d %r %z'),
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
