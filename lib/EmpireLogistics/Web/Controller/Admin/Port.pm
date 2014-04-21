package EmpireLogistics::Web::Controller::Admin::Port;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::Port;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::Port',
    class      => 'Port',
    item_name  => 'port',
    form       => 'EmpireLogistics::Form::Admin::Port',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['port'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
