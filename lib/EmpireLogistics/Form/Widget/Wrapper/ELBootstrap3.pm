package EmpireLogistics::Form::Widget::Wrapper::ELBootstrap3;

use Moose::Role;
use namespace::autoclean;
use HTML::FormHandler::Render::Util ('process_attrs');
use List::AllUtils                  ('any');

with 'HTML::FormHandler::Widget::Wrapper::Bootstrap3' => {
    -alias    => {wrap_checkbox => '_wrap_checkbox',},
    -excludes => ['wrap_checkbox'],
};

sub wrap_checkbox {
    my ($self, $result, $rendered_widget) = @_;

    # use the regular label
    my $label = $self->option_label || $self->label;
    $label = $self->html_filter($self->_localize($label));
    my $id  = $self->id;
    my $for = qq{ for="$id"};

    # return wrapped checkbox, either on left or right
    return
        qq{<div class="checkbox-inline"><label$for>\n$label\n$rendered_widget</label></div>}
        if ($self->get_tag('label_left'));
    return
        qq{<div class="checkbox-inline"><label$for>$rendered_widget\n$label\n</label></div>};
}

1;
