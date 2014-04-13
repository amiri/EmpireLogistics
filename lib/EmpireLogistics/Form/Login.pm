package EmpireLogistics::Form::Login;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'EmpireLogistics::Form::Base';

has '+name' => (default => 'login');
has 'schema' => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
);

has_field 'email' => (
    type => 'Email',
    required => 1,
);
has_field 'password' => (
    type => 'Password',
    required => 1,
);
has_field 'remember' => (
    type => 'Checkbox',
    label => 'Remember me?',
);
has_field 'submit' => (
    type => 'Submit',
    widget => 'ButtonTag',
    value => 'Login',
    element_class => ['btn','btn-primary'],
);

sub validate_email {
    my ( $self, $field ) = @_;
    my $count = $self->form->schema->resultset('User')
        ->search( { email => $field->value, delete_time => undef } )->count;
    if (!$count) {
        $field->add_error("That is an unknown email address");
    }
}

__PACKAGE__->meta->make_immutable;

1;
