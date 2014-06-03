package EmpireLogistics::Web::Controller::Autocomplete;

use Moose;
use MooseX::MethodAttributes;
use namespace::autoclean;
extends 'Catalyst::Controller';

sub base : Chained('/') PathPart('autocomplete') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{current_view} = 'JSON';
    return 1;
}

sub post_companies : Chained('base') PathPart('companies') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix = lc $c->req->param('q');
    my $company_rs
        = $c->model('DB::Company')
        ->active->search( { name => { -ilike => '%' . $prefix . '%' } },
        { order_by => ['name'] } );
    my @company_options;
    while ( my $company = $company_rs->next ) {
        push @company_options,
            {
            text => $company->name,
            id   => $company->id,
            };
    }
    my $results = {
        results => \@company_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_companies_ids : Chained('base') PathPart('companies-ids') Args(0)
    POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $company = $c->model('DB::Company')->active->find( { id => $id } );
        next unless $company;
        push @options, { id => $id, text => $company->name };
    }
    $c->stash->{json_data} = \@options;
}

sub post_labor_organizations : Chained('base')
    PathPart('labor-organizations') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix = lc $c->req->param('q');
    my $labor_organization_rs
        = $c->model('DB::LaborOrganization')->active->search(
        {   -or => [
                { name         => { -ilike => '%' . $prefix . '%' } },
                { abbreviation => { -ilike => '%' . $prefix . '%' } },
                { local_number => { -ilike => '%' . $prefix . '%' } },

#{'labor_organization_affiliation_parents.labor_organization.name'=> {-ilike => $prefix . '%'}},
            ]
        },
        {   order_by => ['name'],

            #join => 'labor_organization_affiliation_parents',
            #prefetch => 'labor_organization_affiliation_parents',
        }
        );
    my @labor_organization_options;
    while ( my $labor_organization = $labor_organization_rs->next ) {
        push @labor_organization_options,
            {
            text => $labor_organization->full_name,
            id   => $labor_organization->id,
            };
    }
    my $results = {
        results => \@labor_organization_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_labor_organizations_ids : Chained('base')
    PathPart('labor-organizations-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $labor_organization = $c->model('DB::LaborOrganization')
            ->active->find( { id => $id } );
        next unless $labor_organization;
        push @options, { id => $id, text => $labor_organization->full_name };
    }
    $c->stash->{json_data} = \@options;
}

sub post_work_stoppages : Chained('base') PathPart('work-stoppages') Args(0)
    POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix           = lc $c->req->param('q');
    my $work_stoppage_rs = $c->model('DB::WorkStoppage')->active->search(
        {   -or => [
                { name        => { -ilike => '%' . $prefix . '%' } },
                { description => { -ilike => '%' . $prefix . '%' } },
            ],
        },
        { order_by => ['name'] }
    );
    my @work_stoppage_options;
    while ( my $work_stoppage = $work_stoppage_rs->next ) {
        push @work_stoppage_options,
            {
            text => $work_stoppage->name,
            id   => $work_stoppage->id,
            };
    }
    my $results = {
        results => \@work_stoppage_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_work_stoppages_ids : Chained('base') PathPart('work-stoppages-ids')
    Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $work_stoppage
            = $c->model('DB::WorkStoppage')->active->find( { id => $id } );
        next unless $work_stoppage;
        push @options, { id => $id, text => $work_stoppage->name };
    }
    $c->stash->{json_data} = \@options;
}

sub post_ports : Chained('base') PathPart('ports') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix = lc $c->req->param('q');
    my $port_rs
        = $c->model('DB::Port')
        ->active->search( { port_name => { -ilike => '%' . $prefix . '%' } },
        { order_by => ['port_name'] } );
    my @port_options;
    while ( my $port = $port_rs->next ) {
        push @port_options, {
            text => $port->name.', '.$port->country,
            id   => $port->id,
        };
    }
    my $results = {
        results => \@port_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_ports_ids : Chained('base') PathPart('ports-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $port = $c->model('DB::Port')->active->find( { id => $id } );
        next unless $port;
        push @options, {
            id => $id,
            text => $port->name.', '.$port->country,
        };
    }
    $c->stash->{json_data} = \@options;
}

