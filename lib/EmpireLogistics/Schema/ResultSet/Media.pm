package EmpireLogistics::Schema::ResultSet::Media;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;
use Data::UUID;
use Imager;
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
        uuid        => 'UUID',
        mime_type   => 'MIME Type',
        width       => 'Width',
        height      => 'Height',
        caption     => 'Caption',
        alt         => 'Alt Text',
        description => 'Description',
    };
}

sub new_uuid {
    my $self = shift;
    return Data::UUID->new->create_str;
}

=head2 update_or_create_from_raw_data

Takes in the raw data for a media and an optional Media object.
Creates or update the Media object from the raw data and stores.

=cut

sub update_or_create_from_raw_data {
    my ($class, %args) = @_;
    my $alt         = $args{alt};
    my $caption     = $args{caption};
    my $crop_height = $args{crop_height};
    my $crop_width  = $args{crop_width};
    my $data        = $args{data} or die "no data";
    my $description = $args{description};
    my $id          = $args{id};
    my $media       = $args{media} || undef;
    my $uuid        = $args{uuid} || $class->new_uuid;
    my $x1          = $args{x1};
    my $x2          = $args{x2};
    my $y1          = $args{y1};
    my $y2          = $args{y2};

    # Extract information from the image itself
    my $imager    = Imager->new;
    my $image     = $imager->read(data => $data) or die "Could not read data in update_or_create_from_raw_data: $!";
    my $type      = $image->tags(name => 'i_format');
    my $mime_type = 'image/' . $type;

    if ($crop_width and $crop_height and $x1 and $y1 and $x2 and $y2) {
        $image = $image->crop(
            left   => $x1,
            right  => $x2,
            top    => $y1,
            bottom => $y2
        );
    }
    my $width  = $image->getwidth;
    my $height = $image->getheight;

    if ($media) {
        $media->mime_type($mime_type);
        $media->width($width);
        $media->height($height);
        $media->caption($caption)         if ($caption);
        $media->description($description) if ($description);
        $media->alt($alt)                 if ($alt);
        $media->uuid($uuid)               if ($uuid);
    } else {
        $media = $class->create({
            mime_type   => $mime_type,
            width       => $width,
            height      => $height,
            caption     => $caption,
            alt         => $alt,
            uuid        => $uuid,
            description => $description,
        }) or die 'Could not create a media object';
    }

    # Store the image on disk
    my $stored = $media->store_format('original', $image);

    # If storing the image fails, delete the Media record
    unless ($stored) {
        $media->delete_time(DateTime->now);
        $media->update;
    }

    return $media;
}

__PACKAGE__->meta->make_immutable;

1;
