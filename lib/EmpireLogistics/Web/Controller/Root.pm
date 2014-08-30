package EmpireLogistics::Web::Controller::Root;

use Moose;
use EmpireLogistics::Config;
use JSON::XS;
use List::AllUtils qw/any zip/;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config( namespace => '' );

sub auto : Private {
    my ( $self, $c ) = @_;
    $c->stash(use_wrapper => 1)
        unless $c->req->is_xhr and not $c->req->param('wrapper');
    $c->stash->{is_production} = 1 if EmpireLogistics::Config->is_production;
    $c->stash->{google_analytics_id} = EmpireLogistics::Config->google_analytics_id;
    my $locale = $c->req->param('locale');
    $c->response->headers->push_header( 'Vary' => 'Accept-Language' );
    $c->language( $locale ? [$locale] : undef );
    if (any {/dir-item/} keys %{$c->req->params}) {
        $c->detach('default');
    }
    $c->forward('check_authentication');
}

sub index : Path : Args(0) GET {
    my ( $self, $c ) = @_;
    $c->stash->{tiles_url} = $EmpireLogistics::Config::tiles_url;
}

sub post_update_map_location :Chained('/') PathPart('update_map_location') Args(0) POST {
    my ($self,$c) = @_;
    return unless $c->req->is_xhr;
    $c->stash->{current_view} = 'JSON';
    my $hash = $c->req->param('hash');
    $c->user_session->{hash_location} = $hash;
    return 1;
}

sub default : Chained('/') PathPart('404') Args() {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'error_404.tt';
    $c->response->status(404);
}

sub history :Chained('/') PathPart('our-history') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'our-history.tt';
}

sub contributors :Chained('/') PathPart('contributors') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'contributors.tt';
}

sub reference_materials :Chained('/') PathPart('reference-materials') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'reference-materials.tt';
}

sub howto :Chained('/') PathPart('how-to') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'how-to.tt';
}

sub glossary :Chained('/') PathPart('glossary') Args(0) GET {
    my ($self,$c) = @_;
    $c->stash->{template} = 'glossary.tt';
}

sub access_denied : Private {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'error_401.tt';
    $c->response->status(401);
}

sub check_authentication :Private {
    my ($self,$c) = @_;
    # Try to login the user via the login cookie
    my $login_cookie = $c->request->cookie('login');
    if ($login_cookie && !$c->user_exists) {
        my $id =
            EmpireLogistics::Schema::Result::User->id_from_login_cookie($login_cookie->value);
        $c->authenticate({ id => $id }, 'no_password')
            if ($id);
    }
    return 1;
}

sub dc_colors :Chained('/') PathPart('js/dc-colors') Args {
    my ($self,$c) = @_;
    $c->stash->{current_view} = "Plain";
    $c->response->content_type('application/x-javascript');
    my @colors = (
        '#1f77b4',
        '#aec7e8',
        '#ff7f0e',
        '#ffbb78',
        '#2ca02c',
        '#98df8a',
        '#d62728',
        '#ff9896',
        '#9467bd',
        '#c5b0d5',
        '#8c564b',
        '#c49c94',
        '#e377c2',
        '#f7b6d2',
        '#7f7f7f',
        '#c7c7c7',
        '#bcbd22',
        '#dbdb8d',
        '#17becf',
        '#9edae5',
    );
    my @dc_owners = map {
        join(" ", map { ucfirst(lc) } split(/[\s.,-]+/))
    } $c->model('DB::WarehouseOwner')->active->get_column('name')->all;
    my @used_colors = @colors[0 .. $#dc_owners];
    my %color_for_dc_owner = zip @dc_owners, @used_colors;
    my $json = JSON::XS->new->utf8->pretty(1)->convert_blessed(1)->allow_nonref(1)->encode(\%color_for_dc_owner);
    my $js_text   = <<"EOM";
var dcColors = $json;
EOM
    $c->res->body($js_text);
    return 1;
}

sub render : ActionClass('RenderView') { }

sub end : Private {
    my ( $self, $c ) = @_;
    if ( scalar( @{ $c->error } ) and not $c->debug ) {
        $c->stash->{errors} = $c->error;
        $c->log->error($_) for ( @{ $c->error } );
        $c->response->status(500);
        $c->stash->{template} = 'error_500.tt';
        $c->clear_errors;
    }
    $c->forward('/render') or return;
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
