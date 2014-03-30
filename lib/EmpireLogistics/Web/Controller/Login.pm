package EmpireLogistics::Web::Controller::Login;

use Moose;
use MooseX::MethodAttributes;
use aliased 'EmpireLogistics::Form::Login';
use namespace::autoclean;
extends 'Catalyst::Controller';

sub base :Chained('/') PathPart('login') CaptureArgs(0) {
    my ($self,$c) = @_;
    my $form = Login->new(action => '/login');
    $c->stash->{login_form} = $form;
    $c->stash->{template} = 'login.tt';
    return 1;
}

sub post_index :Chained('base') PathPart('') Args(0) POST {
    my ($self,$c) = @_;
    my $form = $c->stash->{login_form};
    return unless $form->process($c->req->params);
    if ($form->validated) {
        my $email_address = $form->field('email_address')->value;
        my $password = $form->field('password')->value;
        my $authenticated;
        $authenticated = $c->authenticate({
            email => $email_address,
            password => $password,
        });
        unless ($authenticated) {
            $form->add_form_error("Invalid email or password");
        }
    }
    return 1;
}

sub get_index : Chained('base') PathPart('') Args(0) GET {
    my ($self,$c) = @_;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
