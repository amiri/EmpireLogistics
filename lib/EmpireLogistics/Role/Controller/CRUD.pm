package EmpireLogistics::Role::Controller::CRUD;

use MooseX::MethodAttributes::Role;
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

has 'model' => ( is => 'rw', );

has 'model_name' => (
    is       => 'ro',
    required => 1,
);

has 'item_name' => (
    is       => 'ro',
    required => 1,
);

sub base : Chained('') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $self->model( $c->model( $self->model_name ) );
    my $schema = $c->model('DB')->schema;
    $c->stash(
        item_rs => $self->model,
        schema  => $schema,
        form =>
            $self->form->new( schema => $schema, user_id => $c->user->id, ),
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
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $self->model->find($id) );
}

sub get_index : Chained('base') PathPart('') Args(0) GET {
    my ( $self, $c ) = @_;
    my $page = $c->req->param('page') // 1;
    my $rows = $c->req->param('rows') // 10;
    $page = 1 if ( $page !~ /^\d+$/ );
    my $rs = $self->model;
    my $items = [ $rs->search( {}, { page => $page, rows => $rows, } ) ];

    my $columns = [ $self->model->result_source->columns ];
    $c->stash(
        items     => $items,
        columns   => $columns,
        template  => 'admin/list.tt',
        item_name => $self->item_name,
        (($rs->count) > 100 ? (large_dataset => 1) : ()),
    );
}

sub post_index : Chained('base') PathPart('') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $rows        = $c->req->param('iDisplayLength') // 10;
    my $start_index = $c->req->param('iDisplayStart')  // 0;
    my $page             = $start_index == 0 ? 1 : $start_index / $rows + 1;
    my $sort_column      = $c->req->param('iSortCol_0');
    my $sort_column_name = $c->req->param('mDataProp_' . $sort_column);
    my $sort_order       = $c->req->param('sSortDir_0');
    my %order_by     = (order_by => {"-$sort_order" => [$sort_column_name]});
    my $search_attr  = {};
    my $search_text = $c->req->param('sSearch');
    my ($search_param) =
        map { $c->req->param('mDataProp_' . $_) }
        map {/\w+(\d+)/; $1}
        grep {$c->req->param($_) eq 'true'}
        grep {/bSearchable/} keys %{$c->req->body_params};
    $search_attr->{$search_param} = {-ilike => qq|%$search_text%|}
        if $search_param && $search_text;
    my $rs = $self->model;
    my $items = $rs->search( $search_attr, {
        page => $page,
        rows => $rows,
        %order_by
    });

    my $columns = [$self->model->result_source->columns];
    $c->stash(
        json_data => {
            aaData => [
                map {
                    $_->edit_url(
                        $c->uri_for(
                            $c->controller($self->namespace . $self->class)
                            ->action_for('edit'), [$_->id])
                    );
                    $_
                } $items->all
            ],
            iTotalRecords        => $rs->count + 0,
            iTotalDisplayRecords => $rs->count + 0,
        }
    );
}

sub column_definitions : Chained('base') PathPart('column-definitions')
    Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $rs      = $self->model;
    my $columns = [
        map {{
            mData => $_,
            sTitle => $rs->labels->{$_},
            bSearchable => (($_ =~ /name/) ? 'true' : 'false'),
        }}
        grep {!/^(password|notes|description)$/}
        grep {!/^id$/}
        grep {
            $rs->result_source->column_info($_)->{data_type} ne 'boolean'
         or $_ eq 'delete_time'
        } $rs->result_source->columns
    ];
    unshift @$columns, {
        sType => 'num-html',
        mData => 'id',
        bSearchable => 'false',
    };
    push @$columns, {
        mData           => 'restore_delete',
        sDefaultContent => '',
        bSearchable => 'false',
        sTitle => 'Actions',
    };
    push @$columns, {
        mData           => 'edit_url',
        bSearchable => 'false',
        bVisible => 'false',
        sTitle => 'Edit URL',
    };
    my $i = 0;
    for my $col (@$columns) {
        $col->{aTargets} = [$i++];
    }
    $c->stash->{json_data} = $columns;
}

