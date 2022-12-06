create table governance.ref_employer (
    employer_code varchar,
    employer_name varchar
);

insert into governance.ref_employer
values
('FLWS', '1-800-FLOWERS.COM Inc. Cl A (FLWS)'),
('ASO', 'Academy Sports & Outdoors Inc. (ASO)'),
('ACHC', 'Acadia Healthcare Co. Inc. (ACHC)');

create row access policy governance.rap_employer as (employer varchar) returns boolean ->
    exists (
        select 1 from ref_employer 
        where
            employer_name = employer
            and current_role() = 'DH_ACCESS_' || employer_code
    );
    
alter view v_person_employment add row access policy governance.rap_employer on (employer);

create masking policy privacy_varchar as (val string) returns string -> 
    case
        when current_role() in ('DH_ACCESS_PII') then val
        else '******'
    end;

create masking policy privacy_number as (val number) returns number -> 
    case
        when current_role() in ('DH_ACCESS_PII') then val
        else null
    end;

create tag governance.privacy;
alter view business_vault.v_person_employment modify column ssn set tag privacy = 'pii';
alter view business_vault.v_person_employment modify column address set tag privacy = 'pii';
alter view business_vault.v_person_employment modify column phone set tag privacy = 'pii';
alter view business_vault.v_person_employment modify column salary set tag privacy = 'pii';

alter tag privacy set masking policy governance.privacy_varchar;
alter tag privacy set masking policy governance.privacy_number;