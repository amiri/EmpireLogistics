package EmpireLogistics::Web::View::JSON;

use Moose;
use namespace::autoclean;
extends 'Catalyst::View::JSON';

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
