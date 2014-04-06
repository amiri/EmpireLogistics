package EmpireLogistics::Web::Controller::Admin;

use Moose;
use MooseX::MethodAttributes;
use EmpireLogistics::Config;
use List::AllUtils qw/uniq/;
use Data::Printer;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub auto : Private {
    my ( $self, $c ) = @_;
    if (!$c->user) {
        my $backref = $c->build_backref;
        $c->user_session->{backref} = $backref;
        $c->flash->{alert} =  [{ class => 'danger', message => 'Access denied.'}];
        $c->res->redirect("/login");
        return 1;
    }
    $c->check_user_roles(qw/admin/)
        or $c->detach(qw/Controller::Root access_denied/);
}

sub admin_base : Chained('/') PathPart('admin') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $namespace   = "Admin::";
    my @controllers = $c->controllers;
    my @admin_pages = map {
        ( my $label = $_ ) =~ s/^$namespace//g;
        {
            name => $label,
            url  => $c->uri_for( $c->controller($_)->action_for('get_index') )
        }
    } grep {
        /^$namespace/
    } uniq sort @controllers;
    $c->stash->{admin_pages} = \@admin_pages;
}

sub get_admin_index : Chained('admin_base') PathPart('') Args(0) GET {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'admin/index.tt';
}

__PACKAGE__->meta->make_immutable;

1;
