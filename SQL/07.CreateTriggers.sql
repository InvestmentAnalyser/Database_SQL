/*
    .DESCRIPTION
        SQL script for PostgreSQL to define VIEW TRIGGERS in Investments DB.
        EXISTING TRIGGERS WILL BE REMOVED AND RE-CREATED WITH THIS FILES' DEFINITION.

        This file is supposed to define all triggers to call functions:
            - INSTEAD OF INSERT
            - INSTEAD OF UPDATE
            - INSTEAD OF DELETE

		Following actions will be performed in a given order:
			1. CREATE OR REPLACE all triggers from scratch


    .RULES
		- Views have dedicated catalog for triggers, names must be:
            - instead_of_insert <- INSTEAD OF INSERT
            - instead_of_update <- INSTEAD OF UPDATE
            - instead_of_delete <- INSTEAD OF DELETE 

		- TRIGGERS must be added in format: 
            CREATE OR REPLACE TRIGGER <trigger_name>
            INSTEAD OF INSERT ON <view_name>
            FOR EACH ROW
            EXECUTE FUNCTION <function_name>;


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What

*/
CREATE TRIGGER instead_of_insert
INSTEAD OF INSERT ON funds
FOR EACH ROW
EXECUTE FUNCTION insert_Fund();

CREATE TRIGGER instead_of_insert
INSTEAD OF INSERT ON investments
FOR EACH ROW
EXECUTE FUNCTION insert_investment();