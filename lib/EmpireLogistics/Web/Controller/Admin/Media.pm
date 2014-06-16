package EmpireLogistics::Web::Controller::Admin::Media;

use Moose;
use namespace::autoclean;
use EmpireLogistics::Form::Admin::Media;
use EmpireLogistics::Form::Admin::Restore;
use EmpireLogistics::Form::Admin::Delete;
use Data::Printer;

BEGIN { extends qw/EmpireLogistics::Web::Controller::Admin/; }

with 'EmpireLogistics::Role::Controller::CRUD';

__PACKAGE__->config(
    model_name   => 'DB::Media',
    class        => 'Media',
    item_name    => 'media',
    form         => 'EmpireLogistics::Form::Admin::Media',
    delete_form  => 'EmpireLogistics::Form::Admin::Delete',
    restore_form => 'EmpireLogistics::Form::Admin::Restore',
    actions      => {
        base => {
            PathPart    => ['media'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        },
    },
);

sub add_media : Chained('base') : PathPart('add-media') Args(0) {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $file = $c->req->param('file');
    $c->forward('add_or_update_media', [{file => $file}]);
    my $media = $c->stash->{media};
    $c->error("Could not create or retrieve media") unless ($media);
    $c->stash->{json_data} = $media;
}

=head2 add_or_update_media

Here we take a Data URI string, decode it to a binary string,
and call EmpireLogistics::Schema::ResultSet::Media::
update_or_create_from_raw_data with
our $args as args.

=cut

sub add_or_update_media : Private {
    my ($self, $c, $args) = @_;

    my $file = $args->{file};
    if ($file) {
        my @pieces = split(",", $file);
        $file = MIME::Base64::decode_base64($pieces[1]);
    }
    my %media_info = ();
    @media_info{
        qw/id caption alt uuid description x1 y1 x2 y2 crop_height crop_width/
        } =
        @{$c->req->params}{
        qw/id caption alt uuid description data-x1 data-y1 data-x2 data-y2 data-height data-width/
        };

    my ($original_media, $new_media);
    
    if ($media_info{id}) {
        $original_media = $c->model('DB::Media')->find({id => $media_info{id}});
        $media_info{media} = $original_media if $original_media;
    }

    if ($file) {
        $new_media = $c->model("DB::Media")
            ->update_or_create_from_raw_data(%media_info, data => $file,);
    } elsif ($original_media) {
        $new_media = $original_media->update_media(%media_info);
    }

    $c->stash->{media} = $new_media;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
