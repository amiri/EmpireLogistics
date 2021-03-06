package EmpireLogistics::Form::Widget::Field::Media;

use Moose::Role;
with 'HTML::FormHandler::Widget::Field::Compound';

sub render_element {
    my ($self, $result) = @_;
    $result ||= $self->result;

    my $output = '';
    $output .= qq{<div class="form-group bordered">};
    $output .= qq{<div class="row">};
    $output .= qq{<div class="media-image col-lg-4">};
    my $media = $self->item;
    if ($media) {
        $output .= qq|\n<img src="${\$media->file_url}" />\n|;
    }

    $output .= qq{<div class="top-buffer">};
    $output .= $self->render_subfield($result, $self->field('rm_element'));
    if ($media) {
        $output .=
            qq|<p><a href="${\$media->edit_url}">Crop this media</a></p>|;
    }
    $output .= qq{</div>};    # row, top-buffer for rm_element
    $output .= qq{</div>};    # media-image
    $output .= qq{<div class="media-info col-lg-8">};
    foreach my $subfield (grep { !($_->name eq 'rm_element') } $self->sorted_fields) {
        $output .= $self->render_subfield($result, $subfield);
    }
    $output .= qq{</div>};    # media-info
    $output .= qq{</div>};    # row
    $output .= qq{</div>};    # form-group bordered
    $output =~ s/^\n//;       # remove newlines so they're not duplicated
    return $output;
}

no Moose::Role;

1;
