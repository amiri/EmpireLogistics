package EmpireLogistics::Web::View::CSV;

use Moose;
use namespace::autoclean;
extends 'Catalyst::View::CSV';

__PACKAGE__->config ( sep_char => ",", suffix => "csv" );

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
