package EmpireLogistics::Form::BaseDB;

use HTML::FormHandler::Moose;
use namespace::autoclean;
extends 'HTML::FormHandler::Model::DBIC';

has '+field_name_space'  => (default => 'EmpireLogistics::Form::Field');
has '+widget_name_space' => (default => 'EmpireLogistic::Form::Widget');
has '+widget_wrapper'    => (default => 'Bootstrap3');
has '+is_html5'          => (default => 1);
has '+http_method'       => (default => 'post');
has 'schema'             => (
    is       => 'rw',
    isa      => 'DBIx::Class::Schema',
    required => 1,
);
has 'user_id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

with 'EmpireLogistics::Role::Form::EditHistory';

sub build_form_element_attr { {'accept-charset' => 'utf-8'} }
sub build_form_element_class { ['form-horizontal'] }

sub build_form_tags {
    {
        'layout_classes' => {
            label_class                    => ['col-lg-2'],
            element_wrapper_class          => ['col-lg-10'],
            no_label_element_wrapper_class => ['col-lg-offset-1'],
        },
    };
}

sub render_repeatable_js {
    my $self = shift;
    return '' unless $self->has_for_js;

    my $for_js = $self->for_js;
    my %index;
    my %html;
    my %level;
    foreach my $key (keys %$for_js) {
        $index{$key} = $for_js->{$key}->{index};
        $html{$key}  = $for_js->{$key}->{html};
        $level{$key} = $for_js->{$key}->{level};
    }
    my $encoder   = JSON::Any->new;
    my $index_str = $encoder->encode(\%index);
    my $html_str  = $encoder->encode(\%html);
    my $level_str = $encoder->encode(\%level);
    my $js        = <<EOS;
<script>
\$(document).ready(function() {
  var rep_index = $index_str;
  var rep_html = $html_str;
  var rep_level = $level_str;
  \$('.add_element').click(function() {
    // get the repeatable id
    var data_rep_id = \$(this).attr('data-rep-id');
    // create a regex out of index placeholder
    var level = rep_level[data_rep_id]
    var re = new RegExp('\{index-' + level + '\}',"g");
    // replace the placeholder in the html with the index
    var index = rep_index[data_rep_id];
    var html = rep_html[data_rep_id];
    html = html.replace(re, index);
    // escape dots in element id
    var esc_rep_id = data_rep_id.replace(/[.]/g, '\\\\.');
    // append new element in the 'controls' div of the repeatable
    var rep_controls = \$('#' + esc_rep_id + ' > .controls');
    rep_controls.append(html);
    // increment index of repeatable fields
    index++;
    rep_index[data_rep_id] = index;
  });

  \$(document).on('click', '.rm_element', function() {
    cont = confirm('Remove?');
    if (cont) {
      var id = \$(this).attr('data-rep-elem-id');
      var rel = \$(this).attr('data-rel');
      var bridged = \$(this).attr('data-rel-self');
      var esc_id = id.replace(/[.]/g, '\\\\.');
      var rm_elem = \$('#' + esc_id);
      if (rm_elem[0]) {
        rm_elem = rm_elem[0];
      }
      console.log(esc_id);

      var elem_id = esc_id + "\\\\.id";
      elem_id = elem_id.replace(/[\\\\]/g, '');
      // Could not get this to work with an ID selector, thus the name.
      var elem_id_elem = \$("input[name*='" + elem_id + "']");

      var elem_id_val = elem_id_elem.val();
      var formAction = \$("form.form-horizontal").attr('action');

      console.log(formAction);
      formAction = formAction + '/delete/' + rel + '/' + elem_id_val + '/' + (bridged ? bridged + '/' : '');
      formAction = formAction.replace(/edit\\//g, '');
      console.log(formAction);

      \$.ajax({
          url: formAction,
          dataType: "json",
      }).done(function( data ) {
          if (data.success == 1) {
              \$(rm_elem).remove();
          }
      });
    }
    event.preventDefault();
  });
});
</script>
EOS
    return $js;
}

around 'update_model', sub {
    my ($orig, $self, @args) = @_;

    # Transform delete_time into datetime, if needed
    if (    $self->values->{delete_time}
        and $self->item
        and not $self->item->delete_time) {
        $self->values->{delete_time} = DateTime->now;    # set
    } elsif (!$self->values->{delete_time}
        and $self->item
        and $self->item->delete_time) {
        $self->values->{delete_time} = undef;            # unset
    } else {
        delete $self->values->{delete_time};             # don't touch
    }

    $self->save_edit_history;

    my $return = $self->$orig(@args);

    return $return;
};

__PACKAGE__->meta->make_immutable;

1;
