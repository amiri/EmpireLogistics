package EmpireLogistics::Web::Controller::Admin::Blog;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::Blog;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name   => 'DB::Blog',
    class        => 'Blog',
    item_name    => 'blog',
    form         => 'EmpireLogistics::Form::Admin::Blog',
    delete_form  => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions      => {
        base => {
            PathPart    => ['blog'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

__PACKAGE__->meta->make_immutable;

1;


