package EmpireLogistics::Web::Controller::Blog;

use Moose;
use MooseX::MethodAttributes;
use Scalar::Util qw/looks_like_number/;
use DateTime;
use DateTime::Format::Pg;
use namespace::autoclean;
extends 'Catalyst::Controller';

has 'dt' => (
    is      => 'ro',
    isa     => 'DateTime::Format::Pg',
    lazy    => 1,
    builder => '_build_dt',
);

sub _build_dt {
    my $self = shift;
    my $dt = DateTime::Format::Pg->new(server_tz => 'America/Los_Angeles');
    return $dt;
}

sub begin :Private {
    my ( $self, $c ) = @_;
    my $wrapper = 'blog/wrapper.tt';
    $c->stash->{wrapper} = $wrapper;
}

sub base : Chained('/') PathPart('blog') CaptureArgs(0) GET {
    my ($self, $c) = @_;
}

sub all : Chained('base') PathPart('') Args(0) GET {
    my ($self, $c) = @_;
    my @blogs = $c->model('DB::Blog')->active->all;
    $c->stash(
        blogs => \@blogs,
    );
}

sub capture_single :Chained(base) PathPart('') Args(1) GET {
    my ($self,$c,$arg) = @_;
    if (looks_like_number($arg)) {
        $c->forward('year') or return;
    } else {
        $c->forward('single_title') or return;
    }
}

sub year : Private {
    my ($self, $c, $year) = @_;
    $c->error("Year is not a number") unless looks_like_number($year);
    my $start = DateTime->new(
        year  => $year,
        month => 1,
        day   => 1,
    );
    my $start_dt = $self->dt->format_datetime($start);
    my $end      = DateTime->new(
        year  => $year + 1,
        month => 1,
        day   => 1,
    );
    my $end_dt = $self->dt->format_datetime($end);
    my @blogs  = $c->model('DB::Blog')->active->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
        }
    );
    $c->stash(
        blogs    => \@blogs,
        template => 'blog/year.tt',
    );
    return 1;
}

sub month : Chained('base') PathPart('') Args(2) GET {
    my ($self, $c, $year, $month) = @_;
    $c->error("Year is not a number")  unless looks_like_number($year);
    $c->error("Month is not a number") unless looks_like_number($month);
    my $start = DateTime->new(
        year  => $year,
        month => $month,
        day   => 1,
    );
    my $start_dt = $self->dt->format_datetime($start);
    my $end      = DateTime->new(
        year  => $year,
        month => $month + 1,
        day   => 1,
    );
    my $end_dt = $self->dt->format_datetime($end);
    my @blogs  = $c->model('DB::Blog')->active->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
        }
    );
    $c->stash(
        blogs => \@blogs,
    );
}

sub day : Chained('base') PathPart('') Args(3) GET {
    my ($self, $c, $year, $month, $day) = @_;
    $c->error("Year is not a number")  unless looks_like_number($year);
    $c->error("Month is not a number") unless looks_like_number($month);
    $c->error("Day is not a number")   unless looks_like_number($day);
    my $start = DateTime->new(
        year  => $year,
        month => $month,
        day   => $day,
    );
    my $start_dt = $self->dt->format_datetime($start);
    my $end      = DateTime->new(
        year  => $year,
        month => $month,
        day   => $day + 1,
    );
    my $end_dt = $self->dt->format_datetime($end);
    my @blogs  = $c->model('DB::Blog')->active->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
        }
    );
    $c->stash(
        blogs => \@blogs,
    );
}

sub single : Chained('base') PathPart('') Args(4) GET {
    my ($self, $c, $year, $month, $day, $title) = @_;
    $c->error("Year is not a number")  unless looks_like_number($year);
    $c->error("Month is not a number") unless looks_like_number($month);
    $c->error("Day is not a number")   unless looks_like_number($day);
    my $start = DateTime->new(
        year  => $year,
        month => $month,
        day   => $day,
    );
    my $start_dt = $self->dt->format_datetime($start);
    my $end      = DateTime->new(
        year  => $year,
        month => $month,
        day   => $day + 1,
    );
    my $end_dt = $self->dt->format_datetime($end);
    my $blog   = $c->model('DB::Blog')->active->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
            url_title   => $title,
        }, {
            rows => 1,
        }
    )->single;
    $c->stash(
        blog => $blog,
    );
}

sub single_title : Private {
    my ($self, $c, $title) = @_;
    my $blog = $c->model('DB::Blog')->active->search(
        {
            url_title => $title,
        }, {
            rows => 1,
        }
    )->single;
    $c->stash(
        blog     => $blog,
        template => 'blog/single.tt',
    );
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
