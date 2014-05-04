package EmpireLogistics::Web::Controller::Admin::LaborAction;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::LaborAction;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::WorkStoppage',
    class      => 'LaborAction',
    item_name  => 'labor-action',
    form       => 'EmpireLogistics::Form::Admin::LaborAction',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['labor-action'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
