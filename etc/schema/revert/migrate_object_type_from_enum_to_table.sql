-- Revert migrate_object_type_from_enum_to_table

BEGIN;

    CREATE TEMPORARY TABLE tmp_edit_history WITH(OIDS) ON COMMIT DROP AS SELECT * FROM edit_history;
    CREATE TEMPORARY TABLE tmp_edit_history_field WITH(OIDS) ON COMMIT DROP AS SELECT * FROM edit_history_field;

    ALTER TABLE tmp_edit_history ALTER COLUMN object_type SET DATA TYPE TEXT;
    UPDATE tmp_edit_history te SET object_type = ot.name FROM object_type ot WHERE te.object_type::integer = ot.id;

    DROP TABLE object_type cascade;

    create type object_type as enum (
        'address',
        'company',
        'company_address',
        'company_nlrb_decision',
        'company_osha_citation',
        'company_port',
        'company_rail_node',
        'company_warehouse',
        'edit_history',
        'edit_history_field',
        'labor_organization',
        'labor_organization_account_payable',
        'labor_organization_account_receivable',
        'labor_organization_address',
        'labor_organization_affiliation',
        'labor_organization_benefit_disbursement',
        'labor_organization_fixed_asset',
        'labor_organization_general_disbursement',
        'labor_organization_investment_asset',
        'labor_organization_investment_purchase',
        'labor_organization_loan_payable',
        'labor_organization_loan_receivable',
        'labor_organization_membership',
        'labor_organization_nlrb_decision',
        'labor_organization_officer_disbursement',
        'labor_organization_osha_citation',
        'labor_organization_other_asset',
        'labor_organization_other_liability',
        'labor_organization_other_receipt',
        'labor_organization_payee',
        'labor_organization_payee_address',
        'labor_organization_port',
        'labor_organization_rail_node',
        'labor_organization_sale_receipt',
        'labor_organization_total_asset',
        'labor_organization_total_disbursement',
        'labor_organization_total_liability',
        'labor_organization_total_receipt',
        'labor_organization_warehouse',
        'labor_organization_work_stoppage',
        'media',
        'nlrb_decision',
        'osha_citation',
        'port',
        'port_address',
        'port_depth_feet',
        'port_depth_meters',
        'port_drydock',
        'port_harbor_size',
        'port_harbor_type',
        'port_repair',
        'port_shelter',
        'port_tonnage',
        'port_vessel_size',
        'port_work_stoppage',
        'rail_density',
        'rail_interline',
        'rail_line',
        'rail_line_class',
        'rail_line_work_stoppage',
        'rail_military',
        'rail_node',
        'rail_node_work_stoppage',
        'rail_ownership',
        'rail_passenger',
        'rail_signal',
        'rail_status',
        'rail_subdivision',
        'rail_subdivision_state',
        'rail_track_gauge',
        'rail_track_grade',
        'rail_track_type',
        'role',
        'state',
        'topology',
        'user',
        'user_role',
        'walmart',
        'warehouse',
        'warehouse_address',
        'warehouse_owner',
        'warehouse_type',
        'warehouse_walmart',
        'warehouse_work_stoppage',
        'work_stoppage'
    );

    ALTER TABLE tmp_edit_history ALTER COLUMN object_type SET DATA TYPE object_type USING (object_type::object_type);

    TRUNCATE edit_history CASCADE;

    ALTER TABLE edit_history DROP COLUMN object_type;
    ALTER TABLE edit_history ADD COLUMN object_type object_type;
    CREATE INDEX edit_history_object_type ON edit_history (object_type);

    INSERT INTO edit_history SELECT te.id,te.create_time,te.update_time,te.object,te."user",te.notes,te.object_type FROM tmp_edit_history te;
    INSERT INTO edit_history_field SELECT * FROM tmp_edit_history_field;

COMMIT;
