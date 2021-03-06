package EmpireLogistics::Web::Controller::Admin::LaborOrganization;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::LaborOrganization;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::LaborOrganization',
    class      => 'LaborOrganization',
    item_name  => 'labor-organization',
    form       => 'EmpireLogistics::Form::Admin::LaborOrganization',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['labor-organization'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
