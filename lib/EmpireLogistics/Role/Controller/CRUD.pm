package EmpireLogistics::Role::Controller::CRUD;

use MooseX::MethodAttributes::Role;
use Data::Printer;
use feature qw/switch/;
use namespace::autoclean;

has 'form' => (
    is       => 'ro',
    required => 1,
);

has 'delete_form' => (
    is       => 'ro',
    required => 1,
);

has 'restore_form' => (
    is       => 'ro',
    required => 1,
);

has 'class' => (
    is       => 'ro',
    required => 1,
);

has 'model' => (is => 'rw',);

has 'model_name' => (
    is       => 'ro',
    required => 1,
);

has 'item_name' => (
    is       => 'ro',
    required => 1,
);

sub base : Chained('') PathPart('') CaptureArgs(0) {
    my ($self, $c) = @_;
    $self->model($c->model($self->model_name));
    my $schema = $c->model('DB')->schema;
    $c->stash(
        item_rs => $self->model,
        schema  => $schema,
        delete_form => $self->delete_form->new(
            item_class => $self->class,
            schema     => $schema,
            user_id    => $c->user->id,
        ),
        restore_form => $self->restore_form->new(
            item_class => $self->class,
            schema     => $schema,
            user_id    => $c->user->id,
        ),
        controller_name => $self->namespace . $self->class,
        class_name      => $self->class,
    );
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->stash(object => $self->model->find({ id => $id}, {key => 'primary'}));
}

sub get_index : Chained('base') PathPart('') Args(0) GET {
    my ($self, $c) = @_;
    my $page = $c->req->param('page') // 1;
    my $rows = $c->req->param('rows') // 10;
    $page = 1 if ($page !~ /^\d+$/);
    my $rs = $self->model;
    my $items = [$rs->search({}, {page => $page, rows => $rows,})];

    my $columns = [$self->model->result_source->columns];
    $c->stash(
        items     => $items,
        columns   => $columns,
        template  => 'admin/list.tt',
        item_name => $self->item_name,
        (($rs->count) > 10 ? (large_dataset => 1) : ()),
    );
}

sub post_index : Chained('base') PathPart('') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $rs                            = $self->model;
    $c->stash->{current_view}         = 'JSON';
    my $rows                          = $c->req->param('iDisplayLength') // 10;
    my $start_index                   = $c->req->param('iDisplayStart')  // 0;
    my $page                          = $start_index == 0 ? 1 : $start_index / $rows + 1;
    my $sort_column                   = $c->req->param('iSortCol_0');
    my $sort_column_name              = $c->req->param('mDataProp_' . $sort_column);
    my $sort_column_type              = $rs->result_source->column_info($sort_column_name)->{data_type};
    $c->log->warn($sort_column_type);
    my $sort_order                    = $c->req->param('sSortDir_0');
    my %order_by                      = ();
    given ($sort_column_type) {
        when ('integer') {
            %order_by = (order_by => {"-$sort_order" => [$sort_column_name]})
        }
        when ('text') {
            %order_by =
                (order_by => \
                    qq|substring($sort_column_name, '^[0-9]+')::int $sort_order, substring($sort_column_name, '[^0-9]*\$') $sort_order|
                )
        }
        default {
            %order_by = (order_by => {"-$sort_order" => [$sort_column_name]})
        }
    }

    my %search_attr   = ();
    my $search_text   = $c->req->param('sSearch');
    my @search_params =
        map  { $c->req->param('mDataProp_' . $_) }
        map  { /\w+_(\d+)/; $1 }
        grep { $c->req->param($_) eq 'true' }
        grep { /bSearchable/ } keys %{$c->req->body_params};
    if (scalar(@search_params > 1)) {
        $search_attr{'-or'} = [
            map {
                my $col_string = $_.'::text ilike ?';
                {
                    \[qq/$col_string/, '%'.$search_text.'%'],
                }
            } @search_params
        ] if $search_text;
    } else {
        $search_attr{$search_params[0]} = {-ilike => qq|%$search_text%|}
            if $search_params[0] && $search_text;
    }
    my $filtered_rs = $rs->search(
        \%search_attr
    );
    my $items = $filtered_rs->search(
        {}, {
            page => $page,
            rows => $rows,
            %order_by
        }
    );

    my $columns = [$self->model->result_source->columns];
    $c->stash(
        json_data => {
            aaData => [
                map {
                    $_->edit_url(
                        $c->uri_for(
                            $c->controller($self->namespace . $self->class)
                                ->action_for('edit'), [$_->id]
                        )
                    );
                    $_
                } $items->all
            ],
            iTotalRecords        => $rs->count + 0,
            iTotalDisplayRecords => $filtered_rs->count + 0,
        }
    );
}