sub create : Chained('base') PathPart('create') Args(0) {
    my ( $self, $c ) = @_;
    my $template = "create_update.tt";
    if ( $c->req->is_xhr && lc $c->req->method eq 'get' ) {
        $template = 'multi_create.tt';
    }

    $c->stash( creation => 1, template => "admin/$template", );
    return $self->form_create( $c, $template, );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    my $form   = $c->stash->{form};
    my $action = $c->uri_for(
        $c->controller( $self->namespace . $self->class )->action_for('edit'),
        [ $c->stash->{object}->id ]
    );
    $form->action($action);

    $c->stash(
        template => "admin/create_update.tt",
        creation => 0,
    );
    if ( lc $c->req->method eq 'post' ) {
        $c->req->body_params->{'file'} = $c->req->upload('file');

        $form->process(
            item   => $c->stash->{object},
            schema => $c->stash->{schema},
            params => $c->req->body_params,
            action => $action,
        );
        if ($form->validated) {
            $c->flash->{alert}
                = [
                { class => 'success', message => $self->class . ' updated' }
                ];

            # Redirect the user back to the list page
            $c->res->redirect(
                $c->uri_for(
                    $c->controller( $self->namespace . $self->class )
                        ->action_for('edit'),
                    $c->req->captures
                )
            );
            return 1;
        } else {
            $c->stash->{alert} = [ map {{ class => 'danger', message => $_  }} $form->errors ];
            $c->stash->{form} = $form;
        }
    } else {
        $form->process( item => $c->stash->{object}, );
        $c->stash(
            form        => $form,
            template    => "admin/create_update.tt",
            item        => $c->stash->{object},
            item_name   => $self->item_name,
            creation    => undef,
            table_data  => $form->get_edit_history,
            table_cols  => $c->model('DB::EditHistory')->header_labels,
            object_type => $self->class,
            action => $action,
        );
    }
}

sub delete : Chained('object') PathPart('delete') Args(0) {
    my ( $self, $c ) = @_;
    my $delete_form = $c->stash->{delete_form};
    $delete_form->process(
        item   => $c->stash->{object},
        schema => $c->stash->{schema},
        params => { %{ $c->req->params }, delete_time => 1 },
    );
    $c->stash->{delete_form} = $delete_form;
    if ( $delete_form->validated ) {
        $c->flash->{alert}
            = [
            { class => 'success', message => $self->class . ' deleted' }
            ];
    } else {
        $c->flash->{alert}
            = [
            { class => 'warning', message => $self->class . ' not deleted' }
            ];
    }
    $c->res->redirect(
        $c->uri_for(
            $c->controller( $self->namespace . $self->class )
                ->action_for('get_index')
        )
    );
    return 1;
}

sub capture_relation :Chained('object') PathPart('delete') CaptureArgs(1) {
    my ($self,$c,$relation) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    $c->stash->{relation} = $relation;
}

sub delete_relation :Chained('capture_relation') PathPart('') Args(2) {
    my ($self,$c,$id,$bridged) = @_;
    $c->log->warn("I am going to delete relation");
    $c->log->warn("My id is $id");
    $c->log->warn("My bridged is $bridged");
    if ($id && $bridged) {
        my $relation = $c->stash->{relation};
        my $object = $c->stash->{object};
        $object->$relation->find({ $bridged => $id })->delete;
    }
    $c->stash->{json_data} = { success => 1 };
}

sub restore : Chained('object') PathPart('restore') Args(0) {
    my ( $self, $c ) = @_;
    my $restore_form = $c->stash->{restore_form};
    $restore_form->process(
        item   => $c->stash->{object},
        schema => $c->stash->{schema},
        params => { %{ $c->req->params }, restore_time => 1 },
    );
    $c->stash->{restore_form} = $restore_form;
    if ( $restore_form->validated ) {
        $c->flash->{alert}
            = [
            { class => 'success', message => $self->class . ' restored' }
            ];
    } else {
        $c->flash->{alert}
            = [
            { class => 'warning', message => $self->class . ' not restored' }
            ];
    }
    $c->res->redirect( $c->uri_for( $self->action_for('get_index') ) );
    return 1;
}

sub form_create {
    my ( $self, $c, $template, $form_number ) = @_;
    my $creation = $c->stash->{creation};
    my $form;
    $c->log->debug("I do not have for and am not making a new form");
    $form = $c->stash->{form};
    my $action
        = $c->uri_for( $c->controller( $self->namespace . $self->class )
            ->action_for('create') );
    $form->action($action);
    $c->stash(
        template  => "admin/$template",
        form      => $form,
        item_name => $self->item_name,
        creation  => $creation,
        action => $action,
    );
    if ( lc $c->req->method eq 'post' ) {
        $c->req->body_params->{'file'} = $c->req->upload('file');
    }

    $form->process(
        schema => $c->stash->{schema},
        params => $c->req->body_params,
    );
    $c->stash( fillinform => $form->fif );
    return unless $form->validated;

    $c->flash->{alert}
        = [ { class => 'success', message => $self->class . ' created' } ];

    $c->res->redirect(
        $c->uri_for(
            $c->controller( $self->namespace . $self->class )
                ->action_for('get_index')
        )
    );
}

sub view : Chained('object') PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(
        object   => $c->stash->{object},
        template => "admin/display.tt",
    );
}

1;
