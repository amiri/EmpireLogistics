package EmpireLogistics::Schema::Result::User;



use Moose;
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
    default_value => "2014-03-28 15:02:07.783246+00",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "timestamp with time zone",
    default_value => "2014-03-28 15:02:07.783246+00",
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


__PACKAGE__->set_primary_key("id");




__PACKAGE__->meta->make_immutable;
1;