sub column_definitions : Chained('base') PathPart('column-definitions') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $rs      = $self->model;
    my $columns = [
        map {{
                mData       => $_,
                sTitle      => $rs->labels->{$_},
                bSearchable => (
                    (
                        $_ =~ /(
                        name
                        |junction
                        |owner
                        |trackage
                        |subdivision
                        |passenger
                        |military
                        |gauge
                        |grade
                        |status
                        |track_type
                        |line_class
                        |density
                        |number
                        |local
                        |abbreviation
                    )/x
                    ) ? 'true' : 'false'
                ),
        }}
        grep {
            !/^(password|notes|description|geometry)$/
        }
        grep {
            !/^id$/
        }
        grep {
            $rs->result_source->column_info($_)->{data_type} ne 'boolean'
                or $_ eq 'delete_time'
        } $rs->result_source->columns
    ];
    unshift @$columns, {
        sType       => 'num-html',
        mData       => 'id',
        bSearchable => 'false',
    };
    push @$columns, {
        mData           => 'restore_delete',
        sDefaultContent => '',
        bSearchable     => 'false',
        sTitle          => 'Actions',
    };
    push @$columns, {
        mData       => 'edit_url',
        bSearchable => 'false',
        bVisible    => 'false',
        sTitle      => 'Edit URL',
    };
    my $i = 0;
    for my $col (@$columns) {
        $col->{aTargets} = [$i++];
    }
    $c->stash->{json_data} = $columns;
}

sub create : Chained('base') PathPart('create') Args(0) {
    my ($self, $c) = @_;
    my $template = "create_update.tt";

    my $creation = $c->req->param('id') ? 0 : 1;
    if ($c->req->param('id')) {
        my $item = $self->model->find({ id => $c->req->param('id')}, {key => 'primary'});
        $c->stash->{object} = $item;
    }

    $c->stash(creation => $creation, template => "admin/$template",);
    return $self->form_create($c, $template,);
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ($self, $c) = @_;
    my $item = $c->stash->{object};
    my $form = $self->form->new(
        schema => $c->model('DB')->schema,
        user_id => $c->user->id,
        item => $item,
    );
    my $action = $c->uri_for(
        $c->controller($self->namespace . $self->class)->action_for('edit'),
        [$c->stash->{object}->id]
    );
    $form->action($action);
    $form->item($item);

    # Add a "View on map" link
    my $map_url = $item->map_url;

    $c->stash(
        template => "admin/create_update.tt",
        creation => 0,
        map_url => $map_url,
    );
    if (lc $c->req->method eq 'post') {
        my $params = {
            %{ $c->req->body_parameters },
            (   ($c->req->uploads)
                ? ( map { $_ => $c->req->uploads->{$_} }
                        keys %{ $c->req->uploads })
                : ()) };

        $form->process(
            item   => $c->stash->{object},
            schema => $c->stash->{schema},
            params => $params,
            action => $action,
        );
        if ($form->validated) {
            $c->flash->{alert} =
                [{class => 'success', message => $self->class . ' updated'}];

            # Redirect the user back to the list page
            $c->res->redirect(
                $c->uri_for(
                    $c->controller($self->namespace . $self->class)
                        ->action_for('edit'),
                    $c->req->captures
                )
            );
            return 1;
        } else {
            $c->stash->{alert} =
                [map { {class => 'danger', message => $_} } $form->errors];
            $c->stash->{form} = $form;
        }
    } else {
        $form->process(item => $c->stash->{object},);
        $c->stash(
            form        => $form,
            template    => "admin/create_update.tt",
            item        => $c->stash->{object},
            item_name   => $self->item_name,
            creation    => undef,
            table_data  => $form->get_edit_history,
            table_cols  => $c->model('DB::EditHistory')->header_labels,
            object_type => $self->class,
            action      => $action,
        );
    }
}

sub delete : Chained('object') PathPart('delete') Args(0) {
    my ($self, $c) = @_;
    my $delete_form = $c->stash->{delete_form};
    $delete_form->process(
        item   => $c->stash->{object},
        schema => $c->stash->{schema},
        params => {%{$c->req->params}, delete_time => 1},
    );
    $c->stash->{delete_form} = $delete_form;
    if ($delete_form->validated) {
        $c->flash->{alert} =
            [{class => 'success', message => $self->class . ' deleted'}];
    } else {
        $c->flash->{alert} =
            [{class => 'warning', message => $self->class . ' not deleted'}];
    }
    $c->res->redirect(
        $c->uri_for(
            $c->controller($self->namespace . $self->class)
                ->action_for('get_index')
        )
    );
    return 1;
}

sub capture_relation : Chained('object') PathPart('delete') CaptureArgs(1) {
    my ($self, $c, $relation) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    $c->stash->{relation}     = $relation;
}

sub delete_relation : Chained('capture_relation') PathPart('') Args {
    my ($self, $c, $id, $bridged) = @_;
    if ($id and $bridged) {
        my $relation = $c->stash->{relation};
        my $object   = $c->stash->{object};
        $object->$relation->find({$bridged => $id})->delete;
    } elsif ($id and not $bridged) {
        my $relation = $c->stash->{relation};
        my $object   = $c->stash->{object};
        $object->$relation->find({ id => $id}, {key => 'primary'})->delete;
    }
    $c->stash->{json_data} = {success => 1};
}

