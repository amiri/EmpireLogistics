package EmpireLogistics::Web::Controller::Admin::BulkImport;

use Moose;
use MooseX::MethodAttributes;
use EmpireLogistics::Config;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' };


__PACKAGE__->meta->make_immutable;

1;
