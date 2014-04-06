package EmpireLogistics::Web::Controller::Admin::BulkImport;

use Moose;
use MooseX::MethodAttributes;
use namespace::autoclean;

BEGIN { extends 'EmpireLogistics::Web::Controller::Admin' };

sub bulk_import_base :Chained('admin_base') PathPart('bulk-import') CaptureArgs(0) {
    my ($self,$c) = @_;
}

sub get_index :Chained('bulk_import_base') PathPart('') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'admin/bulk-import/index.tt';
}

__PACKAGE__->meta->make_immutable;

1;