sub restore : Chained('object') PathPart('restore') Args(0) {
    my ($self, $c) = @_;
    my $restore_form = $c->stash->{restore_form};
    $restore_form->process(
        item   => $c->stash->{object},
        schema => $c->stash->{schema},
        params => {%{$c->req->params}, restore_time => 1},
    );
    $c->stash->{restore_form} = $restore_form;
    if ($restore_form->validated) {
        $c->flash->{alert} =
            [{class => 'success', message => $self->class . ' restored'}];
    } else {
        $c->flash->{alert} =
            [{class => 'warning', message => $self->class . ' not restored'}];
    }
    $c->res->redirect($c->uri_for($self->action_for('get_index')));
    return 1;
}

sub form_create {
    my ($self, $c, $template, $form_number) = @_;
    my $creation = $c->stash->{creation};
    my ($form, $item);
    #$c->log->debug("I do not have for and am not making a new form");
    #$form = $c->stash->{form};
    #$item = $c->stash->{item_rs}->new_result({});
    $form = $self->form->new(
        schema => $c->model('DB')->schema,
        user_id => $c->user->id,
        #item => $item,
    );
    if ($c->stash->{object}) {
        $item = $c->stash->{object};
    }
    my $action = $c->uri_for(
        $c->controller($self->namespace . $self->class)->action_for('create')
    );
    $form->action($action);
    $form->is_create($creation);
    $c->stash(
        template  => "admin/$template",
        form      => $form,
        item_name => $self->item_name,
        creation  => $creation,
        action    => $action,
    );

    my $params = $c->req->body_params;
    if (lc $c->req->method eq 'post') {
        $params = {
            %{ $c->req->body_parameters },
            (   ($c->req->uploads)
                ? ( map { $_ => $c->req->uploads->{$_} }
                        keys %{ $c->req->uploads })
                : ()) };
    }

    $form->process(
        schema => $c->stash->{schema},
        params => $params,
        ($item ? (item => $item) : ()),
    );
    $c->stash(fillinform => $form->fif);
    return unless $form->validated;

    $c->flash->{alert} =
        [{class => 'success', message => $self->class . ' created'}];

    $c->res->redirect(
        $c->uri_for(
            $c->controller($self->namespace . $self->class)
                ->action_for('get_index')
        )
    );
}

sub view : Chained('object') PathPart('') : Args(0) {
    my ($self, $c) = @_;
    $c->stash(
        object   => $c->stash->{object},
        template => "admin/display.tt",
    );
}

sub add_item_media :Chained('object') PathPart('edit/add-item-media') Args(0) {
    my ($self,$c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    $c->forward('add_media');
    return 1;
}

sub add_media : Chained('base') : PathPart('add-media') Args(0) {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $file = $c->req->param('file');
    $c->forward('add_or_update_media', [{file => $file}]);
    my $media = $c->stash->{media};
    $c->error("Could not create or retrieve media") unless ($media);
    $c->stash->{object}->add_to_media($media) if ($media and $c->stash->{object});
    $c->stash->{json_data} = $media;
}

=head2 add_or_update_media

Here we take a Data URI string, decode it to a binary string,
and call EmpireLogistics::Schema::ResultSet::Media::
update_or_create_from_raw_data with
our $args as args.

=cut

sub add_or_update_media : Private {
    my ($self, $c, $args) = @_;

    my $file = delete $args->{file};
    if ($file) {
        my @pieces = split(",", $file);
        $file = MIME::Base64::decode_base64($pieces[1]);
    }
    my %media_info = ();
    @media_info{qw/
        id
        caption
        alt
        uuid
        description
        x1
        y1
        x2
        y2
        crop_height
        crop_width
    /} = @{$c->req->params}{qw/
        id
        caption
        alt
        uuid
        description
        data-x1
        data-y1
        data-x2
        data-y2
        data-height
        data-width
    /};

    my ($original_media, $new_media);

    # If we have an ID already, it's an edit, so put the original media into the media_info hash
    if ($media_info{id}) {
        $original_media = $c->model('DB::Media')->find({id => $media_info{id}}, {key => 'primary'});
        $media_info{media} = $original_media if $original_media;
    }

    # If we have a file body param, update or create the media. If we have an original media, it
    # should be updated.
    if ($file) {
        # If we have file and original media, upload the new file and delete
        # any crop data, so the original media is replaced.
        delete @media_info{qw/x1 y1 x2 y2 crop_height crop_width/} if $original_media;
        $new_media = $c->model("DB::Media")
            ->update_or_create_from_raw_data(%media_info, data => $file,);
    # If we have no file, but still an original media, edit the original
    # media with what are presumably crop options.
    } elsif ($original_media) {
        $new_media = $original_media->update_media(%media_info);
    }

    $c->stash->{media} = $new_media;
    return 1;
}

1;
