package EmpireLogistics::Form::Admin::LaborOrganizationType;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'Printable', 'NotAllDigits' );
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'labor-organization-type-form' );
has '+item_class' => ( default => 'LaborOrganizationType' );

has_field 'id' => (
    type  => 'Integer',
    disabled => 1,
    readonly => 1,
    label => 'Labor Organization Type ID',
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
    apply    => [ Printable, NotAllDigits ],
);
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;

1;