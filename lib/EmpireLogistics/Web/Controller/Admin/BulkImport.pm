package EmpireLogistics::Web::Controller::Admin::BulkImport;

use Moose;
use MooseX::MethodAttributes;
use Data::Printer;
use Try::Tiny;
use aliased 'EmpireLogistics::Form::Admin::BulkImport';
use namespace::autoclean;

BEGIN { extends 'EmpireLogistics::Web::Controller::Admin' }

__PACKAGE__->config(
    form    => 'EmpireLogistics::Form::Admin::BulkImport',
    actions => {
        bulk_import_base => {
            PathPart    => ['bulk-import'],
            Chained     => ['admin_base'],
            CaptureArgs => 0
        }
    },
);

has 'form' => (
    is       => 'ro',
    required => 1,
);

sub bulk_import_base : Chained('') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $schema = $c->model('DB')->schema;
    $c->stash(
        schema => $schema,
        form   => $self->form->new(
            action => $c->req->base . $c->req->path,
            schema => $schema,
        ),
        template => 'admin/bulk-import/index.tt',
    );
}

sub get_index : Chained('bulk_import_base') PathPart('') Args(0) GET {
    my ( $self, $c ) = @_;
}

sub post_index : Chained('bulk_import_base') PathPart('') Args(0) POST {
    my ( $self, $c ) = @_;
    my $form = $c->stash->{form};
    $c->req->body_params->{'file'} = $c->req->upload('file');
    return unless $form->process( $c->req->body_params );
    if ( $form->validated ) {
        try {
            $form->validator->save;
        }
        catch {
            $c->error("Could not save csv data: $_");
        };
        $c->stash->{alert}
            = [ { class => 'success', message => "BulkImport successful" } ];
    }
}

sub get_sample_csv_type : Chained('bulk_import_base') PathPart('sample-csv')
    Args(1) {
    my ( $self, $c, $csv_type ) = @_;
    return unless $csv_type;
    my ( $sample_data, $columns )
        = $c->model('BulkImport')->sample_data( rs_name => $csv_type );
    $c->stash(
        data         => $sample_data,
        columns      => $columns,
        filename     => "bulk_import_" . lc($csv_type) . ".csv",
        current_view => 'CSV',
    );
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
