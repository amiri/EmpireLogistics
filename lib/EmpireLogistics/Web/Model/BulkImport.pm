package EmpireLogistics::Web::Model::BulkImport;

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use DateTimeX::Easy;
use IO::All;
use Text::CSV_XS;
use Text::CSV::Encoded coder_class =>
    'Text::CSV::Encoded::Coder::EncodeGuess';
use Try::Tiny;
use List::AllUtils qw/none/;
use Lingua::Conjunction;
use EmpireLogistics::Schema;
use EmpireLogistics::Config;
use Data::Printer;
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

has 'context' => ( is => 'ro' );

has 'schema' => (
    is      => 'ro',
    isa     => 'DBIx::Class::Schema',
    lazy    => 1,
    builder => '_build_schema',
);

has 'errors' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        has_errors => 'count',
        add_error  => 'push',
    },
);

has 'csv_parser' => (
    is      => 'rw',
    isa     => 'Text::CSV::Encoded',
    builder => '_build_csv_parser',
);

has 'file_contents' => (
    is      => 'ro',
    isa     => 'IO::All::File',
    lazy    => 1,
    builder => '_build_file_contents',
);

has 'columns_for_object_type' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_columns_for_object_type',
);
has 'column_info_for_object_type' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_column_info_for_object_type',
);

has 'object_types' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [   qw/
                Port
                RailNode
                Warehouse
                /
        ];
    },
);

has 'file' => (
    is  => 'ro',
    isa => duck_type( [qw/filename size tempname type/] ),
);

has 'object_type' => (
    is  => 'ro',
    isa => 'Str',
);

has 'rows' => (
    is => 'rw',
    isa => 'ArrayRef',
);

sub _build_schema {
    my $self = shift;
    return EmpireLogistics::Schema->connect(
        EmpireLogistics::Config->connect_info );
}

sub build_per_context_instance {
    my ( $self, $c, @args ) = @_;
    return $self->new( { context => $c, %$self, @args } );
}

sub _build_csv_parser {
    my $self = shift;
    my $csv  = Text::CSV::Encoded->new(
        {   allow_loose_quotes => 1,
            binary             => 1,
            blank_is_undef     => 1,
            empty_is_undef     => 1,
            auto_diag          => 2,    # die on errors
            eol                => $/,
        }
    );
    $csv->encoding_in( [ 'iso-8859-1', 'cp1252', 'ascii' ] );
    $csv->encoding_out('utf8');
    return $csv;
}

sub _build_file_contents {
    my $self = shift;
    return io( $self->file->tempname );
}

sub _build_columns_for_object_type {
    my $self   = shift;
    my %result = ();
    for my $type ( @{ $self->object_types } ) {

        my $rs               = $self->schema->resultset($type);
        my @relevant_columns = grep {
            !( $rs->result_source->column_info($_)->{is_auto_increment} )
            }
            grep {
            !/geometry/
            }
            grep {
            !/(create|delete|update)_time/
            } $rs->result_source->columns;
        $result{$type} = \@relevant_columns;
    }
    return \%result;
}

sub _build_column_info_for_object_type {
    my $self   = shift;
    my %result = ();
    for my $type ( @{ $self->object_types } ) {

        my $rs = $self->schema->resultset($type);
        my %column_info
            = map { $_ => $rs->result_source->column_info($_) } grep {
            !( $rs->result_source->column_info($_)->{is_auto_increment} )
            }
            grep {
            !/geometry/
            }
            grep {
            !/(create|delete|update)_time/
            } $rs->result_source->columns;
        $result{$type} = \%column_info;
    }
    return \%result;
}

sub sample_data {
    my ( $self, %args ) = @_;
    return unless $args{rs_name};
    my $rs_name          = $args{rs_name};
    my $relevant_columns = $self->columns_for_object_type->{$rs_name};
    my @rows             = map {
        my $item   = $_;
        my $return = {};
        $return->{$_} = $item->$_ for @$relevant_columns;
        $return;
        } $self->schema->resultset($rs_name)->search(
        {},
        {   rows    => 10,
            columns => $relevant_columns,
        }
        )->all;
    return ( \@rows, $relevant_columns );
}

