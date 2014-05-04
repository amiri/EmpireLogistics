package EmpireLogistics::Form::Field::CompanyType;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Field::Select';

sub build_id {'company-type-field'}
sub build_label {'Company Type'}
has '+empty_select' => (default => '-- Select One --',);
has '+required' => (default => 1);

sub build_options {
    my $self    = shift;
    my $schema = $self->form->schema;
    my $options;
    $options = [
        map {{
            label => $_->name,
            value => $_->id,
        }} $schema->resultset('CompanyType')->search({})->active->all
    ];
    return $options;
}


__PACKAGE__->meta->make_immutable;

1;
