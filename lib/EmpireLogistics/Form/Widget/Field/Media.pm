package EmpireLogistics::Form::Widget::Field::Media;

use Moose::Role;
with 'HTML::FormHandler::Widget::Field::Compound';


sub render_element {
    my ( $self, $result ) = @_;
    $result ||= $self->result;

    my $output = '';
    $output .= qq{<div class="form-group">};
    $output .= qq{<div class="row">};
    $output .= qq{<div class="media-image col-lg-4">};
    if (my $media = $self->item) {
        $output .=
            qq|\n<img src="${\$media->file_url}" height="200" width="300" />\n|;
    }

    $output .= $self->render_subfield($result, $self->field('rm_element'));
    $output .= qq{</div>}; # media-image
    $output .= qq{<div class="media-info col-lg-8">};
    foreach my $subfield ( grep { !($_->name eq 'rm_element') } $self->sorted_fields ) {
        $output .= $self->render_subfield( $result, $subfield );
    }
    $output .= qq{</div>}; # media-info
    $output .= qq{</div>}; # row
    $output .= qq{</div>}; # form-group
    $output =~ s/^\n//; # remove newlines so they're not duplicated
    return $output;
}

no Moose::Role;

1;
