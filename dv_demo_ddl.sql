create table raw_vault.hub_person 
(
    person_hkey int,
    person_bk varchar,
    load_timestamp timestamp_tz
);

create table raw_vault.sat_person 
(
    person_hkey int,
    ssn varchar,
    address varchar,
    phone varchar,
    sex varchar,
    gender varchar,
    load_timestamp timestamp_tz
);

create table raw_vault.hub_employer
(
    employer_hkey int,
    employer_bk varchar,
    load_timestamp timestamp_tz
);

create table raw_vault.sat_employer
(
    employer_hkey int,
    employer_address varchar,
    region varchar,
    industry varchar,
    load_timestamp timestamp_tz
);

create table raw_vault.lnk_employment_contract
(
    employment_contract_hkey int,
    employer_hkey int,
    person_hkey int,
    load_timestamp timestamp_tz
);

create table raw_vault.sat_lnk_employment_contract
(
    employment_contract_hkey int,
    pay_amount number,
    begin_ts timestamp_tz,
    end_ts timestamp_tz,
    load_timestamp timestamp_tz
);

create view business_vault.v_person_employment as (
select
    hp.person_bk as email_address,
    sp.ssn as ssn,
    sp.address as address,
    sp.phone as phone,
    sp.gender as gender,
    he.employer_bk as employer,
    se.industry as industry,
    slec.pay_amount as salary,
    slec.begin_ts as start_date,
    slec.end_ts as end_date
    
from
    raw_vault.hub_person hp
    LEFT JOIN raw_vault.lnk_employment_contract lec on lec.person_hkey = hp.person_hkey
    LEFT JOIN raw_vault.hub_employer he on he.employer_hkey = lec.employer_hkey
    LEFT JOIN raw_vault.sat_person sp on sp.person_hkey = hp.person_hkey
    LEFT JOIN raw_vault.sat_employer se on se.employer_hkey = he.employer_hkey
    LEFT JOIN raw_vault.sat_lnk_employment_contract slec on slec.employment_contract_hkey = lec.employment_contract_hkey);
