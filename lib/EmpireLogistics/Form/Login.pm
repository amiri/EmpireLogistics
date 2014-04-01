package EmpireLogistics::Form::Login;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'EmpireLogistics::Form::Base';

has '+name' => (default => 'login');

has_field 'email' => (
    type => 'Email',
    required => 1,
);
has_field 'password' => (
    type => 'Password',
    required => 1,
);
has_field 'submit' => (
    type => 'Submit',
    widget => 'ButtonTag',
    value => 'Login',
    element_class => ['btn','btn-primary'],
);

__PACKAGE__->meta->make_immutable;

1;
