package EmpireLogistics::Web::Controller::Admin::Warehouse;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::Warehouse;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::Warehouse',
    class      => 'Warehouse',
    item_name  => 'warehouse',
    form       => 'EmpireLogistics::Form::Admin::Warehouse',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['warehouse'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
