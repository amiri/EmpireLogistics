package EmpireLogistics::Web::Controller::Admin::LaborActionType;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::LaborActionType;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::WorkStoppageType',
    class      => 'LaborActionType',
    item_name  => 'labor-action-type',
    form       => 'EmpireLogistics::Form::Admin::LaborActionType',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['labor-action-type'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
