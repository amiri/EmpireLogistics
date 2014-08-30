package EmpireLogistics::Role::Form::Util;

use Moose::Role;
use DateTime;
use namespace::autoclean;

sub deflate_time {
    my ($self, $value) = @_;
    return ($value) ? 1 : 0;
}

sub inflate_time {
    my ($self, $value) = @_;
    return ($value) ? DateTime->now : undef;
}

sub url_friendly {
    my ($self, $text, %args) = @_;
    return $text unless ($text);

    my $min_length    = $args{'min_length'}    || 0;
    my $max_length    = $args{'max_length'}    || 0;
    my $separator     = $args{'separator'}     || '-';
    my $preserve_case = $args{'preserve_case'} || 0;

    # Compress apostrophes
    $text =~ s/'//g;

    # Replace non alphanumeric with separator
    $text =~ s/[^[:alnum:]]+/$separator/g;

    # Strip out leading separator
    $text =~ s/^\Q$separator\E//;

    # Try to trim at a "word" boundary somewhere between min and max
    if ($max_length > 0) {
        my $extra_length = $max_length - $min_length;
        $text = "$1$2"
            if "$text$separator" =~ /^
                     ( .{$min_length} )
                     ( .{0,$extra_length} )
                     \Q$separator\E
                   /x;

        # If word boundary search failed, chop anyways
        $text = substr($text, 0, $max_length);
    }

    # Strip out trailing separator
    $text =~ s/\Q$separator\E$//;

    # Lowercase (unless asked not to)
    $text = lc($text) unless $preserve_case;

    return $text;
}

sub lowercase {
    my ($value, $field) = @_;
    return lc($value);
}

sub media_links {
    my ($value, $field) = @_;
    my $new_value = youtube_video_links($value, $field);
    $new_value = image_links($new_value, $field);
    return $new_value;
}

sub youtube_video_links {
    my ($value, $field) = @_;
    my $new_value;
    $new_value = $value;
    if ($new_value) {
        while ($new_value =~ /\[YoutubeID\:\s*(.+)\]/) {
            my $youtube_id = $1;
            my $replace_with =
                qq{<iframe width="560" height="315" src="//www.youtube.com/embed/$youtube_id" frameborder="0" allowfullscreen></iframe>};
            $new_value =~ s{
                \[YoutubeID\:\s*(.+)\]
            }{
                $replace_with
            }xg;
        }
    }
    return $new_value;
}

sub image_links {
    my ($value, $field) = @_;
    my $new_value;
    $new_value = $value;
    if ($new_value) {
        while ($new_value =~ /\[MediaID\:\s*(\w+)\]/) {
            my $media_id = $1;
            my $media =
                $field->form->schema->resultset('Media')->find({id => $media_id}, {key => 'primary'});
            my $url    = $media->file_url;
            my $width  = $media->width;
            my $height = $media->height;
            my $replace_with =
                qq{<img src="$url" height="$height" width="$width" />};
            $new_value =~ s{
                \[MediaID\:\s*(\w+)\]
            }{
                $replace_with
            }xg;
        }
    }
    return $new_value;
}

1;
