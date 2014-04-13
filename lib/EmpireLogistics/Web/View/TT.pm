package EmpireLogistics::Web::View::TT;

use Moose;
use List::AllUtils qw/uniq/;
extends 'Catalyst::View::TT';

sub stylesheets {
    my ( $self, $c ) = @_;

    my @sheets = uniq @{ $c->stylesheets };

    return _stylesheets( $c, 'all', @sheets );
}

sub _stylesheets {
    my ( $c, $media, @files ) = @_;
    $media = 'all' unless ($media);
    return join "\n  ", map {
        sprintf
            q|<link rel="stylesheet" href="%s" type="text/css" media="%s" />|,
            $c->uri_for($_), $media,
    } @files;
}

sub jsfiles {
    my ( $self, $c ) = @_;
    my @jsfiles = uniq @{ $c->jsfiles };
    return _jsfiles( $c, @jsfiles );
}

sub _jsfiles {
    my ( $c, @files ) = @_;
    return join "\n  ", map {
        sprintf q|<script type="text/javascript" src="%s"></script>|,
            $c->uri_for($_)
    } @files;
}

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
