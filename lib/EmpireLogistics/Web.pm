package EmpireLogistics::Web;

use Moose;
use CatalystX::RoleApplicator;
use EmpireLogistics::Config;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Authentication
    Authorization::Roles
    Authorization::ACL
    RedirectAndDetach
    I18N
    Session
    Session::Store::DBIC
    Session::State::Cookie
    /;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config( %{$EmpireLogistics::Config::catalyst}, );
__PACKAGE__->apply_request_class_roles(
    qw/Catalyst::TraitFor::Request::XMLHttpRequest/
);

__PACKAGE__->setup();

1;
