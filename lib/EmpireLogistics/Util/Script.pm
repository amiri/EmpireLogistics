package EmpireLogistics::Util::Script;

use EmpireLogistics::Config;
use DBI;
use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    as_is     => [ 'dbh', 'schema'],
);

sub db_pass {
    my $self = shift;
    return $EmpireLogistics::Config::database::db_pass;
}
sub dsn {
    my $self = shift;
    return EmpireLogistics::Config->dsn;
}
sub db_opts {
    my $self = shift;
    return $EmpireLogistics::Config::database::db_opts;
}

sub schema {
    my $self = shift;
    return EmpireLogistics::Schema->connect(
       $self->dsn,$self->db_user,$self->db_pass,$self->db_opts, 
    );
}

sub dbh {
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

1;
