package EmpireLogistics::Schema::Result::NlrbDecision;



use Moose;
use MooseX::MarkAsMethods autoclean => 1;

extends 'EmpireLogistics::Schema::Result';

__PACKAGE__->table("nlrb_decision");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "nlrb_decision_id_seq",
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
  "citation_number",
  { data_type => "text", is_nullable => 0 },
  "case_number",
  { data_type => "text", is_nullable => 0 },
  "issuance_date",
  { data_type => "date", is_nullable => 0 },
  "url",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "company_nlrb_decisions",
  "EmpireLogistics::Schema::Result::CompanyNlrbDecision",
  { "foreign.nlrb_decision" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "labor_organization_nlrb_decisions",
  "EmpireLogistics::Schema::Result::LaborOrganizationNlrbDecision",
  { "foreign.nlrb_decision" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);
__PACKAGE__->has_many(
  "work_stoppage_nlrb_decisions",
  "EmpireLogistics::Schema::Result::WorkStoppageNlrbDecision",
  { "foreign.nlrb_decision" => "self.id" },
  {
	where => { "me.delete_time" => undef },
	cascade_copy => 0, cascade_delete => 0
  },
);

__PACKAGE__->many_to_many(
"companies", "company_nlrb_decisions", "company"
);
__PACKAGE__->many_to_many(
"labor_organizations", "labor_organization_nlrb_decisions", "labor_organization"
);
__PACKAGE__->many_to_many(
    'work_stoppages' => 'work_stoppage_nlrb_decisions', 'work_stoppage',
    {where => {'me.delete_time' => undef}},
);


__PACKAGE__->belongs_to(
    "object_type" =>
    "EmpireLogistics::Schema::Result::ObjectType",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.name " => { -ident => "$args->{self_resultsource}.name" },
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.name" => $args->{self_resultsource}->name,
            },
        );
    },
);

__PACKAGE__->has_many(
    edits => "EmpireLogistics::Schema::Result::EditHistory",
    sub {
        my $args = shift;
        return (
            {
                "$args->{foreign_alias}.object" => { -ident => "$args->{self_alias}.id" },
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
            $args->{self_rowobj} && {
                "$args->{foreign_alias}.object" => $args->{self_rowobj}->id,
                "$args->{foreign_alias}.object_type" => $args->{self_rowobj}->object_type->id,
            },
        );
    },
    { order_by => { -desc => "create_time" } },
);

__PACKAGE__->meta->make_immutable;
1;
