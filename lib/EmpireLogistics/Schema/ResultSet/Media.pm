package EmpireLogistics::Schema::ResultSet::Media;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;
use Data::UUID;
use Image::Magick;
use Data::Printer;
use DateTime;

extends 'EmpireLogistics::Schema::ResultSet';

sub BUILDARGS { $_[2] }

has 'labels' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_labels',
);

sub _build_labels {
    my $self = shift;
    return {
        id          => "ID",
        create_time => "Create Time",
        update_time => "Update Time",
        delete_time => "Deleted",
        uuid         => 'UUID',
        mime_type   => 'MIME Type',
        width       => 'Width',
        height      => 'Height',
        caption     => 'Caption',
        alt         => 'Alt Text',
        description => 'Description',
    };
}

=head2 update_or_create_from_raw_data

Takes in the raw data for a media and an optional Media object.
Creates or update the Media object from the raw data and stores.

=cut

sub update_or_create_from_raw_data {
    my ($class, %args) = @_;
    my $media = $args{media} || undef;
    my $data        = $args{data} or die "no data";
    my $caption     = $args{caption};
    my $alt         = $args{alt};
    my $uuid         = $args{uuid} || Data::UUID->new->create_str;
    my $description = $args{description};

    warn "My uuid is $uuid";

    # Extract information from the image itself
    my $magick = Image::Magick->new;
    $magick->BlobToImage($data);
    my $magick_type = $magick->Get('magick')
        or die 'Could not load the image';
    my $mime_type = $magick->MagickToMime($magick_type);
    my $width        = $magick->Get('width');
    my $height       = $magick->Get('height');

    if ($media) {
        $media->mime_type($mime_type);
        $media->width($width);
        $media->height($height);
        $media->caption($caption)         if ($caption);
        $media->description($description) if ($description);
        $media->alt($alt)                 if ($alt);
        $media->uuid($uuid)                 if ($uuid);
        $media->update;
    } else {
        warn "I am creating a new media";
        $media = $class->create({
            mime_type   => $mime_type,
            width       => $width,
            height      => $height,
            caption     => $caption,
            alt         => $alt,
            uuid         => $uuid,
            description => $description,
        }) or die 'Could not create a media object';
    }

    # Store the image on disk
    my $stored = $media->store_format('original', \$data);

    # If storing the image fails, delete the Media record
    unless ($stored) {
        $media->delete_time(DateTime->now);
        $media->update;
    }

    return $media;
}

__PACKAGE__->meta->make_immutable;

1;
