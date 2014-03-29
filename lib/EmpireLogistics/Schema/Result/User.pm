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
      encode_enable => 1,
      encode_column => 1,
      encode_class  => "Digest",
      encode_args =>
          { algorithm => "PBKDF2", format => "binary", salt_length => 10, },
      encode_check_method => "check_password",
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");




__PACKAGE__->meta->make_immutable;
1;
