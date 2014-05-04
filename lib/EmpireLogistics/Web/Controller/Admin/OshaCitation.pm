package EmpireLogistics::Web::Controller::Admin::OshaCitation;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::OshaCitation;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::OshaCitation',
    class      => 'OshaCitation',
    item_name  => 'osha-citation',
    form       => 'EmpireLogistics::Form::Admin::OshaCitation',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['osha-citation'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
