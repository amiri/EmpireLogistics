package EmpireLogistics::Form::Admin::BulkImport;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';

has '+name'    => ( default => 'bulk-import' );
has '+enctype' => ( default => 'multipart/form-data' );

has_field 'object_type' => (
    type         => 'Select',
    label        => 'Object Type',
    required     => 1,
    empty_select => '-- Choose One --',
);

has_field 'csv' => (
    type     => 'Upload',
    max_size => 2048000,
    required => 1,
);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Upload CSV',
    element_class => [ 'btn', 'btn-primary' ],
);

sub options_object_type {
    my $self = shift;
    return [
        { label => "Port",           value => "Port", },
        { label => "Rail Interline", value => "RailInterline", },
        { label => "Rail Line",      value => "RailLine", },
        { label => "Rail Node",      value => "RailNode", },
        { label => "Warehouse",      value => "Warehouse", },
    ];
}

sub validate_csv {

}

__PACKAGE__->meta->make_immutable;

1;
