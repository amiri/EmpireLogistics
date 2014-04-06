package EmpireLogistics::Form::Field::Timestamp;

use Moose;
extends 'HTML::FormHandler::Field::Date';
use DateTime;
use DateTime::Format::Strptime;


has '+html5_type_attr' => ( default => 'datetime' );
has 'format' => ( is => 'rw', isa => 'Str', default => "%Y-%m-%d %r %z" );
has 'locale'     => ( is => 'rw', isa => 'Str' );                                  # TODO
has 'time_zone'  => ( is => 'rw', isa => 'Str' );                                  # TODO
has 'date_start' => ( is => 'rw', isa => 'Str', clearer => 'clear_date_start' );
has 'date_end'   => ( is => 'rw', isa => 'Str', clearer => 'clear_date_end' );
has '+size' => ( default => '10' );
has '+deflate_method' => ( default => sub { \&date_deflate } );

our $class_messages = {
    'date_early' => 'Date is too early',
    'date_late' => 'Date is too late',
};
sub get_class_messages  {
    my $self = shift;
    return {
        %{ $self->next::method },
        %$class_messages,
    }
}

sub date_deflate {
    my ( $self, $value ) = @_;

    # if not a DateTime, assume correctly formatted string and return
    return $value unless blessed $value && $value->isa('DateTime');
    my $format = $self->get_strf_format;
    my $string = $value->strftime($format);
    #my $string = "$value";
    return $string;
}

sub validate {
    my $self = shift;

    my $format = $self->get_strf_format;
    my $strp = DateTime::Format::Strptime->new( pattern => $format );

    my $dt = eval { $strp->parse_datetime( $self->value ) };
    unless ($dt) {
        $self->add_error( $strp->errmsg || $@ );
        return;
    }
    $self->_set_value($dt);
    my $val_strp = DateTime::Format::Strptime->new( pattern => "%Y-%m-%d %r %z" );
    if ( $self->date_start ) {
        my $date_start = $val_strp->parse_datetime( $self->date_start );
        die "date_start: " . $val_strp->errmsg unless $date_start;
        my $cmp = DateTime->compare( $date_start, $dt );
        $self->add_error($self->get_message('date_early')) if $cmp eq 1;
    }
    if ( $self->date_end ) {
        my $date_end = $val_strp->parse_datetime( $self->date_end );
        die "date_end: " . $val_strp->errmsg unless $date_end;
        my $cmp = DateTime->compare( $date_end, $dt );
        $self->add_error($self->get_message('date_late')) if $cmp eq -1;
    }
}

sub get_strf_format {
    my $self = shift;

    # if contains %, then it's a strftime format
    return $self->format if $self->format =~ /\%/;
}

__PACKAGE__->meta->make_immutable;
use namespace::autoclean;
1;

