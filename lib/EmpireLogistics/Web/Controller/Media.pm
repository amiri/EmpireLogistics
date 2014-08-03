package EmpireLogistics::Web::Controller::Media;

use Moose;
use MooseX::MethodAttributes;
extends 'Catalyst::Controller';

sub index: Chained('/') PathPart('media') Args(2) {
    my ($self, $c, $format, $uuid) = @_;
    my $file_type = 'png';

    my $media = ($uuid) ? $c->model('DB::Media')->active->find({ uuid => $uuid }) : undef;
    unless ($media) {
        $self->abort($c);
    }

    my $content_type = $media->mime_content_type($format);
    unless ($content_type) {
        $c->log->warn("WARNING: Missing content_type for Media $uuid");
        $self->abort($c);
    }

    my $undef_ok = 1;
    # Get the media content
    my $rcontent = try {
        $media->get_content($format, { undef_ok => $undef_ok }, $file_type);
    }
    catch {
        $self->abort($c);
    };

    $c->res->content_type($content_type);

    # Convert to the requested format
    unless ($rcontent) {
        try {
            $rcontent = $media->make_format(
                $format, undef, undef, $undef_ok, $file_type
            );
        }
        catch {
            warn "WARNING: media make_format: $_";
        };
    }

    # We couldn't serve this image, give 404
    unless ($rcontent) {
        $c->log->warn(
            "WARNING: Unable to load Media $uuid"
        );
        $self->abort($c);
    }

    # Return the media we found (or created) on disk
    $c->res->body($$rcontent);

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
