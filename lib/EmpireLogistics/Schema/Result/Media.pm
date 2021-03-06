package EmpireLogistics::Schema::Result::Media;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use Data::UUID;
use IO::All;
use Try::Tiny;
use Imager;
use Data::Printer;
use File::Path qw/make_path/;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("media");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "uuid",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "mime_type",
  { data_type => "text", is_nullable => 0 },
  "width",
  { data_type => "integer", is_nullable => 0 },
  "height",
  { data_type => "integer", is_nullable => 0 },
  "caption",
  { data_type => "text", is_nullable => 1 },
  "alt",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("unique_uuid", ["uuid"]);

__PACKAGE__->has_many(
  "port_medias",
  "EmpireLogistics::Schema::Result::PortMedia",
  { "foreign.media" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "rail_node_medias",
  "EmpireLogistics::Schema::Result::RailNodeMedia",
  { "foreign.media" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "warehouse_medias",
  "EmpireLogistics::Schema::Result::WarehouseMedia",
  { "foreign.media" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->many_to_many("ports", "port_medias", "port");
__PACKAGE__->many_to_many("rail_nodes", "rail_node_medias", "rail_node");
__PACKAGE__->many_to_many("warehouses", "warehouse_medias", "warehouse");



__PACKAGE__->belongs_to(
    "object_type" =>
    "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " => { -ident => "$args->{self_resultsource}.name" },
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.name" => $args->{self_resultsource}->name,
            },
        );
    },
);

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

after 'update' => sub {
    my $self = shift;
    for my $rel (qw/ports warehouses rail_nodes/) {
        for my $item ($self->$rel->all) {
            $item->invalidate_cache;
        }
    }
};

sub _build_edit_url {
    my $self = shift;
    return '/admin/media/'.$self->id.'/edit';
}

sub inner_height {
    my ($self, $max_width) = @_;

    my $inner_height = $self->height;
    if ($max_width < $self->width) {
        $inner_height =
            sprintf("%.0f", $self->height * $max_width / $self->width);
    }

    return ($inner_height);
}

sub make_format {
    my ($self, $format, $roriginal_content,
        $original_imager, $undef_ok, $file_type) = @_;

    $file_type ||= 'png';
    $roriginal_content ||=
        $self->get_content('original', { undef_ok => $undef_ok });

    die "ERROR: Media ", $self->id, " missing original content\n"
        unless ($roriginal_content);

    return $roriginal_content if ($format eq 'original');

    my $inner_imager;
    $inner_imager = Imager->new;
    $inner_imager->read(data => $roriginal_content);

    my ($width, $height) = ($format =~ m%^(\d+)x(\d+)$%);
    die "ERROR: Invalid media format: $format" unless ($width && $height);

    # Scale the image so it will just fit inside the new format
    my ($inner_width, $inner_height) = $self->inner_dimensions($width, $height);
    my $scaled = $inner_imager->scale(
        xpixels => $inner_width,
        ypixels => $inner_height,
    );

    # Put the inner image (above) centered on a full-sized white background
    my $imager = Imager->new(xsize => $width, ysize => $height, channels => 4)->compose(
        src => $scaled,
        left => int(($width/2)+0.5) - int(($inner_width/2)+0.5),
        top => int(($height/2)+0.5) - int(($inner_height/2)+0.5),
    );

    # Save the content for this new format so we don't have to build it again
    $self->store_format($format, $imager, $file_type);

    my $data;
    $imager->write(type => $file_type, data => \$data);
    return $data;
}

sub inner_dimensions {
    my ($self, $max_width, $max_height) = @_;

    my $original_width = $self->width;
    my $original_height = $self->height;

    my $width_ratio  = $original_width  / $max_width;
    my $height_ratio = $original_height / $max_height;

    return ($max_width, sprintf("%.0f", $original_height / $width_ratio))
        if (($width_ratio >= $height_ratio) && ($width_ratio > 1.0));

    return (sprintf("%.0f", $original_width / $height_ratio), $max_height)
        if (($width_ratio < $height_ratio) && ($height_ratio > 1.0));

    return ($original_width, $original_height);
}

sub get_content {
    my ($self, $format, $opts, $file_type) = @_;

    # Try local disk cache
    my $rcontent = $self->get_content_from_disk($format, $opts, $file_type);
    return $rcontent if ($rcontent);
    return undef;
}

sub get_content_from_disk {
    my ($self, $format, $opts, $file_type) = @_;
    my $disk_filename = $self->disk_filename($format, $file_type);

    return
        try {
            io($disk_filename)->slurp;
        } catch {
            undef
        };
}


sub file_url {
    my ($self, $format, %args) = @_;
    my $secure = $args{secure} || 0;
    my $filename = $args{filename};

    # If a width was passed but not a height, assume it's a
    # maximum width and calculate a proportional height
    if ($format) {
        my ($width, $height) = ($format =~ m%^(\d+)?x(\d+)?$%);
        if ($width && !$height) {
            $format =
                ($self->width && ($width < $self->width))
                ? $width . 'x' . $self->inner_height($width)
                : undef;
        }
    }

    $filename ||= $self->uuid;

    my $url = $self->pathname($format) . $self->basename($format);

    return $url;
}

=head2 pathname

Returns the file path including leading and trailing slashes, but excluding the
base filename for the media. This is used along with the base filename in URLs,
on disk, and in S3 keys.

=cut

sub pathname {
    my ($self, $format) = @_;
    $format ||= 'original';
    return "/media/$format/";
}

=head2 basename

Returns the suggested base filename (e.g., "XXXXXXXX.jpg") for the media. Does
not include any path or SEO keyword information.

=cut

sub basename {
    my ($self, $format) = @_;
    return lc $self->uuid . '.' . $self->extension($format);
}

=head2 extension

Returns the preferred extension for the content type of the specified format.

=cut

sub extension {
    my ($self, $format) = @_;
    my $content_type = $self->mime_content_type($format);
    my $extension    = $self->_extension_for_content_type($content_type);
    return $extension;
}

sub mime_content_type {
    my ($self, $format) = @_;

    $format ||= 'original';

    # Extension based on the original format content type
    if ($format eq 'original') {
        return $self->mime_type;
    }

    # We always convert to png for non-original formats
    return 'image/png';
}

=head2 _extension_for_content_type

Returns our preferred filename extension given a MIME type.

=cut

my %extension_alternatives = (
    'jpeg'    => 'jpg',
    'x-jpeg'  => 'jpg',
    'pjpeg'   => 'jpg',
    'x-png'   => 'png',
    'x-bmp'   => 'bmp',
    'svg+xml' => 'svg',
    'x-svg'   => 'svg',
    'x-gif'   => 'gif',
    'x-tiff'  => 'jpg',
    'tiff'    => 'jpg',
    'pdf'     => 'pdf',
);

sub _extension_for_content_type {
    my $self = shift;
    my ($content_type) = @_;

    return undef unless ($content_type =~ m{^(?:image|application)/(.*)});

    my $extension = $1;

    return $extension_alternatives{$extension} || $extension;
}

sub store_format {
    my ($self, $format, $image) = @_;

    # Store the media on local disk (always)
    my $stored_on_disk = $self->store_on_disk($format, $image);

    return $stored_on_disk;
}

sub store_on_disk {
    my ($self, $format, $image) = @_;

    my $disk_filename = $self->disk_filename($format);

    return try {
        $image->write(file => $disk_filename);
        1;
    }
    catch {
        die "ERROR: Unable to store media on disk: $_";
        undef;
    };
}

sub disk_filename {
    my ($self, $format) = @_;

    my $srcroot   = EmpireLogistics::Config->srcroot;
    my $directory = $srcroot . '/root' . $self->pathname($format);
    try {
        make_path($directory) unless -d $directory;
    }
    catch {
        die "Could not make directory: $_";
    };

    my $disk_filename = $directory . $self->basename($format);
    return $disk_filename;
}

sub update_media {
    my $self = shift;
    my %args = @_;

    my $alt         = $args{alt};
    my $caption     = $args{caption};
    my $crop_height = $args{crop_height};
    my $crop_width  = $args{crop_width};
    my $description = $args{description};
    my $id          = $args{id};
    my $uuid        = $args{uuid};
    my $x1          = $args{x1};
    my $x2          = $args{x2};
    my $y1          = $args{y1};
    my $y2          = $args{y2};

    # Extract information from the image itself
    my $imager = Imager->new;
    my $image = $imager->read(file => $self->disk_filename)
        or die "Could not read file in update_media: $!";
    my $type = $image->tags(name => 'i_format');
    my $mime_type = 'image/' . $type;

    # Give a new uuid, e.g., file name, when cropping.
    if ($crop_width and $crop_height and defined $x1 and defined $y1 and defined $x2 and defined $y2) {
        $image = $image->crop(
            left   => $x1,
            right  => $x2,
            top    => $y1,
            bottom => $y2
        );
        $uuid = $self->result_source->schema->resultset('Media')->new_uuid;
        $self->uuid($uuid);
    }
    my $width  = $image->getwidth;
    my $height = $image->getheight;

    my $stored = $self->store_format('original', $image);

    if ($stored) {
        $self->mime_type($mime_type);
        $self->width($width);
        $self->height($height);
        $self->caption($caption)         if ($caption);
        $self->description($description) if ($description);
        $self->alt($alt)                 if ($alt);
        $self->uuid($uuid)               if ($uuid);
        $self->update;
        $self->discard_changes;
    }
    return $self;
}

__PACKAGE__->meta->make_immutable;

1;
