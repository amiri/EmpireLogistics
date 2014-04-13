package EmpireLogistics::Role::Form::EditHistory;

use Moose::Role;
requires 'user_id';

has 'is_create' => ( is => 'rw' );

before 'update_model' => sub {
    my $self = shift;
    if ( !$self->item || ( $self->item && !$self->item->in_storage ) ) {
        $self->is_create(1);
    }
};

sub save_edit_history {
    my $self = shift;

    return if $self->is_create;
    my @edit_history_fields = ();
    foreach my $field ( $self->sorted_fields ) {
        next if $field->type_attr eq 'submit';

        # Skip nonexistent submission fields
        next if not exists $self->values->{ $field->name };
        if ( $field->value_changed ) {
            my $value      = $field->value;
            my $init_value = $field->init_value;
            if ( $field->html_element eq 'select' ) {
                $value      = $field->as_label;
                $init_value = $field->as_label($init_value);
            }
            # Don't store any password text anywhere
            if ($field->name eq 'password') {
                $value =~ s/^(.*)/'*' x length($value)/e;
                $init_value =~ s/^(.*)/'*' x length($value)/e;
            }
            push @edit_history_fields,
                {
                field          => $field->accessor,
                original_value => $init_value,
                new_value      => $value,
                };
        }
    }
    $self->item->edit_history_save( $self->user_id, \@edit_history_fields, );
}

sub get_edit_history {
    my $self = shift;

    my $object = $self->item;

    return undef unless $object;
    my @edits = $object->edits;
    return 1 unless ( scalar @edits );
    my @table_data = ();

    for my $edit (@edits) {
        for my $edit_field ( $edit->edit_history_fields->all ) {
            my $row = {};
            $row->{create_time}
                = $edit->create_time->strftime('%Y-%m-%d %r %z');
            my $accessor = $edit_field->get_column('field');
            my $field_name
                = $self->field($accessor)
                ? $self->field($accessor)->label
                : $accessor;
            $row->{field_name} = $field_name;
            $row->{new_value}  = $edit_field->get_column('new_value');
            if ( $row->{field_name} =~ /password/i ) {
                $row->{new_value}
                    =~ s/^(.*)/'*' x length($row->{new_value})/e;
            }
            $row->{original_value}
                = $edit_field->get_column('original_value');

            if (   $self->field($accessor)
                && $self->field($accessor)->type_attr eq 'checkbox' )
            {
                $row->{new_value}
                    = $row->{new_value} ? 'checked' : 'unchecked';
                $row->{original_value}
                    = $row->{original_value} ? 'checked' : 'unchecked';
            }

            # Make a link to the user page for this agent
            my $user_id = $edit->get_column('user');
            if ($user_id) {
                my $user_name
                    = $edit->admin        ? $edit->admin->nickname
                    : $edit->admin->email ? $edit->admin->email
                    :                       $user_id;
                $row->{user_id}
                    = qq|<a href="/admin/user/$user_id/">$user_name</a>|;
            }
            push( @table_data, $row );
        }
    }
    return \@table_data;
}

1;
