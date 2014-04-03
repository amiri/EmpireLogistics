package EmpireLogistics::Form::Register;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'Printable', 'NotAllDigits' );
use MooseX::Types::Common::String ('StrongPassword');
use namespace::autoclean;
extends 'EmpireLogistics::Form::Base';

has '+name' => (default => 'register');

has 'schema' => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
);

has_field 'email' => (
    type => 'Email',
    email_valid_params => {
        -mxcheck => 1,
        -tldcheck => 1,
    },
    required => 1,
);
has_field 'password' => (
    type => 'Password',
    apply => [ NoSpaces, Printable, NotAllDigits, StrongPassword ],
    minlength => 8,
    required => 1,
);
has_field 'password_conf' => (
    type => 'PasswordConf',
    required => 1,
    label => "Confirm Password",
);
has_field 'nickname' => (
    type => 'Text',
    required => 1,
    label => "Display Name",
);
has_field 'submit' => (
    type => 'Submit',
    widget => 'ButtonTag',
    value => 'Register',
    element_class => ['btn','btn-primary'],
);

sub validate_email {
    my $self = shift;
    my $count =
      $self->form->schema->resultset('User')
      ->search({email_address => $self->value,})->count;
    if ($count) {
        $self->add_error("That email is already registered");
    }
}

sub validate_nickname {
    my $self = shift;
    my $count =
      $self->form->schema->resultset('User')
      ->search({nickname => $self->value,})->count;
    if ($count) {
        $self->add_error("That nickname is already taken");
    }
}

__PACKAGE__->meta->make_immutable;

1;
