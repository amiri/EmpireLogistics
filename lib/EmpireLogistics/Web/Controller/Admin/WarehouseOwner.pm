package EmpireLogistics::Web::Controller::Admin::WarehouseOwner;

use Moose;
use namespace::autoclean;
use DBIx::Class::ResultClass::HashRefInflator;
use EmpireLogistics::Form::Admin::WarehouseOwner;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::WarehouseOwner',
    class      => 'WarehouseOwner',
    item_name  => 'warehouse-owner',
    form       => 'EmpireLogistics::Form::Admin::WarehouseOwner',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['warehouse-owner'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
