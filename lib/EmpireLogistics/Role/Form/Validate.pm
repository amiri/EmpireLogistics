package EmpireLogistics::Role::Form::Validate;

use Moose::Role;
use namespace::autoclean;

sub validate_email {
    my ( $self, $field ) = @_;
    my $count = $self->form->schema->resultset('User')
        ->search( { email => $field->value, } )->count;
    if ($count) {
        $field->add_error("That email is already registered");
    }
}

sub validate_nickname {
    my ( $self, $field ) = @_;
    my $count = $self->form->schema->resultset('User')
        ->search( { nickname => $field->value, } )->count;
    if ($count) {
        $field->add_error("That nickname is already taken");
    }
}



1;