sub post_warehouses : Chained('base') PathPart('warehouses') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix = lc $c->req->param('q');
    my $warehouse_rs
        = $c->model('DB::Warehouse')
        ->active->search({ -or => [
                { "me.name" => { -ilike => '%' . $prefix . '%' } },
                {"owner.name" => { -ilike => '%' . $prefix . '%' } },
            ],
        },
        {
            join => qw/owner/,
            prefetch => qw/owner/,
            order_by => ['me.name'],
        });
    my @warehouse_options;
    while ( my $warehouse = $warehouse_rs->next ) {
        push @warehouse_options, {
            text => $warehouse->name . ' ('.$warehouse->owner->name.')',
            id   => $warehouse->id,
        };
    }
    my $results = {
        results => \@warehouse_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_warehouses_ids : Chained('base') PathPart('warehouses-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $warehouse = $c->model('DB::Warehouse')->active->find( { id => $id } );
        next unless $warehouse;
        push @options, {
            id => $id,
            text => $warehouse->name . ' ('.$warehouse->owner->name.')',
        };
    }
    $c->stash->{json_data} = \@options;
}
sub post_rail_nodes : Chained('base') PathPart('rail-nodes') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix       = lc $c->req->param('q');
    my $rail_node_rs = $c->model('DB::RailNode')->active->search(
        {   -or => [
                { name => { -ilike => '%' . $prefix . '%' } },
                \[q/junction_id::text ilike ?/, '%'.$prefix.'%'],
            ],
        },
        { order_by => ['name'] }
    );
    my @rail_node_options;
    while ( my $rail_node = $rail_node_rs->next ) {
        push @rail_node_options,
            {
            text => $rail_node->name . ' #' . $rail_node->junction_id,
            id   => $rail_node->id,
            };
    }
    my $results = {
        results => \@rail_node_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_rail_nodes_ids : Chained('base') PathPart('rail-nodes-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $rail_node
            = $c->model('DB::RailNode')->active->find( { id => $id } );
        next unless $rail_node;
        push @options,
            {
            id   => $id,
            text => $rail_node->name . ' #' . $rail_node->junction_id
            };
    }
    $c->stash->{json_data} = \@options;
}

