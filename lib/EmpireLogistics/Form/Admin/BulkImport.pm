package EmpireLogistics::Form::Admin::BulkImport;

use HTML::FormHandler::Moose;
use EmpireLogistics::Web::Model::BulkImport;
use namespace::autoclean;
extends 'EmpireLogistics::Form::Base';

has '+name'    => ( default => 'bulk-import' );
has '+enctype' => ( default => 'multipart/form-data' );
has 'schema'   => (
    is       => 'rw',
    isa      => 'DBIx::Class::Schema',
    required => 1,
);
has 'validator' => (
    is => 'ro',
    isa => 'EmpireLogistics::Web::Model::BulkImport',
    lazy => 1,
    builder => '_build_validator',
);
has_field 'object_type' => (
    type         => 'Select',
    label        => 'Object Type',
    required     => 1,
    empty_select => '-- Choose One --',
);

has_field 'sample_data' => (
    type  => 'Display',
    label => 'Sample Data',
);

sub html_sample_data {
    my $self = shift;
    return qq|<div class="form-group sample-data">
                  <div class="col-lg-5 col-lg-offset-2">
                  <div class="alert alert-warning">
                      <p><a>Download Sample CSV data for the object type selected</a></p>
                  </div>
                  </div>
              </div>|;
}

has_field 'file' => (
    type     => 'Upload',
    max_size => 2048000,
    required => 1,
    label    => "CSV File"
);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Upload CSV',
    element_class => [ 'btn', 'btn-primary' ],
    element_wrapper_class => ['col-lg-5', 'col-lg-offset-0', 'buffer'],
);

sub _build_validator {
    my $self = shift;
    return EmpireLogistics::Web::Model::BulkImport->new(
        file        => $self->field('file')->value,
        object_type => $self->field('object_type')->value,
        schema      => $self->schema,
    );
}

sub options_object_type {
    my $self = shift;
    return [
        { label => "Port",      value => "Port", },
        { label => "Rail Node", value => "RailNode", },
        { label => "Warehouse", value => "Warehouse", },
    ];
}

sub validate {
    my ($self)            = shift;
    my $file_field        = $self->field('file');
    my $object_type_field = $self->field('object_type');
    my $type              = $file_field->value->type;
    $file_field->add_error('That is not a valid csv') unless $type =~ /csv/;
    $file_field->add_error('That is not a valid csv')
        unless $self->validator->validate_file;
    $file_field->add_error($_) for @{$self->validator->errors};
}

__PACKAGE__->meta->make_immutable;

1;
