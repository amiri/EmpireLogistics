package EmpireLogistics::Web::View::CSV;

use Moose;
use namespace::autoclean;
extends 'Catalyst::View::CSV';

__PACKAGE__->config(
    sep_char           => ",",
    suffix             => "csv",
    binary             => 1,
    blank_is_undef     => 1,
    empty_is_undef     => 1,
    auto_diag          => 1,
    eol                => $/,
);

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