sub validate_file {
    my ( $self, $file, $object_type ) = @_;
    return 0 unless $self->file_is_csv;
    return 0 unless $self->file_has_valid_header;
    return 0 unless $self->file_has_valid_data_for_object_type;
    return 1;
}

sub file_is_csv {
    my $self          = shift;
    my $file_contents = io( $self->file->tempname );
    my $return;
    try {
        $self->csv_parser->parse( $self->file_contents );
        $return = 1;
    }
    catch {
        $self->add_error($_);
        $return = 0;
    };
    return $return;
}

sub file_has_valid_header {
    my $self = shift;
    my $header;
    try {
        $self->csv_parser->column_names(
            @{ $self->columns_for_object_type->{ $self->object_type } } );
        $header = $self->csv_parser->getline( $self->file_contents );
    }
    catch {
        $self->add_error("There was a problem parsing the csv header: $_");
        return 0;
    };
    my %submitted_header = map { $_ => 1 } @$header;
    my %missing_headers = ();
    for my $required_header (
        @{ $self->columns_for_object_type->{ $self->object_type } } )
    {
        $missing_headers{$required_header} = 1
            unless exists $submitted_header{$required_header};
    }
    if ( scalar keys %missing_headers ) {
        $self->add_error("Your csv header is missing field: $_")
            for keys %missing_headers;
        return 0;
    }
    return 1;
}

sub file_has_valid_data_for_object_type {
    my ( $self, $file, $object_type ) = @_;
    my $rows = $self->csv_parser->getline_hr_all( $self->file_contents );
    my $rs   = $self->schema->resultset( $self->object_type );
    my $i    = 2;
    for my $row (@$rows) {
        for my $field ( keys %$row ) {
            my $constraints
                = $self->column_info_for_object_type->{ $self->object_type }
                {$field};
            if (    exists $constraints->{is_nullable}
                and !$constraints->{is_nullable}
                and
                ( not defined $row->{$field} or not exists $row->{$field} ) )
            {
                $self->add_error(
                    "You are missing a value for $field at line $i");
            }
            if (    $constraints->{data_type} =~ /(integer|double precision)/
                and defined $row->{$field}
                and not Scalar::Util::looks_like_number( $row->{$field} ) )
            {
                $self->add_error(
                          "Invalid numeric value for $field at line $i: "
                        . $constraints->{data_type}
                        . " required" );
            }
            if (    $constraints->{data_type} eq 'enum'
                and defined $row->{$field}
                and none { $row->{$field} eq $_ }
                @{ $constraints->{extra}{list} } )
            {
                Lingua::Conjunction->connector_type("or");
                my $error_message
                    = qq|Invalid enum value for $field at line $i: |;
                $error_message .= qq|$row->{$field} given; one of |;
                $error_message
                    .= conjunction( @{ $constraints->{extra}{list} } );
                $error_message .= qq| required|;
                $self->add_error($error_message);
            }
            if ( $constraints->{data_type} =~ /(date|timestamp)/
                and defined $row->{$field} )
            {
                try {
                    DateTimeX::Easy->parse( $row->{$field} );
                }
                catch {
                    my $error_message
                        = qq|Invalid $constraints->{data_type} for field $field at line $i: |;
                    $error_message .= $_;
                    $error_message .= qq|; try YYYY-MM-DD|;
                    $self->add_error($error_message);
                };

            }
        }
        $i++;
    }
    $self->rows($rows);
    return 1;
}

sub save {
    my $self = shift;
    my $rows = $self->rows;
    try {
        my @rows = $self->schema->resultset($self->object_type)->populate($rows);
    } catch {
        die $_;
    };
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