sub post_osha_citations : Chained('base') PathPart('osha-citations') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix           = lc $c->req->param('q');
    my $osha_citation_rs = $c->model('DB::OshaCitation')->active->search(
        {   -or => [
                { inspection_number => { -ilike => '%'.$prefix.'%', } },
                { 'url' => { -ilike => '%' . $prefix . '%' } },
            ],
        },
        { order_by => ['issuance_date'] }
    );
    my @osha_citation_options;
    while ( my $osha_citation = $osha_citation_rs->next ) {
        my $text = qq{Inspection No. }.$osha_citation->inspection_number.qq{, Citation #}.$osha_citation->citation_number.qq{ (}.$osha_citation->issuance_date->ymd.qq{)};
        push @osha_citation_options, {
            text => $text,
            id => $osha_citation->id,
        };
    }
    my $results = {
        results => \@osha_citation_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_osha_citations_ids : Chained('base') PathPart('osha-citations-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $osha_citation = $c->model('DB::OshaCitation')->active->find( { id => $id } );
        next unless $osha_citation;
        my $text = qq{Inspection No. }.$osha_citation->inspection_number.qq{, Citation #}.$osha_citation->citation_number.qq{ (}.$osha_citation->issuance_date->ymd.qq{)};
        push @options, {
            text => $text,
            id => $osha_citation->id,
        };
    }
    $c->stash->{json_data} = \@options;
}

sub post_nlrb_decisions : Chained('base') PathPart('nlrb-decisions') Args(0)
    POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix           = lc $c->req->param('q');
    my $nlrb_decision_rs = $c->model('DB::NlrbDecision')->active->search(
        {   -or => [
                { citation_number => { -ilike => '%'.$prefix.'%'} },
                { case_number => { -ilike => '%'.$prefix.'%'} },
                { 'url' => { -ilike => '%' . $prefix . '%' } },
            ],
        },
        { order_by => ['issuance_date'] }
    );
    my @nlrb_decision_options;
    while ( my $nlrb_decision = $nlrb_decision_rs->next ) {
        my $text = qq{Case No. }.$nlrb_decision->case_number.qq{, Citation #}.$nlrb_decision->citation_number.qq{ (}.$nlrb_decision->issuance_date->ymd.qq{)};
        push @nlrb_decision_options, {
            text => $text,
            id => $nlrb_decision->id,
        };
    }
    my $results = {
        results => \@nlrb_decision_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_nlrb_decisions_ids : Chained('base') PathPart('nlrb-decisions-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $nlrb_decision = $c->model('DB::NlrbDecision')->active->find( { id => $id } );
        next unless $nlrb_decision;
        my $text = qq{Case No. }.$nlrb_decision->case_number.qq{, Citation #}.$nlrb_decision->citation_number.qq{ (}.$nlrb_decision->issuance_date->ymd.qq{)};
        push @options, {
            text => $text,
            id => $nlrb_decision->id,
        };
    }
    $c->stash->{json_data} = \@options;
}

sub post_rail_lines : Chained('base') PathPart('rail-lines') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix       = lc $c->req->param('q');
    my $rail_line_rs = $c->model('DB::RailLine')->active->search(
        {   -or => [
                { owner1 => { -ilike => '%' . $prefix . '%' } },
                { subdivision => { -ilike => '%' . $prefix . '%' } },
                { a_junction => { -ilike => '%' . $prefix . '%' } },
                { b_junction => { -ilike => '%' . $prefix . '%' } },
                { route_id => { -ilike => '%' . $prefix . '%' } },
                { link_id => { -ilike => '%' . $prefix . '%' } },
            ],
        },
        { order_by => ['owner1','subdivision','a_junction','b_junction','route_id','link_id',] }
    );
    my @rail_line_options;
    while ( my $rail_line = $rail_line_rs->next ) {
        my $text =
            $rail_line->owner1
            . ( $rail_line->subdivision ? ' Sub. ' . $rail_line->subdivision : '')
            . ', '
            . $rail_line->a_junction . ' to '
            . $rail_line->b_junction
            . ($rail_line->route_id ? ', Rte. ' . $rail_line->route_id : '')
            . ', Link #'
            . $rail_line->link_id;
        push @rail_line_options, {
            text => $text,
            id   => $rail_line->id,
        };
    }
    my $results = {
        results => \@rail_line_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_rail_lines_ids : Chained('base') PathPart('rail-lines-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $rail_line
            = $c->model('DB::RailLine')->active->find( { id => $id } );
        next unless $rail_line;
        my $text =
            $rail_line->owner1
            . ( $rail_line->subdivision ? ' Sub. ' . $rail_line->subdivision : '')
            . ', '
            . $rail_line->a_junction . ' to '
            . $rail_line->b_junction
            . ($rail_line->route_id ? ', Rte. ' . $rail_line->route_id : '')
            . ', Link #'
            . $rail_line->link_id;
        push @options, {
            id   => $id,
            text => $text,
        };
    }
    $c->stash->{json_data} = \@options;
}

sub post_labor_organization_payees : Chained('base')
    PathPart('labor-organization-payees') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $prefix = lc $c->req->param('q');
    my $payee_rs
        = $c->model('DB::LaborOrganizationPayee')->active->search(
        {   -or => [
                { name         => { -ilike => '%' . $prefix . '%' } },
                \[q/usdol_payee_id::text ilike ?/, '%'.$prefix.'%'],
            ]
        },
        {
            order_by => ['name'],
        }
        );
    my @payee_options;
    while ( my $payee = $payee_rs->next ) {
        push @payee_options,
            {
            text => $payee->name.", USDOL #".$payee->usdol_payee_id,
            id   => $payee->id,
            };
    }
    my $results = {
        results => \@payee_options,
        more    => 0,
        context => { id => '123' },
    };
    $c->stash->{json_data} = $results;
}

sub post_labor_organization_payees_ids : Chained('base')
    PathPart('labor-organization-payees-ids') Args(0) POST {
    my ( $self, $c ) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split( ',', $query );
    my @options;
    foreach my $id (@ids) {
        my $payee = $c->model('DB::LaborOrganizationPayee')
            ->active->find( { id => $id } );
        next unless $payee;
        push @options, {
            id => $id,
            text => $payee->name.", USDOL #".$payee->usdol_payee_id,
        };
    }
    $c->stash->{json_data} = \@options;
}

sub post_country : Chained('base') PathPart('country') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $prefix     = lc $c->req->param('q');
    my $country_rs = $c->model('DB::Country')->active->search(
        {
            -or => [
                {name                => {-ilike => '%' . $prefix . '%'}},
                {official_name       => {-ilike => '%' . $prefix . '%'}},
                {official_name_ascii => {-ilike => '%' . $prefix . '%'}},
                {iso_alpha2          => {-ilike => '%' . $prefix . '%'}},
                {iso_alpha3          => {-ilike => '%' . $prefix . '%'}},
                {alternate_names     => {-ilike => '%' . $prefix . '%'}},

      #{'country_affiliation_parents.country.name'=> {-ilike => $prefix . '%'}},
            ]
        }, {
            order_by => ['name', 'official_name', 'official_name_ascii'],
        }
    );
    my @country_options;
    while (my $country = $country_rs->next) {
        push @country_options, {
            text => $country->official_name,
            id   => $country->id,
            };
    }
    my $results = {
        results => \@country_options,
        more    => 0,
        context => {id => '123'},
    };
    $c->stash->{json_data} = $results;
}

sub post_country_ids : Chained('base') PathPart('country-ids') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split(',', $query);
    $c->log->warn("In posr country ids: ", @ids);
    my @options;
    foreach my $id (@ids) {
        $c->log->warn("Looping through ids");
        my $country = $c->model('DB::Country')->active->find({id => $id});
        next unless $country;
        push @options, {id => $id, text => $country->name};
    }
    $c->stash->{json_data} = scalar(@options) == 0 ? {} : scalar(@options) > 1 ? \@options : $options[0];
}

sub post_state : Chained('base') PathPart('state') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $prefix   = lc $c->req->param('q');
    my $state_rs = $c->model('DB::State')->active->search(
        {
            -or => [
                {name            => {-ilike => '%' . $prefix . '%'}},
                {name_ascii      => {-ilike => '%' . $prefix . '%'}},
                {alternate_names => {-ilike => '%' . $prefix . '%'}},

          #{'state_affiliation_parents.state.name'=> {-ilike => $prefix . '%'}},
            ]
        }, {
            order_by => ['name', 'name_ascii'],
        }
    );
    my @state_options;
    while (my $state = $state_rs->next) {
        push @state_options, {
            text => $state->name,
            id   => $state->id,
            };
    }
    my $results = {
        results => \@state_options,
        more    => 0,
        context => {id => '123'},
    };
    $c->stash->{json_data} = $results;
}

