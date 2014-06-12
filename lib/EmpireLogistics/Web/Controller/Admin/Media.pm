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
    my $response = {
        map { $_ => $media->$_ }
            qw/
            id
            create_time
            uuid
            mime_type
            width
            height
            caption
            alt
            description
            /
    };
    $c->stash->{json_data} = $response;
}

=head2 add_or_update_media

Here we take a Data URI string, decode it to a binary string,
and call EmpireLogistics::Schema::ResultSet::Media::
update_or_create_from_raw_data with
our $args as args.

=cut

sub add_or_update_media : Private {
    my ($self, $c, $args) = @_;

    my $file = $args->{file} or die "No file";
    my @pieces = split(",", $file);
    $file = MIME::Base64::decode_base64($pieces[1]);
    my %media_info = ();
    @media_info{qw/id caption alt uuid description/} =
        @{$c->req->params}{qw/id caption alt uuid description/};
    my ($original_media, $new_media);
    if ($media_info{id}) {
        $original_media = $c->model("DB::Media")->find($media_info{id});
        $c->stash->{media} = $original_media;
    } else {
        $new_media =
            $c->model("DB::Media")
            ->update_or_create_from_raw_data(%media_info, data => $file,);
        $c->stash->{media} = $new_media;
    }
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

