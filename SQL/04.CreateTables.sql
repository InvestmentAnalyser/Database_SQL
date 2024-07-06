/*
    .DESCRIPTION
        SQL script for PostgreSQL to configure Tables in Investments DB.

		Following actions will be performed in a given order:
			1. DROP of all TravelNest Tables.
			2. CREATE all Tables from scratch,
				create CHECK CONSTRAINT
			3. ADD FOREIGN KEY for each table
			4. INSERT static data:
				- dictionary entries (tables with prefix 'dict_' in the name)
				- Default user in user account called 'SYSTEM'


	.RULES
		- DROP TABLE must include IF EXISTS, as well as CASCADE.

		- DEFAULT must be included in CREATE TABLE in the same line as column definition, which it is related to.

		- CHECK constraint must be included in CREATE TABLE instruction after columns definition in format:
			CONSTRAINT <check_name>_chk CHECK (<Expression_to_check>).

		- FOREIGN KEY must be added at the last section of the file in format: 
			ALTER TABLE <table_name>
			ADD CONSTRAINT <foreign_key_name>_fkey FOREIGN KEY (<column_name>)
			REFERENCES <foreign_table_name> (<foreign_column_name>) MATCH SIMPLE;
		
		- Names consisted of more than 1 word must use '_' as words separator.
			Object names such as tables, constraints, functions are not case sensitive,
			so to make them easy easy-readable please use word separator.

		- Constraints' suffixes:
			- PRIMARY KEY 	<- suffix '_pkey'
			- FOREIGN KEY 	<- suffix '_fkey'
			- CHECK 		<- suffix '_chk'

		- Constraints' names:
			- PRIMARY KEY 	<- must have same name as table name + appropriate suffix.
			- FOREIGN KEY 	<- must have same name as column, which it is related to, 
								skipping column name suffix which for fkeys must be '_ID' + appropriate suffix.
			- CHECK 		<- must have same name as column, which it is related to + appropriate suffix.
								If CHECK is related to more then 1 column, name can be custom to describe,
								what does it check + appropriate suffix.


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What

*/

CREATE TABLE Fund (
    ID varchar PRIMARY KEY NOT NULL,
    F_name varchar NOT NULL,
    Category_ID int NOT NULL,
    Currency varchar,
    F_url varchar NOT NULL
);

CREATE TABLE Fund_Category (
    ID serial PRIMARY KEY NOT NULL,
    C_name varchar NOT NULL,
    C_shortname varchar NOT NULL
);

CREATE TABLE Fund_Quotation (
    Quotation_date timestamp NOT NULL,
    Fund_ID varchar NOT NULL,
    Quotation_value float NOT NULL,
    Day_value_change float NULL,
    Week_value_change float NULL,
    Month_value_change float NULL,
    Year_value_change float NULL,

    CONSTRAINT Fund_Quotation_pkey PRIMARY KEY (Quotation_date,Fund_ID)
);

CREATE TABLE Fund_Operations (
    ID serial PRIMARY KEY NOT NULL,
    Quotation_date timestamp NOT NULL,
    Operation_date timestamp NULL,
    Operation_value float NOT NULL,
    Operation_currency varchar NULL
);

CREATE TABLE Investment (
    ID serial UNIQUE NOT NULL,
    I_name varchar NOT NULL,
    Owner_ID int NOT NULL,
    Start_date timestamp NULL,
    End_date timestamp NULL,

    CONSTRAINT Investment_pkey PRIMARY KEY (ID,Owner_ID)
);

CREATE TABLE Investment_Fund (
    Investment_ID int NOT NULL,
    Fund_ID varchar NOT NULL,
    Operation_ID int NOT NULL,

    CONSTRAINT Investment_Fund_pkey PRIMARY KEY (Investment_ID,Fund_ID,Operation_ID)
);

CREATE TABLE Investment_Fund_Results (
    Result_date timestamp NOT NULL,
    Fund_ID varchar NOT NULL,
    Investment_ID int NOT NULL,
    Participation_units float NOT NULL,
    Invested_money float NOT NULL,
    Fund_value float NOT NULL,
    Day_profit float NULL,
    Week_profit float NULL,
    Month_profit float NULL,
    Year_profit float NULL,
    

    CONSTRAINT Investment_Fund_Results_pkey PRIMARY KEY (Result_date,Fund_ID,Investment_ID)
);

CREATE TABLE Investment_Owner (
    ID serial PRIMARY KEY NOT NULL,
    O_Name varchar NULL
);

ALTER TABLE Fund 
ADD CONSTRAINT Category_fkey FOREIGN KEY (Category_ID) 
REFERENCES Fund_Category (ID) MATCH SIMPLE;

ALTER TABLE Investment_Fund 
ADD CONSTRAINT Investment_fkey FOREIGN KEY (Investment_ID) 
REFERENCES Investment (ID) MATCH SIMPLE;

ALTER TABLE Investment_Fund 
ADD CONSTRAINT Operation_fkey FOREIGN KEY (Operation_ID) 
REFERENCES Fund_Operations (ID) MATCH SIMPLE;

ALTER TABLE Investment_Fund 
ADD CONSTRAINT Fund_fkey FOREIGN KEY (Fund_ID) 
REFERENCES Fund (ID) MATCH SIMPLE;

ALTER TABLE Investment_Fund_Results 
ADD CONSTRAINT Fund_fkey FOREIGN KEY (Fund_ID) 
REFERENCES Fund (ID) MATCH SIMPLE;

ALTER TABLE Investment
ADD CONSTRAINT Owner_fkey FOREIGN KEY (Owner_ID) 
REFERENCES Investment_Owner (ID) MATCH SIMPLE;

ALTER TABLE Fund_Quotation
ADD CONSTRAINT Fund_fkey FOREIGN KEY (Fund_ID) 
REFERENCES Fund (ID) MATCH SIMPLE;