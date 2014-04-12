package EmpireLogistics::Schema::Result::User;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;

use MooseX::MarkAsMethods autoclean => 1;
extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_id_seq",
  },
  "create_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => \'now()',
    is_nullable   => 0,
  },
  "delete_time",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 0 },
  "nickname",
  { data_type => "text", is_nullable => 0 },
  "password",
  {   data_type     => "text",
      is_nullable   => 0,
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);

__PACKAGE__->filter_column(
    password => {
        filter_to_storage => 'encrypt_password',
    },
);

__PACKAGE__->has_many(
    "user_roles",
    "EmpireLogistics::Schema::Result::UserRole",
    { "foreign.user" => "self.id" },
);

__PACKAGE__->many_to_many(
    "roles" => "user_roles",
    "role"
);

sub encrypt_password {
    my ($self,$raw_pass) = @_;
    my $hash = EmpireLogistics::Web::Model::PBKDF2->new->encrypt($raw_pass);
    return $hash;
}

sub check_password {
    my ($self, $raw_pass) = @_;
    return $self if (EmpireLogistics::Web::Model::PBKDF2->new->validate($self->password, $raw_pass));
}

sub encrypted_login_cookie {
    my $self = shift;
    my $cipher_text =
        EmpireLogistics::Web::Model::AES->new->encrypt($self->id);
    my $login_cookie_value = unpack('H*', $cipher_text);
    return $login_cookie_value;
}

sub id_from_login_cookie {
    my ($class, $login_cookie_value) = @_;
    my $cipher_text = pack('H*', $login_cookie_value);
    return EmpireLogistics::Web::Model::AES->new->decrypt($cipher_text);
}

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::EditHistory",
    sub {
        my $args = shift;
        return +{
            "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
            "$args->{foreign_alias}.object_type" => $args->{self_alias},
        }
    },
);

__PACKAGE__->meta->make_immutable;

1;
