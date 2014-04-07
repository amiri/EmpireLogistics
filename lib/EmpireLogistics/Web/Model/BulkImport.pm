package EmpireLogistics::Web::Model::BulkImport;

use Moose;
use MooseX::StrictConstructor;
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

has 'context' => ( is => 'ro' );

has 'schema' => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

sub build_per_context_instance {
    my ( $self, $c, @args ) = @_;
    use Data::Printer;
    warn "In bpci c is $c and args are: ", p @args;
    return $self->new( { context => $c, %$self, @args } );
}

sub sample_data {
    my ( $self, %args ) = @_;
    return unless $args{rs_name};
    my $rs_name = $args{rs_name};
    $self->context->log->warn( "My rs_name is ", $rs_name );
    my $rs = $self->context->model("DB::$rs_name");
    my @relevant_columns = grep {
        !( $rs->result_source->column_info($_)->{is_auto_increment} ) }
    grep {
        !/geometry/
    }
    grep {
        !/(create|delete|update)_time/
    } $rs->result_source->columns;
    my @rows = map {
        my $item = $_;    
        my $return = {};
        $return->{$_} = $item->$_ for @relevant_columns;
        $return;
    } $self->context->model("DB::$rs_name")->search( {}, {
        rows => 10,
        columns => \@relevant_columns,
    })->all;
    return (\@rows, \@relevant_columns);
}

__PACKAGE__->meta->make_immutable;

1;
