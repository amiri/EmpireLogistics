package EmpireLogistics::Web::Model::AES;

use Moose;
use Crypt::CBC;
use Crypt::OpenSSL::AES;

extends 'Catalyst::Model';

has 'cbc' => (
    is      => 'ro',
    isa     => 'Crypt::CBC',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return Crypt::CBC->new(
            -key    => $self->key,
            -cipher => 'Crypt::OpenSSL::AES',
            -salt   => $self->salt,
        );
    },
);

has 'key' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'class warfare',
);

has 'salt' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'karlmarx',
);

sub encrypt {
    my ( $self, $to_be_encypted ) = @_;
    return $self->cbc->encrypt_hex($to_be_encypted);
}

sub decrypt {
    my ( $self, $to_be_decrypted ) = @_;
    return $self->cbc->decrypt_hex($to_be_decrypted);
}

__PACKAGE__->meta->make_immutable;

1;
