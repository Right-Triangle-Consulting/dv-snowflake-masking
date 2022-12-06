-- these two commands need to be run on your computer with snowsql
-- you will need to modify if you are on a windows and with the file location
put file:///[FILE LOCATION]salary.csv @demo_data_files;
put file:///[FILE LOCATION]employers.csv @demo_data_files;
put file:///[FILE LOCATION]pii_data_example.csv @demo_data_files;

-- the rest of these commands can be run on the snowflake web gui
create file format raw_vault.demo_file_format
    type = csv
    field_delimiter = ','
    skip_header = 1;

create file format raw_vault.demo_file_format_tsv
    type = csv
    field_delimiter = '\t'
    skip_header = 1;

create stage raw_vault.demo_data_files; 
alter stage raw_vault.demo_data_files set file_format = ( format_name = 'demo_file_format');

----------------------------------------------------------------------
-- Population of HUB PERSON
----------------------------------------------------------------------
create temporary table raw_vault.temp_hub_person 
(
    person_hkey int,
    person_bk varchar,
    load_timestamp timestamp_tz
);

copy into temp_hub_person from
(select $12, $12, current_timestamp() from @demo_data_files
(pattern => '.*pii_data_example.*'));

insert into hub_person
(select
    hash(person_hkey),  
    rec_src,
    load_timestamp
from temp_hub_person);

----------------------------------------------------------------------
-- Population of SAT PERSON
----------------------------------------------------------------------
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

copy into temp_sat_person from
(select $12, $1, $7, $11, $2, $2, current_timestamp() from @demo_data_files
(pattern => '.*pii_data_example.*'));

insert into sat_person
(
select
    hash(person_hkey),
    ssn,
    address,
    phone,
    sex,
    gender,
    load_timestamp
from 
    temp_sat_person
)

----------------------------------------------------------------------
-- Population of HUB EMPLOYER
----------------------------------------------------------------------
create table raw_vault.hub_employer
(
    employer_hkey int,
    employer_bk varchar,
    load_timestamp timestamp_tz
);

copy into temp_hub_employer from 
(select $1,$1, current_timestamp() from @demo_data_files
(pattern => '.*employer.*', file_format => 'demo_file_format_tsv'));

insert into hub_employer
(
    select
        hash(employer_hkey),
        employer_bk ,
        load_timestamp
from temp_hub_employer
);
----------------------------------------------------------------------
-- Population of SAT EMPLOYER
----------------------------------------------------------------------
create table raw_vault.sat_employer
(
    employer_hkey int,
    employer_address varchar,
    region varchar,
    industry varchar,
    load_timestamp timestamp_tz
);

copy into temp_sat_employer from 
(select $1,null,null,$3,current_timestamp() from @demo_data_files
(pattern => '.*employer.*', file_format => 'demo_file_format_tsv'));

insert into sat_employer
(
select
    hash(employer_hkey),
    employer_address,
    region,
    industry,
    load_timestamp
from temp_sat_employer
);
----------------------------------------------------------------------
-- Population of LINK EMPLOYER CONTRACT
----------------------------------------------------------------------
create table raw_vault.lnk_employment_contract
(
    employment_contract_hkey int,
    employer_hkey int,
    person_hkey int,
    load_timestamp timestamp_tz
);

copy into temp_lnk_employment_contract from 
(select $1 || '|' || $2,$2,$1,current_timestamp() from @demo_data_files
(pattern => '.*salary.*', file_format => 'demo_file_format'));

insert into lnk_employment_contract
(
    select 
    hash(employment_contract_hkey),
    hash(employer_hkey),
    hash(person_hkey),
    load_timestamp
    from temp_lnk_employment_contract
);

----------------------------------------------------------------------
-- Population of SAT LINK EMPLOYER CONTRACT
----------------------------------------------------------------------
create table raw_vault.sat_lnk_employment_contract
(
    employment_contract_hkey int,
    pay_amount number,
    begin_ts timestamp_tz,
    end_ts timestamp_tz,
    load_timestamp timestamp_tz
);

copy into tmp_sat_lnk_employment_contract from 
(select $1 || '|' || $2,$3,$4,$5,current_timestamp() from @demo_data_files
(pattern => '.*salary.*', file_format => 'demo_file_format'));

insert into sat_lnk_employment_contract
(
select
    hash(employment_contract_hkey),
    pay_amount,
    begin_ts,
    end_ts,
    load_timestamp
from
    tmp_sat_lnk_employment_contract
);
