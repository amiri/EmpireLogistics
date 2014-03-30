package EmpireLogistics::Form::Login;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'EmpireLogistics::Form::Base';

has_field 'email_address' => (
    type => 'Email',
    required => 1,
);
has_field 'password' => (
    type => 'Password',
    required => 1,
);
has_field 'submit' => (
    type => 'Submit',
    label => 'Login',
);

__PACKAGE__->meta->make_immutable;

1;
