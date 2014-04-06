package EmpireLogistics::Role::Form::Util;

use Moose::Role;
use namespace::autoclean;

sub deflate_delete_time {
    my ($self, $value) = @_;
    return ($value) ? 1 : 0;
}

1;
