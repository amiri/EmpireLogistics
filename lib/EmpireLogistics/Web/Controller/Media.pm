package EmpireLogistics::Web::Controller::Media;

use Moose;
use MooseX::MethodAttributes;
use Try::Tiny;
extends 'Catalyst::Controller';

sub index: Chained('/') PathPart('media') Args(2) {
    my ($self, $c, $format, $uuid) = @_;
    $c->error("Invalid format $format") unless $format =~ /^\d+(w|h)$/ || $format =~ /^\d+x\d+$/ || $format =~ /^original$/;

    if ($format =~ /^\d+(w|h)$/) {
        my ($width, $height);
        if ($format =~ /w/) {
            $format =~ /(\d+)/;
            $width = $1;
            $height = int(((9/16) * $width) + 0.5);
        } else {
            $format =~ /(\d+)/;
            $height = $1;
            $width = int(((16/9) * $height) + 0.5);
        }
        $format = $width."x".$height;
    }

    my $file_type = 'png';

    my $media = ($uuid) ? $c->model('DB::Media')->active->find({ uuid => $uuid }) : undef;
    unless ($media) {
        $c->error("Could not find media $uuid");
    }

    my $content_type = $media->mime_content_type($format);
    unless ($content_type) {
        $c->error("Missing content_type for media $uuid");
    }

    my $undef_ok = 1;
    # Get the media content
    my $rcontent = try {
        $media->get_content($format, { undef_ok => $undef_ok }, $file_type);
    }
    catch {
        $c->error("Could not get media content for media $uuid");
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
        $c->error("Unable to load media $uuid");
    }

    $c->res->content_length(length($rcontent));
    # Return the media we found (or created) on disk
    $c->res->body($rcontent);

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
