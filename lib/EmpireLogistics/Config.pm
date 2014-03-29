package EmpireLogistics::Config;

#use Moose;
warn map { "$_ " } @INC;
my $path = `which perl`;
warn "Perl interp path: $path";
warn "Perl: $^V";
warn "PERL_MB_OPT: ",  $ENV{PERL_MB_OPT};
warn "PERL_MM_OPT: ",  $ENV{PERL_MM_OPT};
warn "PERL5LIB: ",  $ENV{PERL5LIB};
warn "PATH: ",  $ENV{PATH};
warn "PERL_LOCAL_LIB_ROOT: ",  $ENV{PERL_LOCAL_LIB_ROOT};
warn "GID",  $(;
warn "EGID",  $);
warn "UID",  $<;
warn "EUID",  $>;
warn "Archname: ",  $Config::archname;
use Clone qw/clone/;
use Sys::Hostname       ();
use Sys::Hostname::Long ();
use List::AllUtils qw/first/;

our %PARAMETERS = ();
our %NICKNAMES  = ();

$PARAMETERS{default} = {
    srcroot  => "/var/local/EmpireLogistics/current/",
    hostname => 'li431-25',
    tiles_url => '50.116.5.25/tiles',
    database => {
        db_name => 'empirelogistics',
        db_pass => '3mp1r3',
        db_user => 'el',
        db_host => 'localhost',
        db_port => 5432,
        db_opts => {   RaiseError    => 1,
            AutoCommit    => 0,
            on_connect_do => ['set timezone = "America/Los Angeles"']
        },
    },
    catalyst => {
        name => 'EmpireLogistics::Web',
        disable_component_resolution_regex_fallback => 1,
        enable_catalyst_header => 1,
        encoding => 'utf-8',
        default_view => "TT",
        "View::JSON" => {
            allow_callback => 1,
        },
        "View::TT" => {
            TEMPLATE_EXTENSION => '.tt',
            CATALYST_VAR => 'c',
            TIMER        => 0,
            ENCODING     => 'utf-8',
            INCLUDE_PATH => [
                get_current_srcroot() . "/root/templates",
            ],
            WRAPPER            => 'smart_wrapper.tt',
        },
        "Plugin::Static::Simple" => {
            ignore_extensions => [qw/tt/],
        },
    },
};


$PARAMETERS{"development"} = {
    %{ clone $PARAMETERS{'default'} },
    srcroot  => get_current_srcroot(),
    hostname => "akbuntu",
    tiles_url => 'localhost/tiles',
};
$PARAMETERS{"akbuntu"} = {
    %{ clone $PARAMETERS{'development'} },
    srcroot  => "/home/amiri/EmpireLogistics",
    hostname => "akbuntu",
    tiles_url => 'localhost:9999',
};

$PARAMETERS{"vagrant-ubuntu-saucy-"} = {
    %{ clone $PARAMETERS{'development'} },
    hostname => "vagrant-ubuntu-saucy-64",
};

sub mk_package_accessors {
    my ( $self, @fields ) = @_;
    no strict 'refs';
    no warnings 'redefine';
    for my $field (@fields) {
        *{"${self}::$field"} = $self->make_package_accessor($field);
    }
}

sub make_package_accessor {
    my ( $self, $field ) = @_;
    my $class = ref $self || $self;
    my $varname = "$class\:\:$field";
    return sub {
        my $class = shift;
        no strict 'refs';
        return @_ ? ( ${$varname} = $_[0] ) : ${$varname};
        }
}

__PACKAGE__->mk_package_accessors( keys %{ $PARAMETERS{"default"} } );
__PACKAGE__->mk_package_accessors('initialized');
__PACKAGE__->mk_package_accessors('all_parameters');
__PACKAGE__->mk_package_accessors('installation');

sub import {
    my ( $class, %options ) = @_;
    use Data::Printer;
    warn "In import class is $class";
    warn "In import options are: ", p %options;
    $class->init( exists $options{installation} ? $options{installation} : (),
    ) unless $class->initialized;
}

sub init {
    my ( $class, $installation ) = @_;
    warn "In init caller is ", caller;
    warn "In init class is $class";
    warn "In init installation is $installation";

   # if we aren't passed in the canonical installation name, go figure it out.
    $installation //= $class->get_running_installation();

    my $parameters = $class->get_parameters($installation);
    while ( my ( $key, $value ) = each %$parameters ) {
        __PACKAGE__->$key($value);
    }

    __PACKAGE__->all_parameters($parameters);

    $ENV{CATALYST_HOME} = $parameters->{srcroot};

    $class->initialized(1);
}

sub get_running_installation {
    my $class = shift;

    my $hostname = get_system_hostname();
    warn "Hostname in running installation: $hostname";

    return "$hostname";
}

