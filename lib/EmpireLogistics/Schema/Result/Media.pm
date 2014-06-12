package EmpireLogistics::Schema::Result::Media;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use Data::UUID;
use IO::All;
use Try::Tiny;
use Image::Magick;
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

sub file_url {
    my ($self, $format, %args) = @_;
    my $secure      = $args{secure} || 0;
    my $filename    = $args{filename};

    # If a width was passed but not a height, assume it's a
    # maximum width and calculate a proportional height
    if ($format) {
        my ($width, $height) = ($format =~ m%^(\d+)?x(\d+)?$%);
        if ($width && !$height) {
            $format = ($self->width && ($width < $self->width)) ?
                $width . 'x' . $self->inner_height($width) : undef;
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
    my $extension = $self->_extension_for_content_type($content_type);
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
    'jpeg'      => 'jpg',
    'x-jpeg'    => 'jpg',
    'pjpeg'     => 'jpg',
    'x-png'     => 'png',
    'x-bmp'     => 'bmp',
    'svg+xml'   => 'svg',
    'x-svg'     => 'svg',
    'x-gif'     => 'gif',
    'x-tiff'    => 'jpg',
    'tiff'      => 'jpg',
    'pdf'       => 'pdf',
);

sub _extension_for_content_type {
    my $self = shift;
    my ($content_type) = @_;

    return undef unless ($content_type =~ m{^(?:image|application)/(.*)});

    my $extension = $1;

    return $extension_alternatives{$extension} || $extension;
}

sub store_format {
    my ($self, $format, $rcontent) = @_;

    # Store the media on local disk (always)
    my $stored_on_disk = $self->store_on_disk($format, $rcontent);

    return $stored_on_disk;
}

sub store_on_disk {
    my ($self, $format, $rcontent) = @_;

    my $disk_filename = $self->disk_filename($format);

    return try {
        io($disk_filename)->binary->print($$rcontent);
        1;
    } catch {
        die "ERROR: Unable to store media on disk: $_";
        undef;
    };
}

sub disk_filename {
    my ($self, $format) = @_;

    my $srcroot   = EmpireLogistics::Config->srcroot;
    my $directory = $srcroot . '/root/images' . $self->pathname($format);
    try {
        make_path($directory) unless -d $directory;
    }
    catch {
        die "Could not make directory: $_";
    };

    my $disk_filename = $directory . $self->basename($format);
    return $disk_filename;
}

__PACKAGE__->meta->make_immutable;

1;
