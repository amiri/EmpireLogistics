package EmpireLogistics::Web::Controller::Admin::User;

use Moose;
use namespace::autoclean;
use DBIx::Class::ResultClass::HashRefInflator;
use EmpireLogistics::Form::Admin::User;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::User',
    class      => 'User',
    item_name  => 'user',
    form       => 'EmpireLogistics::Form::Admin::User',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['user'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;
