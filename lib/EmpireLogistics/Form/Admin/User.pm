package EmpireLogistics::Form::Admin::User;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'Printable', 'NotAllDigits' );
use MooseX::Types::Common::String ('StrongPassword');
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'user-form' );
has '+item_class' => ( default => 'User' );

has_field 'id' => (
    type  => 'Display',
    label => 'User ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);
has_field 'email' => (
    type               => 'Email',
    email_valid_params => {
        -mxcheck  => 1,
        -tldcheck => 1,
    },
    required => 1,
);
has_field 'password' => (
    type      => 'Password',
    widget => 'Text',
    apply     => [ NoSpaces, Printable, NotAllDigits, StrongPassword ],
    minlength => 8,
);
has_field 'nickname' => (
    type     => 'Text',
    required => 1,
    label    => "Display Name",
);
has_field 'description' => ( type => 'TextArea', );
has_field 'notes'       => ( type => 'TextArea', );
has_field 'roles'       => (
    type   => 'Multiple',
    widget => 'CheckboxGroup',
);
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);

sub options_roles {
    my $self = shift;
    my @options = map { { label => ucfirst( $_->name ), value => $_->id } }
        $self->schema->resultset("Role")->all;
    return \@options;
}

__PACKAGE__->meta->make_immutable;

1;
