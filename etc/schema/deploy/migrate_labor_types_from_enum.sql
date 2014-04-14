-- Deploy migrate_labor_types_from_enum

BEGIN;

    CREATE TEMPORARY TABLE tmp_labor_organization WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization;
    CREATE TEMPORARY TABLE tmp_labor_organization_affiliation WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_affiliation;
    CREATE TEMPORARY TABLE tmp_labor_organization_membership WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_membership;
    CREATE TEMPORARY TABLE tmp_labor_organization_address WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_address;
    CREATE TEMPORARY TABLE tmp_labor_organization_total_disbursement WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_total_disbursement;
    CREATE TEMPORARY TABLE tmp_labor_organization_total_liability WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_total_liability;
    CREATE TEMPORARY TABLE tmp_labor_organization_payee WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_payee;
    CREATE TEMPORARY TABLE tmp_labor_organization_other_asset WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_other_asset;
    CREATE TEMPORARY TABLE tmp_labor_organization_fixed_asset WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_fixed_asset;
    CREATE TEMPORARY TABLE tmp_labor_organization_investment_asset WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_investment_asset;
    CREATE TEMPORARY TABLE tmp_labor_organization_total_asset WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_total_asset;
    CREATE TEMPORARY TABLE tmp_labor_organization_account_payable WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_account_payable;
    CREATE TEMPORARY TABLE tmp_labor_organization_account_receivable WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_account_receivable;
    CREATE TEMPORARY TABLE tmp_labor_organization_loan_payable WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_loan_payable;
    CREATE TEMPORARY TABLE tmp_labor_organization_loan_receivable WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_loan_receivable;
    CREATE TEMPORARY TABLE tmp_labor_organization_other_liability WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_other_liability;
    CREATE TEMPORARY TABLE tmp_labor_organization_sale_receipt WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_sale_receipt;
    CREATE TEMPORARY TABLE tmp_labor_organization_other_receipt WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_other_receipt;
    CREATE TEMPORARY TABLE tmp_labor_organization_total_receipt WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_total_receipt;
    CREATE TEMPORARY TABLE tmp_labor_organization_general_disbursement WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_general_disbursement;
    CREATE TEMPORARY TABLE tmp_labor_organization_investment_purchase WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_investment_purchase;
    CREATE TEMPORARY TABLE tmp_labor_organization_officer_disbursement WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_officer_disbursement;
    CREATE TEMPORARY TABLE tmp_labor_organization_benefit_disbursement WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_benefit_disbursement;
    CREATE TEMPORARY TABLE tmp_labor_organization_work_stoppage WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_work_stoppage;
    CREATE TEMPORARY TABLE tmp_labor_organization_osha_citation WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_osha_citation;
    CREATE TEMPORARY TABLE tmp_labor_organization_nlrb_decision WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_nlrb_decision;
    CREATE TEMPORARY TABLE tmp_labor_organization_port WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_port;
    CREATE TEMPORARY TABLE tmp_labor_organization_warehouse WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_warehouse;
    CREATE TEMPORARY TABLE tmp_labor_organization_rail_node WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_rail_node;
    CREATE TEMPORARY TABLE tmp_labor_organization_payee_address WITH(OIDS) ON COMMIT DROP AS SELECT * FROM labor_organization_payee_address;


    ALTER TABLE tmp_labor_organization ALTER COLUMN organization_type SET DATA TYPE TEXT;
    DROP TYPE IF EXISTS labor_organization_type cascade;

    CREATE TABLE labor_organization_type (
        id serial not null primary key,
        create_time timestamptz not null default now(),
        update_time timestamptz not null default now(),
        delete_time timestamptz default null,
        name text not null
    );

    INSERT INTO labor_organization_type (name) VALUES
        ('federation'),
        ('union'),
        ('hybrid'),
        ('reform'),
        ('local'),
        ('unaffiliated'),
        ('other');


    UPDATE tmp_labor_organization te SET organization_type = o.id FROM labor_organization_type o WHERE te.organization_type = o.name;

    ALTER TABLE tmp_labor_organization ALTER COLUMN organization_type SET DATA TYPE integer USING (organization_type::integer);

    TRUNCATE labor_organization CASCADE;

    ALTER TABLE labor_organization ADD COLUMN organization_type integer references labor_organization_type (id);
    CREATE INDEX labor_organization_organization_type ON labor_organization (organization_type);

    INSERT INTO labor_organization SELECT tc.id,tc.create_time,tc.update_time,tc.delete_time,tc.name,tc.usdol_filing_number,tc.abbreviation,tc.date_established,tc.url,tc.local_prefix,tc.local_suffix,tc.local_type,tc.local_number,tc.description,tc.organization_type FROM tmp_labor_organization tc;
    INSERT INTO labor_organization_affiliation SELECT * FROM tmp_labor_organization_affiliation;
    INSERT INTO labor_organization_membership SELECT * FROM tmp_labor_organization_membership;
    INSERT INTO labor_organization_address SELECT * FROM tmp_labor_organization_address;
    INSERT INTO labor_organization_total_disbursement SELECT * FROM tmp_labor_organization_total_disbursement;
    INSERT INTO labor_organization_total_liability SELECT * FROM tmp_labor_organization_total_liability;
    INSERT INTO labor_organization_payee SELECT * FROM tmp_labor_organization_payee;
    INSERT INTO labor_organization_other_asset SELECT * FROM tmp_labor_organization_other_asset;
    INSERT INTO labor_organization_fixed_asset SELECT * FROM tmp_labor_organization_fixed_asset;
    INSERT INTO labor_organization_investment_asset SELECT * FROM tmp_labor_organization_investment_asset;
    INSERT INTO labor_organization_total_asset SELECT * FROM tmp_labor_organization_total_asset;
    INSERT INTO labor_organization_account_payable SELECT * FROM tmp_labor_organization_account_payable;
    INSERT INTO labor_organization_account_receivable SELECT * FROM tmp_labor_organization_account_receivable;
    INSERT INTO labor_organization_loan_payable SELECT * FROM tmp_labor_organization_loan_payable;
    INSERT INTO labor_organization_loan_receivable SELECT * FROM tmp_labor_organization_loan_receivable;
    INSERT INTO labor_organization_other_liability SELECT * FROM tmp_labor_organization_other_liability;
    INSERT INTO labor_organization_sale_receipt SELECT * FROM tmp_labor_organization_sale_receipt;
    INSERT INTO labor_organization_other_receipt SELECT * FROM tmp_labor_organization_other_receipt;
    INSERT INTO labor_organization_total_receipt SELECT * FROM tmp_labor_organization_total_receipt;
    INSERT INTO labor_organization_general_disbursement SELECT * FROM tmp_labor_organization_general_disbursement;
    INSERT INTO labor_organization_investment_purchase SELECT * FROM tmp_labor_organization_investment_purchase;
    INSERT INTO labor_organization_officer_disbursement SELECT * FROM tmp_labor_organization_officer_disbursement;
    INSERT INTO labor_organization_benefit_disbursement SELECT * FROM tmp_labor_organization_benefit_disbursement;
    INSERT INTO labor_organization_work_stoppage SELECT * FROM tmp_labor_organization_work_stoppage;
    INSERT INTO labor_organization_osha_citation SELECT * FROM tmp_labor_organization_osha_citation;
    INSERT INTO labor_organization_nlrb_decision SELECT * FROM tmp_labor_organization_nlrb_decision;
    INSERT INTO labor_organization_port SELECT * FROM tmp_labor_organization_port;
    INSERT INTO labor_organization_warehouse SELECT * FROM tmp_labor_organization_warehouse;
    INSERT INTO labor_organization_rail_node SELECT * FROM tmp_labor_organization_rail_node;
    INSERT INTO labor_organization_payee_address SELECT * FROM tmp_labor_organization_payee_address;



    CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_type FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

COMMIT;
