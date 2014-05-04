package EmpireLogistics::Web::Controller::Admin::CompanyType;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::CompanyType;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::CompanyType',
    class      => 'CompanyType',
    item_name  => 'company-type',
    form       => 'EmpireLogistics::Form::Admin::CompanyType',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['company-type'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;


