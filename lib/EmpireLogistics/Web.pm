package EmpireLogistics::Web;

use Moose;
use CatalystX::RoleApplicator;
use EmpireLogistics::Config;
use namespace::autoclean;

use Catalyst::Runtime 5.90;

use Catalyst;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config( %{$EmpireLogistics::Config::catalyst}, );
__PACKAGE__->apply_request_class_roles(
    qw/Catalyst::TraitFor::Request::XMLHttpRequest/);

__PACKAGE__->setup( @{$EmpireLogistics::Config::app_plugins} );

1;
