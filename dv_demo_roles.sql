create role DH_ACCESS;
grant role DH_ACCESS to role sysadmin;

create role DH_ACCESS_FLWS;
grant role DH_ACCESS_FLWS to role sysadmin;
grant role DH_ACCESS to role DH_ACCESS_FLWS;

create role DH_ACCESS_ASO;
grant role DH_ACCESS_ASO to role sysadmin;
grant role DH_ACCESS to role DH_ACCESS_ASO;

create role DH_ACCESS_ACHC;
grant role DH_ACCESS_ACHC to role sysadmin;
grant role DH_ACCESS to role DH_ACCESS_ACHC;

create role DH_ACCESS_PII;
grant role DH_ACCESS_PII to role sysadmin;
grant role DH_ACCESS to role DH_ACCESS_PII;

grant select on business_vault.view v_person_employment to role DH_ACCESS;
grant select on table governance.ref_employer_code to role DH_ACCESS;
grant select on table governance.ref_industry_code to role DH_ACCESS;

grant select on all views in schema dv_datagovernance_demo.business_vault to role DH_ACCESS;

grant usage on database dv_datagovernance_demo to role dh_access;
grant usage on schema dv_datagovernance_demo.business_vault to role dh_access;
grant usage on schema dv_datagovernance_demo.governance to role dh_access;