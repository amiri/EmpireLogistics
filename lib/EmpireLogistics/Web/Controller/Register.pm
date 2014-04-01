package EmpireLogistics::Web::Controller::Register;

use Moose;
use MooseX::MethodAttributes;
use aliased 'EmpireLogistics::Form::Register';
use Try::Tiny;
use namespace::autoclean;
extends 'Catalyst::Controller';

sub base : Chained('/') PathPart('register') CaptureArgs(0) {
    my ($self,$c) = @_;
    my $form = Register->new(
        action => '/register',
        schema => $c->model('DB')->schema,
    );
    $c->stash->{registration_form} = $form;
    $c->stash->{template} = 'register.tt';
    return 1;
}

sub post_register : Chained('base') PathPart('') Args(0) POST {
    my ($self,$c) = @_;
    my $form = $c->stash->{registration_form};
    return unless $form->process( $c->req->body_params );
    if ( $form->validated ) {
        my $email = $form->field('email')->value;
        my $password = $form->field('password')->value;
        my $nickname = $form->field('nickname')->value;
        my $new_user;
        try {
            $new_user = $c->model('DB::User')->create({
                email => $email,
                password => $password,
                nickname => $nickname,
            });
        } catch {
            die "Could not create a new user: $_";
        };
        if ($new_user) {
            $c->authenticate({
                email => $email,
                password => $password,
            });
            $c->redirect_and_detach('/');
        }
    }
    return 1;
}

sub get_register : Chained('base') PathPart('') Args(0) GET {
    my ($self,$c) = @_;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
