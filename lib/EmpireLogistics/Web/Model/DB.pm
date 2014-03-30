package EmpireLogistics::Web::Model::DB;

use Moose;
use EmpireLogistics::Config;
extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'EmpireLogistics::Schema',
    connect_info => EmpireLogistics::Config->connect_info,
);

__PACKAGE__->meta->make_immutable;

1;
