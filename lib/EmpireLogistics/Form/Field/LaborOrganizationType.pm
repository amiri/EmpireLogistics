package EmpireLogistics::Form::Field::LaborOrganizationType;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Field::Select';

sub build_id {'labor-organization-type-field'}
sub build_label {'Labor Organization Type'}
has '+empty_select' => (default => '-- Select One --',);

sub build_options {
    my $self    = shift;
    my $schema = $self->form->schema;
    my $options;
    $options = [
        map {{
            label => $_->name,
            value => $_->id,
        }} $schema->resultset('LaborOrganizationType')->search({})->active->all
    ];
    return $options;
}


__PACKAGE__->meta->make_immutable;

1;

