package EmpireLogistics::Form::Admin::Blog;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'PrintableAndNewline', 'NotAllDigits');
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => (default => 'blog-form');
has '+item_class' => (default => 'Blog');
has 'js_files'    => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [
        ];
    },
);
has 'stylesheets' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [
        ];
    },
);

sub build_render_list {
    return [
        'metadata_block', 'basic_block', 'submit',
    ];
}

has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => [
        'id', 'create_time', 'update_time', 'delete_time',
    ],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic',
    render_list => [
        'title', 'url_title', 'body', 'author',
    ],
);

has_field 'id' => (
    type     => 'Integer',
    element_attr => { readonly => 'readonly' },
    disabled => 1,
    label    => 'Blog ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    element_attr => { readonly => 'readonly' },
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    element_attr => { readonly => 'readonly' },
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);

has_field 'title' => (
    type  => 'Text',
    label => 'Title',
);

has_field 'url_title' => (
    type  => 'Text',
    label => 'URL Title',
    apply => [NoSpaces, NotAllDigits],
);

has_field 'body' => (
    type  => 'TextArea',
    label => 'Body',
    apply => [PrintableAndNewline, NotAllDigits],
);

has_field 'author' => (
    type  => 'Select',
    label => 'Author',
);

sub options_author {
    my $self = shift;
    return [
        map {{
            label => $_->nickname . " (".$_->email.")",
            value => $_->id,
        }} $self->schema->resultset("User")->active->all
    ];
    #return $self->user_id;
}

has_field 'submit' => (
    type                  => 'Submit',
    widget                => 'ButtonTag',
    value                 => 'Save',
    element_class         => ['btn', 'btn-primary'],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

__PACKAGE__->meta->make_immutable;

1;

