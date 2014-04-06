package Catalyst::Plugin::Session::PerEmpireLogisticsUser;
use Moose;
use namespace::autoclean;
extends 'Catalyst::Plugin::Session::PerUser';

sub user_session_sid {
    my $c = shift;
    "session:" . $c->req->cookies->{empirelogistics_web_session}->value;
}


__PACKAGE__->meta->make_immutable;

1;
