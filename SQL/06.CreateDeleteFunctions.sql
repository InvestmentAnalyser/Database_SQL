/*
    .DESCRIPTION
        SQL script for PostgreSQL to define DELETE functions in Investments DB.

        This file is supposed to define all delete functions,
        which will be used in INSTEAD OF DELETE view triggers.

		Following actions will be performed in a given order:
			1. CREATE OR REPLACE all functions from scratch


    .RULES
		- Names consisted of more than 1 word must use '_' as words separator.
			Object names such as tables, constraints, functions are not case sensitive,
			so to make them easy easy-readable please use word separator.

        - Delete function must have a prefix 'delete_' followed by <view_name> in the name. 
            Because all functions are located in the common Object explorer directory.

        - Delete function must return NULL if operation was successful, 
            otherwise raise an descriptive exception, which will be capture by backend.

        - Delete function can be written in SQL or PL/Python, both languages are supported,
            however RECOMMENDED FOR DATA MODIFICATION IS SQL.

        - Delete function must handle everything related to removing record from DB,
            including any additionally required cleanup.


    .NOTES

        Version:            1.2
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      18-Mar-2024
        ChangeLog:

        Date            Who                     What
        2024-07-11      Stanisław Horna         Add delete functions for funds and investments views

        2024-07-15      Stanisław Horna         Add removing investment entry if there are no operations linked.

*/

CREATE FUNCTION delete_Fund ()
RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM Fund
    WHERE ID = OLD.fund_id;

    RETURN OLD;
    
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE FUNCTION delete_Investment ()
RETURNS TRIGGER AS $$
DECLARE
    Ops_ID int;
BEGIN   

    -- get operation id
    SELECT 
        ID
    INTO Ops_ID
    FROM Fund_Operations fo
    LEFT JOIN Investment_Fund ifun ON fo.id = ifun.Operation_ID
    WHERE ifun.Fund_ID = OLD.investment_fund_id
        AND ifun.Investment_ID = OLD.investment_id
        AND fo.Quotation_date = OLD.operation_quotation_date;

    -- delete link between operation and investment
    DELETE FROM Investment_Fund
    WHERE Investment_ID = OLD.investment_id
        AND Fund_ID = OLD.investment_fund_id
        AND Operation_ID = Ops_ID;

    -- delete operation
    DELETE FROM Fund_Operations
    WHERE ID = Ops_ID;

    -- delete investment entry, if there are no operations linked to the investment
    IF NOT EXISTS (
        SELECT
            Investment_ID
        FROM Investment_Fund
        WHERE Investment_ID = OLD.investment_id
    ) THEN
        DELETE FROM Investment
        WHERE ID = OLD.investment_id;
    END IF;
    
    RETURN OLD;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;