/*
    .DESCRIPTION
        SQL script for PostgreSQL to define INSERT functions in Investments DB.

        This file is supposed to define all insert functions,
        which will be used in INSTEAD OF INSERT view triggers.

		Following actions will be performed in a given order:
			1. CREATE OR REPLACE all functions from scratch


    .RULES
		- Names consisted of more than 1 word must use '_' as words separator.
			Object names such as tables, constraints, functions are not case sensitive,
			so to make them easy easy-readable please use word separator.

        - Insert function must have a prefix 'insert_' followed by <view_name> in the name. 
            Because all functions are located in the common Object explorer directory.

        - Insert function must return NULL if operation was successful, 
            otherwise raise an descriptive exception, which will be capture by backend.

        - Insert function can be written in SQL or PL/Python, both languages are supported,
            however RECOMMENDED FOR DATA MODIFICATION IS SQL.

        - Insert function must handle everything related to inserting record to DB,
            including all insert statements to any related table


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What
        2024-04-19      Stanisław Horna         add SECURITY DEFINER <- to invoke functions with owner's permissions, 
                                                    instead of caller ones.
        
*/

CREATE FUNCTION insert_Fund ()
RETURNS TRIGGER AS $$
DECLARE
    var_fund_url varchar;
    var_fund_name varchar;
    var_fund_id varchar;
    var_category_name varchar;
    var_category_short varchar;
    var_category_id int;
BEGIN

    var_fund_url := NEW.fund_url;

    IF var_fund_url IS NOT NULL THEN
        var_fund_name := get_fund_name(var_fund_url);
        var_fund_id := get_fund_id(var_fund_url);
        var_category_name := get_fund_category(var_fund_url);
        var_category_short := get_fund_category_short(var_fund_url);

        INSERT INTO Fund_Category(c_name, C_shortname)
        VALUES(var_category_name,var_category_short)
        RETURNING ID INTO var_category_id;

        INSERT INTO Fund (ID, F_name, Category_ID, F_url)
        VALUES(var_fund_id,var_fund_name,var_category_id,var_fund_url);

        RETURN NEW;
    END IF;

    RAISE EXCEPTION 'Can not add new fund without URL';

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE FUNCTION insert_investment ()
RETURNS TRIGGER AS $$
DECLARE
    Inv_ID int;
    Own_ID int;
    Ops_ID int;
    Duplicate_Ops_count int;
BEGIN   

    SELECT
        Count(*)
    INTO Duplicate_Ops_count
    FROM Investments
    WHERE 
        investment_name = NEW.investment_name AND
        investment_owner = NEW.investment_owner AND
        investment_fund_id = NEW.investment_fund_id AND
        operation_quotation_date = NEW.operation_quotation_date AND
        operation_value = NEW.operation_value;

    IF Duplicate_Ops_count > 0 THEN

    RAISE EXCEPTION 
        'This operation already exists' 
        USING ERRCODE = 'integrity_constraint_violation';
    
    RETURN NULL;

    END IF;

    -- Investment Owner
    IF NEW.investment_owner_id IS NULL THEN
        
        -- Check if it is not the next row of bulk insert
        SELECT
            ID
        INTO Own_ID
        FROM investment_owner
        WHERE o_name = NEW.investment_owner;

        -- If Owner ID is not found based on the name insert new one
        IF Own_ID IS NULL THEN

            INSERT INTO investment_owner(o_name)
            VALUES(NEW.investment_owner)
            RETURNING ID INTO Own_ID;

        END IF;
    
    -- If owner id was provided simply use it
    ELSE
        Own_ID:= NEW.investment_owner_id;
    END IF;

    -- Investment 
    IF NEW.investment_id IS NULL THEN

        -- Check if it is not the next row of bulk insert
        SELECT
            ID
        INTO Inv_ID
        FROM investment
        WHERE 
            i_name = NEW.investment_name AND
            Owner_ID = Own_ID;

        -- If Investment ID is not found based on the name insert new one
        IF Inv_ID IS NULL THEN

            INSERT INTO investment(
                i_name, 
                Owner_ID,
                Start_date,
                End_date
                )
            VALUES(
                NEW.investment_name,
                Own_ID,
                NEW.investment_start_date,
                NEW.investment_end_date
                )
            RETURNING ID INTO Inv_ID;

        END IF;

    -- If investment id was provided simply use it
    ELSE
        Inv_ID := NEW.investment_id;
    END IF;

    -- Insert operation of purchase or sale
    INSERT INTO Fund_Operations (
        Quotation_date, 
        Operation_date,
        Operation_value,
        Operation_currency
        )
    VALUES(
        NEW.operation_quotation_date,
        NEW.operation_date,
        NEW.operation_value,
        NEW.operation_currency
    )
    RETURNING ID INTO Ops_ID;

    -- Insert link between particular fund, operation and investment
    INSERT INTO investment_fund(
        investment_id,
        fund_id,
        operation_id
    )
    VALUES(
        Inv_ID,
        NEW.investment_fund_id,
        Ops_ID
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;