package EmpireLogistics::Form::Admin::User;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline',
    'NotAllDigits');
use MooseX::Types::Common::String ('StrongPassword');
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'user-form');
has '+item_class' => (default => 'User');

sub build_render_list {
    return [
        'metadata_block',
        'basic_block',
        'text_block',
        'submit',
    ];
}
has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => [
        'id',
        'create_time',
        'update_time',
        'delete_time',
    ],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => [
        'email',
        'nickname',
        'password',
        'roles'
    ],
);
has_block 'text_block' => (
    tag         => 'fieldset',
    label       => 'Miscellaneous',
    render_list => [
        'notes_block',
        'description_block',
    ],
);

has_block 'notes_block' => (
    tag => 'fieldset',

    #class => ['col-md-6'],
    label       => 'Notes',
    render_list => ['notes'],
);
has_block 'description_block' => (
    tag => 'fieldset',

    #class => ['col-md-6'],
    label       => 'Description',
    render_list => ['description'],
);

has_field 'id' => (
    type  => 'Hidden',
    disabled => 1,
    readonly => 1,
    label => 'User ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_time,
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
    widget    => 'Text',
    apply     => [NoSpaces, PrintableAndNewline, NotAllDigits, StrongPassword],
    minlength => 8,
    noupdate  => 1,
);
has_field 'nickname' => (
    type     => 'Text',
    required => 1,
    label    => "Display Name",
);
has_field 'description' => (
    type => 'TextArea', element_wrapper_class => ['col-lg-10'],
);
has_field 'notes' => (type => 'TextArea',);
has_field 'roles' => (
    type   => 'Multiple',
    widget => 'CheckboxGroup',
);
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => ['btn', 'btn-primary'],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

sub options_roles {
    my $self = shift;
    my @options = map { {label => ucfirst($_->name), value => $_->id} }
        $self->schema->resultset("Role")->all;
    return \@options;
}

__PACKAGE__->meta->make_immutable;

1;
