package EmpireLogistics::Web::Controller::Admin::RailNode;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::RailNode;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::RailNode',
    class      => 'RailNode',
    item_name  => 'rail-node',
    form       => 'EmpireLogistics::Form::Admin::RailNode',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['rail-node'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
