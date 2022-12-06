# Data Vault Governance with Snowflake Masking Tutorial
Tutorial &amp; example on using snowflake's data masking to govern and protect a data vault

## Requirements
You'll need the following
1. A snowflake account (sign up for a free trial here: https://signup.snowflake.com/)
2. snowsql installed on your computer (https://docs.snowflake.com/en/user-guide/snowsql-install-config.html)


## Tutorial

1. Create the roles needed.  Using the AccountAdmin role, run the sql in the dv_demo_roles.sql file.

2. Create the tables.  Using the SysAdmin role, run the sql in the dv_demo_ddl.sql file.

3. Load the data.  Using the SysAdmin role, execute the sql in the dv_demo_etl.sql file.  The first 3 statements will need to be run via snowsql to get the local files in the (data_files folder) pushed up to snowflake.  The remaining sql can be run from the GUI.

4.  Apply the masking rules in the dv_demo_masking.sql file.  