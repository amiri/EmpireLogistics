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

1;
