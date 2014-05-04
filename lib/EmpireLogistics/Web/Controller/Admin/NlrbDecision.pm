package EmpireLogistics::Web::Controller::Admin::NlrbDecision;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::NlrbDecision;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::NlrbDecision',
    class      => 'NlrbDecision',
    item_name  => 'nlrb-decision',
    form       => 'EmpireLogistics::Form::Admin::NlrbDecision',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['nlrb-decision'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;

