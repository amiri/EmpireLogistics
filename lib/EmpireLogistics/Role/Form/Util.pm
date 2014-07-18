package EmpireLogistics::Role::Form::Util;

use Moose::Role;
use DateTime;
use namespace::autoclean;

sub deflate_delete_time {
    my ($self, $value) = @_;
    return ($value) ? 1 : 0;
}

sub inflate_delete_time {
    my ($self, $value) = @_;
    return ($value) ? DateTime->now : undef;
}

sub url_friendly {
  my ($text, %args) = @_;
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
  if ( $max_length > 0 ) {
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

1;
