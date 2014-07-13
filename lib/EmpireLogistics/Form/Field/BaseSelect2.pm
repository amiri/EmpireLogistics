package EmpireLogistics::Form::Field::BaseSelect2;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Field::Text';

has '+deflate_method' => ( default => sub { \&textcsv_deflate } );
has '+inflate_method' => ( default => sub { \&textcsv_inflate } );
has 'multiple' => ( isa => 'Bool', is => 'rw', default => '1' );

sub build_value_when_empty { [] }

sub _inner_validate_field {
    my $self = shift;
    my $value = $self->value;
    return unless $value;
    if ( ref $value ne 'ARRAY' ) {
        $value = [$value];
        $self->_set_value($value);
    }
}
sub textcsv_deflate {
    my ( $self, $value ) = @_;
    if( defined $value && length $value ) {
        my $value = ref $value eq 'ARRAY' ? $value : [$value];
        my $new_value = join(',', @$value);
        return $new_value;
    }
    return $value;
}

sub textcsv_inflate {
    my ( $self, $value ) = @_;
    if ( defined $value && length $value ) {
        my @values = split(/,/, $value);
        return \@values;
    }
    return $value;
}

__PACKAGE__->meta->make_immutable;

1;

