package EmpireLogistics::Web::Controller::Blog;

use Moose;
use MooseX::MethodAttributes;
use Scalar::Util qw/looks_like_number/;
use DateTime;
use DateTime::Format::Pg;
use namespace::autoclean;
use Data::Printer;
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
    my $blog_rs = $c->model('DB::Blog')->active;
    my %calendar = ();

    while (my $blog = $blog_rs->next) {
        my $year = $blog->create_time->year;
        my $month = $blog->create_time->month;
        my $day = $blog->create_time->day;
        $calendar{$year}{$month}{$day} = [] unless ref($calendar{$year}{$month}{$day}) eq 'ARRAY';
        push @{$calendar{$year}{$month}{$day}}, $blog;
    }
    my $months = { 
        1  => 'January',
        2  => 'February',
        3  => 'March',
        4  => 'April',
        5  => 'May',
        6  => 'June',
        7  => 'July',
        8  => 'August',
        9  => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December',
    };

    $c->stash(
        blog_rs => $blog_rs,
        months => $months,
        calendar => \%calendar,
    );
}

sub all : Chained('base') PathPart('') Args(0) GET {
    my ($self, $c) = @_;
    my @blogs = $c->stash->{blog_rs}->all;
    my %all_blogs = ();
    for my $blog (@blogs) {
        $all_blogs{$blog->create_time->year}{$blog->create_time->month}{$blog->create_time->day} = [] unless ref($all_blogs{$blog->create_time->year}{$blog->create_time->month}{$blog->create_time->day}) eq 'ARRAY';
        push @{$all_blogs{$blog->create_time->year}{$blog->create_time->month}{$blog->create_time->day}}, $blog;
    }
    $c->stash(
        all_blogs => \%all_blogs,
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
    my @blogs = $c->stash->{blog_rs}->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
        }
    );
    my %blogs_for_year = ();
    for my $blog (@blogs) {
        $blogs_for_year{$blog->create_time->month}{$blog->create_time->day} = [] unless ref($blogs_for_year{$blog->create_time->month}{$blog->create_time->day}) eq 'ARRAY';
        push @{$blogs_for_year{$blog->create_time->month}{$blog->create_time->day}}, $blog;
    }
    $c->stash(
        start => $start,
        blogs_for_year => \%blogs_for_year,
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
    my @blogs = $c->stash->{blog_rs}->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
        }
    );
    my %blogs_for_day = ();
    for my $blog (@blogs) {
        $blogs_for_day{$blog->create_time->day} = [] unless ref($blogs_for_day{$blog->create_time->day}) eq 'ARRAY';
        push @{$blogs_for_day{$blog->create_time->day}}, $blog;
    }
    $c->stash(
        start => $start,
        blogs_for_day => \%blogs_for_day,
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
    my @blogs = $c->stash->{blog_rs}->search(
        {
            create_time => {">=" => $start_dt,},
            create_time => {"<"  => $end_dt,},
        }
    );
    $c->stash(
        blogs => \@blogs,
        start => $start,
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
    my $blog = $c->stash->{blog_rs}->search(
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
        template => 'blog/single.tt',
    );
}

sub single_title : Private {
    my ($self, $c, $title) = @_;
    my $blog = $c->stash->{blog_rs}->search(
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