sub post_state_ids : Chained('base') PathPart('state-ids') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split(',', $query);
    my @options;
    foreach my $id (@ids) {
        my $state = $c->model('DB::State')->active->find({id => $id});
        next unless $state;
        push @options, {id => $id, text => $state->name};
    }
    $c->stash->{json_data} = scalar(@options) == 0 ? {} : scalar(@options) > 1 ? \@options : $options[0];
}

sub post_city : Chained('base') PathPart('city') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $prefix  = lc $c->req->param('q');
    my $city_rs = $c->model('DB::City')->active->search(
        {
            -or => [
                {name            => {-ilike => '%' . $prefix . '%'}},
                {name_ascii      => {-ilike => '%' . $prefix . '%'}},
                {alternate_names => {-ilike => '%' . $prefix . '%'}},

            #{'city_affiliation_parents.city.name'=> {-ilike => $prefix . '%'}},
            ]
        }, {
            order_by => ['name', 'name_ascii'],
        }
    );
    my @city_options;
    while (my $city = $city_rs->next) {
        push @city_options, {
            text => $city->name,
            id   => $city->id,
            };
    }
    my $results = {
        results => \@city_options,
        more    => 0,
        context => {id => '123'},
    };
    $c->stash->{json_data} = $results;
}

sub post_city_ids : Chained('base') PathPart('city-ids') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split(',', $query);
    my @options;
    foreach my $id (@ids) {
        my $city = $c->model('DB::City')->active->find({id => $id});
        next unless $city;
        push @options, {id => $id, text => $city->name};
    }
    $c->stash->{json_data} = scalar(@options) == 0 ? {} : scalar(@options) > 1 ? \@options : $options[0];
}

