package EmpireLogistics::Form::BaseDB;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Model::DBIC';

has '+field_name_space' => ( default => 'EmpireLogistics::Form::Field');
has '+widget_name_space' => ( default => 'EmpireLogistic::Form::Widget');
has '+widget_wrapper' => ( default => 'Bootstrap' );
has '+is_html5' => (default => 1);
has '+http_method' => (default => 'post');

__PACKAGE__->meta->make_immutable;

1;
