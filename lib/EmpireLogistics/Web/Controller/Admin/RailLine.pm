package EmpireLogistics::Web::Controller::Admin::RailLine;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::RailLine;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::RailLine',
    class      => 'RailLine',
    item_name  => 'rail-line',
    form       => 'EmpireLogistics::Form::Admin::RailLine',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['rail-line'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;

