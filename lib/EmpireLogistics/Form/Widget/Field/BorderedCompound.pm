package EmpireLogistics::Form::Widget::Field::BorderedCompound;

use Moose::Role;
with 'HTML::FormHandler::Widget::Field::Compound';

sub render_element {
    my ($self, $result) = @_;
    $result ||= $self->result;

    my $output = '';
    $output .= qq{<div class="form-group bordered">};
    foreach my $subfield ($self->sorted_fields) {
        $output .= $self->render_subfield($result, $subfield);
    }
    $output .= qq{</div>};    # form-group bordered
    $output =~ s/^\n//;       # remove newlines so they're not duplicated
    return $output;
}

no Moose::Role;

1;

