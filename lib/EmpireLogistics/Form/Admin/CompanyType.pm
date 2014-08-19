package EmpireLogistics::Form::Admin::CompanyType;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'PrintableAndNewline', 'NotAllDigits', 'NoSpaces' );
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'company-type-form' );
has '+item_class' => ( default => 'CompanyType' );

has_field 'id' => (
    type  => 'Integer',
    disabled => 1,
    readonly => 1,
    label => 'Company Type ID',
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
    deflate_method => \&deflate_delete_time,
);
has_field 'name' => (
    type     => 'Text',
    label    => 'Name',
    required => 1,
    apply    => [ NoSpaces, PrintableAndNewline, NotAllDigits, { transform => \&lowercase, } ],
);



has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

__PACKAGE__->meta->make_immutable;

1;
