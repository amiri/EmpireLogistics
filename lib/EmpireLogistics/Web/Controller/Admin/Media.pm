package EmpireLogistics::Web::Controller::Admin::Media;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::Media;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name => 'DB::Media',
    class      => 'Media',
    item_name  => 'media',
    form       => 'EmpireLogistics::Form::Admin::Media',
    delete_form => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions    => {
        base => {
            PathPart    => ['media'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

sub add_media :Chained('base') :PathPart('add-media') Args(0) {
    my ($self,$c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    $c->log->warn("Hit my add_media URL");
    $c->stash->{json_data} = { success => 1 };
}

__PACKAGE__->meta->make_immutable;

1;

