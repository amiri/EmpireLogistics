package EmpireLogistics::Form::Admin::NlrbDecision;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'PrintableAndNewline' );
use MooseX::Types::URI qw/Uri/;
use namespace::autoclean;
extends 'EmpireLogistics::Form::BaseDB';
with 'EmpireLogistics::Role::Form::Util';

has '+name'       => ( default => 'nlrb-decision-form' );
has '+item_class' => ( default => 'NlrbDecision' );
has 'js_files'    => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        [ '/js/admin/nlrb-decision.js', ];
    },
);

sub build_render_list {
    return [ 'metadata_block', 'basic_block', 'relations_block', 'submit', ];
}
has_block 'metadata_block' => (
    tag         => 'fieldset',
    label       => 'Metadata',
    render_list => [ 'id', 'create_time', 'update_time', 'delete_time', ],
);

has_block 'basic_block' => (
    tag         => 'fieldset',
    label       => 'Basic Information',
    render_list => [ 'case_number', 'citation_number', 'issuance_date', 'url', ],
);

has_block 'relations_block' => (
    tag         => 'fieldset',
    label       => 'Relationships',
    render_list => [ 'companies', 'labor_organizations', 'work_stoppages',],
);

has_field 'id' => (
    type     => 'Integer',
    disabled => 1,
    readonly => 1,
    label    => 'Citation ID',
);
has_field 'create_time' => (
    type            => 'Timestamp',
    label           => 'Create time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'update_time' => (
    type            => 'Timestamp',
    label           => 'Update time',
    format          => "%Y-%m-%d %r %z",
    readonly        => 1,
    html5_type_attr => 'datetime',
    disabled        => 1,
);
has_field 'delete_time' => (
    type           => 'Checkbox',
    label          => 'Deleted',
    deflate_method => \&deflate_delete_time,
);
has_field 'case_number' => (
    type            => 'Text',
    label           => 'Case Number',
    required        => 1,
);
has_field 'citation_number' => (
    type     => 'Text',
    label    => 'Citation Number',
    required => 1,
);
has_field 'url' => (
    type            => 'Text',
    label           => 'URL',
    html5_type_attr => 'url',
    required        => 1,
    apply           => [Uri],
);
has_field 'issuance_date' => (
    type            => 'Date',
    label           => 'Issuance Date',
    html5_type_attr => 'date',
    required        => 1,
);

has_field "companies"           => ( type => '+Company', );
has_field "labor_organizations" => ( type => '+LaborOrganization', );
# Work Stoppages
has_field 'work_stoppages' => (
    type => '+WorkStoppage',
);

has_field 'submit' => (
    type          => 'Submit',
    widget        => 'ButtonTag',
    value         => 'Save',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;

1;

