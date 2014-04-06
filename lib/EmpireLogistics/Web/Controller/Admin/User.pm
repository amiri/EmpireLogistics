package EmpireLogistics::Web::Controller::Admin::User;

use Moose;
use namespace::autoclean;
use DBIx::Class::ResultClass::HashRefInflator;
use aliased 'EmpireLogistics::Form::Admin::User';

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::User',
    class      => 'User',
    item_name  => 'user',
    form       => 'EmpireLogistics::Form::Admin::User',
    actions    => {
        base => {
            PathPart    => ['user'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        }
    },
);

__PACKAGE__->meta->make_immutable;

1;
