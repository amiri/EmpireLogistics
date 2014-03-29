package EmpireLogistics::Util::Script;

use EmpireLogistics::Config;
use DBI;
use Moose ();
use Try::Tiny;
use Data::Dumper;
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    as_is     => [ 'dbh', 'schema'],
);

sub db_user {
    my $self = shift;
    return $EmpireLogistics::Config::database->{db_user};
}
sub db_pass {
    my $self = shift;
    return $EmpireLogistics::Config::database->{db_pass};
}
sub dsn {
    my $self = shift;
    return EmpireLogistics::Config->dsn;
}
sub db_opts {
    my $self = shift;
    return $EmpireLogistics::Config::database->{db_opts};
}

sub schema {
    my $self = shift;
    return EmpireLogistics::Schema->connect(
       $self->dsn,$self->db_user,$self->db_pass,$self->db_opts,
    );
}

sub dbh {
    my $self = shift;
    my $db_user = $self->db_user;
    my $db_pass = $self->db_pass;
    my $db_opts = $self->db_opts;
    my $dsn = $self->dsn;

    my $dbh;
    try {
        $dbh = DBI->connect($dsn, $db_user, $db_pass, $db_opts);
    } catch {
        warn "Could not connect to database: $_";
    };
    return $dbh;
}

1;
