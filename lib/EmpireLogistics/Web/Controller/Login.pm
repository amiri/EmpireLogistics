package EmpireLogistics::Web::Controller::Login;

use Moose;
use MooseX::MethodAttributes;
use aliased 'EmpireLogistics::Form::Login';
use namespace::autoclean;
extends 'Catalyst::Controller';

sub base : Chained('/') PathPart('login') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $form = Login->new( action => '/login' );
    $c->stash->{login_form} = $form;
    $c->stash->{template}   = 'login.tt';
    return 1;
}

sub post_index : Chained('base') PathPart('') Args(0) POST {
    my ( $self, $c ) = @_;
    my $form = $c->stash->{login_form};
    return unless $form->process( $c->req->body_params );
    if ( $form->validated ) {
        my $email    = $form->field('email')->value;
        my $password = $form->field('password')->value;
        my $authenticated;
        $authenticated = $c->authenticate({
            email    => $email,
            password => $password,
        });
        if ($authenticated) {
            $c->redirect_and_detach('/');
        } else {
            $form->add_form_error("Invalid email or password");
        }
    }
    return 1;
}

sub get_index : Chained('base') PathPart('') Args(0) GET {
    my ( $self, $c ) = @_;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