sub get_system_hostname {
    my $class    = shift;
    my $hostname = Sys::Hostname::Long::hostname_long();
    return $hostname;
}

sub get_current_srcroot {

    # this was causing undefined warnings when run through stdin
    my $inc = $INC{"EmpireLogistics/Config.pm"}
        // 'lib/EmpireLogistics/Config.pm';

    require File::Spec;

    if ( $inc !~ m|^/| ) {
        $inc = File::Spec->rel2abs($inc);
    }

    # oh dear. just use Path::Tiny to canonicalize.
    1 while $inc =~ s{
      /[^/]+/\.\./
    |
      /\./
    |
      //+
    |
      ^/?\.+/
    |
      /\.+$
  }{/}x;

    $inc =~ s|/lib/EmpireLogistics/Config\.pm$||;

    # Untaint
    die "Can't untaint srcroot $inc" unless $inc =~ m|^([-+@\w./]+)$|;
    $inc = $1;

    return $inc;
}

sub get_parameters {
    my $class = shift;
    my ($name) = @_;

    warn "In get_parameters caller is ", caller;
    warn "In get parameters class is $class";
    warn "In get parameters name is $name";

    die __PACKAGE__ . ': no installation passed to get_parameters'
        unless $name;

    my $installation = canonical_installation_name($name);
    die "Can't find configuration for installation $installation"
        unless $PARAMETERS{$installation};

    my $parameters = clone( $PARAMETERS{$installation} );

    # Get the hostname and srcroot for this installation.
    # If we were passed a full installation name, just grab them directly
    # If we were given a nickname, get them from the canonical
    # installation, and append any instance-id suffix to the hostname.
    # if we still can't figure it out, go calculate the values directly
    # (TODO: this really should be the ONLY thing we do, rather than deriving
    # from the configs - but I can't be sure that I won't break something by
    # removing this code -- what if a host's config is taken from another's,
    # and we are relying on the incorrect hostname here?)
    my ( $hostname, $srcroot );
    if ( $name =~ /^(.+?):(.+)$/ ) {
        ( $hostname, $srcroot ) = ( $1, $2 );
    } else {
        my $nickname = $name;
        if ( $installation =~ /^(.+?):(.+)$/ ) {
            ( $hostname, $srcroot ) = ( $1, $2 );
        } else {

            # note that this isn't the mechanism used elsewhere in this file
            # for getting the hostname -- that way does not work on OSX, so we
            # use the core mechanism here.
            $hostname = Sys::Hostname::hostname;
            $srcroot  = get_current_srcroot();
        }
    }

    $parameters->{srcroot}  = $srcroot;
    $parameters->{hostname} = $hostname;

    # Make sure all parameters exist in default.
    foreach my $parameter ( keys %$parameters ) {
        die "unknown parameter $parameter (not defined in default hash)"
            if not exists $PARAMETERS{default}{$parameter};
    }

    # Make sure all parameters from default exist.
    foreach my $parameter ( keys %{ $PARAMETERS{default} } ) {
        die "$parameter not set"
            if not exists $parameters->{$parameter};
    }

    $parameters->{installation} = $installation;

    return $parameters;
}

sub canonical_installation_name {
    my $installation = shift;

    # convert 'foobar-i-AA0011BB', 'foobar-00', 'foobar-01.campusexplorer.com'
    # into 'foobar-'
    $installation =~ s/^(.+?)-(\d+|i-[0-9a-f]{8})\b(.*)/$1-$3/;

    die __PACKAGE__
        . ': no installation passed to canonical_installation_name'
        unless $installation;

    # For /tmp/cepush installations, strip out hostname
    $installation =~ s%^.+(/tmp/cepush)$%$1%;
    return $installation if $PARAMETERS{$installation};

    my $nickname = $installation;
    warn "Nickname is $nickname";
    if ( not %NICKNAMES ) {
        foreach my $key ( keys %PARAMETERS ) {
            my $nickname = $PARAMETERS{$key}{nickname};
            next unless $nickname;
            if ( $NICKNAMES{$nickname} ) {

                # We need to unset %NICKNAMES if this happens in case
                # we trap the error and try to keep processing.  If
                # the script tries something clever to fix the error
                # we need to re-check nicknames, which we'll only do
                # if %NICKNAMES is unset when we return.
                %NICKNAMES = ();
                die "Two installations found with nickname of $nickname!";
            }
            $NICKNAMES{$nickname} = $key;
        }
    }

    return $NICKNAMES{$nickname} if $NICKNAMES{$nickname};

    die "Can't find installation '$nickname'";
}

sub dsn {
    my $class = shift;
    my $db_name = $class->database->{db_name};
    my $db_host = $class->database->{db_host};
    my $db_port = $class->database->{db_port};
    my $dsn = "dbi:Pg:dbname=$db_name;host=$db_host;port=$db_port";
    return $dsn;
}

1;
