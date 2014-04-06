package EmpireLogistics::Role::Controller::CRUD;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

has 'form' => (
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

has 'namespace' => (
    is => 'ro',
    isa => 'Str',
    default => 'Admin::',
);

sub base : Chained('') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $self->model( $c->model( $self->model_name ) );
    my $schema = $c->model('DB')->schema;
    $c->stash(
        item_rs => $self->model,
        schema  => $schema,
        form    => $self->form->new(schema => $schema),
    );
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->stash( object => $self->model->find($id) );
}

sub get_index : Chained('base') PathPart('') Args(0) GET {
    my ( $self, $c ) = @_;
    my $page = $c->req->param('page') // 1;
    $page = 1 if ( $page !~ /^\d+$/ );
    my $rs = $self->model;
    my $items = [ $rs->all ];

    my $columns = [ $self->model->result_source->columns ];
    $c->stash(
        items     => $items,
        columns   => $columns,
        template  => 'admin/list.tt',
        item_name => $self->item_name,
    );
}

sub create_for : Chained('base') PathPart('create_for') Args(1) {
    my ( $self, $c, $id ) = @_;
    $c->log->debug( 'I got an arg for create_for: ', $id );
    my $new_object = $self->model->new_result( {} );
    $c->stash(
        template => "admin/create_update.tt",
        creation => 1,
        for      => $id,
    );
    return $self->form_create( $c, $new_object );
}

sub create : Chained('base') PathPart('create') Args(0) {
    my ( $self, $c ) = @_;
    my $new_object = $self->model->new_result( {} );
    my $template = "create_update.tt";
    if ( $c->req->is_xhr && lc $c->req->method eq 'get' ) {
        $template = 'multi_create.tt';
    }

    $c->stash( creation => 1, template => "admin/$template", );
    return $self->form_create( $c, $new_object, $template );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    my $form   = $c->stash->{form};
    my $action = $c->uri_for(
        $c->controller( $self->namespace . $self->class )
            ->action_for('edit'),
        [ $c->stash->{object}->id ]
    );

    $c->stash(
        template => "admin/create_update.tt",
        creation => 0,
    );
    if ( lc $c->req->method eq 'post' ) {
        $c->req->params->{'file'} = $c->req->upload('file');

        return
            unless $form->process(
            item   => $c->stash->{object},
            schema => $c->stash->{schema},
            params => $c->req->params,
            action => $action,
            );
        $c->flash( status_msg => $self->class . ' edited' );

        # Redirect the user back to the list page
        #$c->res->redirect( $c->uri_for( $self->action_for('list') ) );
        return $c->res->redirect(
            $c->uri_for(
                $c->controller( $self->namespace . $self->class )
                    ->action_for('display'),
                $c->stash->{object}->id
            )
        );
    }
    else {
        $form->process( item => $c->stash->{object}, );
        $c->stash(
            form      => $form,
            template  => "admin/create_update.tt",
            item      => $c->stash->{object},
            item_name => $self->item_name,
            creation  => undef,
            action    => $action,
        );
    }
}

sub delete : Chained('object') PathPart('delete') Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{object}->delete;
    $c->flash( status_msg => $self->class . ' deleted' );
    $c->res->redirect( $c->uri_for( $self->action_for('list') ) );
}

sub form_create {
    my ( $self, $c, $stashed_object, $template, $form_number ) = @_;
    my $creation = $c->stash->{creation};
    my $form;
    if ( $c->stash->{for} ) {
        $c->log->debug("I have for and am making a new form");
        $form = $self->form->new(
            init_object => { green => $c->stash->{for} } );
        my $action
            = $c->uri_for(
            $c->controller( $self->namespace . $self->class )
                ->action_for('create') );
        $c->stash(
            template  => "admin/create_update.tt",
            form      => $form,
            item_name => $self->item_name,
            creation  => $creation,
            action    => $action,
        );

        if ( lc $c->req->method eq 'post' ) {
            $c->req->params->{'file'} = $c->req->upload('file');
        }

        $form->process(
            schema => $c->stash->{schema},
            params => $c->req->params,
        );
        $c->stash( fillinform => $form->fif );
        return unless $form->validated;
        $c->flash( status_msg => $self->class . ' created' );
    }
    else {
        $c->log->debug("I do not have for and am not making a new form");
        $form = $c->stash->{form};
        my $action
            = $c->uri_for(
            $c->controller( $self->namespace . $self->class )
                ->action_for('create') );
        $c->stash(
            template  => "admin/$template",
            form      => $form,
            item_name => $self->item_name,
            creation  => $creation,
            action    => $action,
        );
        if ( lc $c->req->method eq 'post' ) {
            $c->req->params->{'file'} = $c->req->upload('file');
        }

        $form->process(
            item   => $stashed_object,
            schema => $c->stash->{schema},
            params => $c->req->params,
        );
        $c->stash( fillinform => $form->fif );
        return unless $form->validated;

        my ( $success_msg, $error_msg )
            = $self->process_multi_creates( $c, $stashed_object );

        $c->flash( status_msg => $self->class . ' created' );
    }

    $c->res->redirect( $c->uri_for( $self->action_for('list') ) );
}

sub view : Chained('object') PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(
        object   => $c->stash->{object},
        template => "admin/display.tt",
    );
}

1;