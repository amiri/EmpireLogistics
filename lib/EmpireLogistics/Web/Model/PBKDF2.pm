package EmpireLogistics::Web::Model::PBKDF2;

use Moose;
use Crypt::PBKDF2;

extends 'Catalyst::Model';

has 'pbkdf2' => (
    is      => 'ro',
    isa     => 'Crypt::PBKDF2',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return Crypt::PBKDF2->new( encoding => 'ldap', salt_len => 16 );
    },
);

sub random_salt {
    my $ret = "";
    for my $n (1 .. 16) {
        $ret .= chr(int rand 256);
    }
    return $ret;
}

sub validate {
    my ( $self, $hash, $pass ) = @_;
    warn "Hash: $hash";
    warn "Pass: $pass";
    return $self->pbkdf2->validate( $hash, $pass );
}

sub encrypt {
    my ( $self, $pass) = @_;
    my $encrypted = $self->pbkdf2->generate( $pass, $self->random_salt );
    warn "Encrypted: $encrypted";
    return $encrypted;
}


__PACKAGE__->meta->make_immutable;

1;
