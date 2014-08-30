package EmpireLogistics::Form::Admin::Delete;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'delete-form' );
has '+item_class' => ( default => '' );

has_field 'id' => (
    type  => 'Hidden',
    label => 'ID',
);
has_field 'delete_time' => (
    type           => 'Hidden',
    deflate_method => \&deflate_time,
    value => 1,
);
has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;

1;