sub post_postal_codes : Chained('base') PathPart('postal-code') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $prefix         = lc $c->req->param('q');
    my $postal_code_rs = $c->model('DB::PostalCode')->active->search(
        {
            -or => [
                {postal_code => {-ilike => '%' . $prefix . '%'}},

            #{'city_affiliation_parents.city.name'=> {-ilike => $prefix . '%'}},
            ]
        }, {
            order_by => ['postal_code'],
        }
    );
    my @postal_code_options;
    while (my $postal_code = $postal_code_rs->next) {
        push @postal_code_options, {
            text => $postal_code->postal_code,
            id   => $postal_code->id,
            };
    }
    my $results = {
        results => \@postal_code_options,
        more    => 0,
        context => {id => '123'},
    };
    $c->stash->{json_data} = $results;
}

sub post_postal_code_ids : Chained('base')
    PathPart('postal-code-ids') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $query = $c->req->param('q');
    my @ids = split(',', $query);
    my @options;
    foreach my $id (@ids) {
        my $postal_code =
            $c->model('DB::PostalCode')->active->find({id => $id});
        next unless $postal_code;
        push @options, {id => $id, text => $postal_code->postal_code};
    }
    $c->stash->{json_data} = scalar(@options) == 0 ? {} : scalar(@options) > 1 ? \@options : $options[0];
}

sub state_options : Chained('base') PathPart('state-options') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $country_id = $c->req->param('country');
    return unless $country_id;
    my $state_rs =
        $c->model('DB::State')->search({country => $country_id})->active;
    my @state_options = ();
    while (my $state = $state_rs->next) {
        push @state_options, {
            text => $state->name,
            id   => $state->id,
            };
    }
    $c->stash->{json_data} = \@state_options;
}

sub city_and_postal_options : Chained('base')
    PathPart('city-and-postal-options') Args(0) POST {
    my ($self, $c) = @_;
    return unless $c->req->is_xhr;
    my $state_id = $c->req->param('state');
    return unless $state_id;
    my $city_rs = $c->model('DB::City')->search({state => $state_id})->active;
    my $postal_code_rs =
        $c->model('DB::PostalCode')->search({state => $state_id})->active;
    my @city_options = ();
    while (my $city = $city_rs->next) {
        push @city_options, {
            text => $city->name,
            id   => $city->id,
        };
    }
    my @postal_options = ();
    while (my $postal_code = $postal_code_rs->next) {
        push @postal_options, {
            text => $postal_code->postal_code,
            id   => $postal_code->id,
        };
    }
    $c->stash->{json_data} = {
        city   => \@city_options,
        postal => \@postal_options,
    };
}


__PACKAGE__->meta->make_immutable;

1;
