package EmpireLogistics::Util::Script;

use EmpireLogistics::Config;
use DBI;
use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    as_is     => [ 'dbh', 'schema'],
);

has 'dbh' => (
    is => 'ro',
    isa => 'DBI::dbh',
    lazy => 1,
    builder => '_build_dbh',
);
has 'schema' => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
    lazy => 1,
    builder => '_build_schema',
);
has 'dsn' => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_dsn',
);
has 'db_user' => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_db_user',
);
has 'db_pass' => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_db_pass',
);
sub _build_db_pass {
    my $self = shift;
    return $EmpireLogistics::Config::database::db_pass;
}
sub _build_dsn {
    my $self = shift;
    return EmpireLogistics::Config->dsn;
}
sub _build_db_opts {
    my $self = shift;
    return $EmpireLogistics::Config::database::db_opts;
}

sub _build_schema {
    my $self = shift;
    return EmpireLogistics::Schema->connect(
       $self->dsn,$self->db_user,$self->db_pass,$self->db_opts, 
    );
}

sub _build_dbh {
    my $self = shift;
    my ($db_name,$db_host,$db_user,$db_pass,$db_port,$db_opts) = $self->$_ for qw/db_name db_host db_user db_pass db_port/;
    my $dsn = "dbi:Pg:dbname=$db_name;host=$db_host;port=$db_port";

    my $dbh;
    try {
        $dbh = DBI->connect($dsn, $db_user, $db_pass, $db_opts);
    } catch {
        warn "Could not connect to database: $_";
    };
    return $dbh;
}

__PACKAGE__->meta->make_immutable;

1;
