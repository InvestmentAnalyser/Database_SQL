/*
    .DESCRIPTION
        SQL script for PostgreSQL to define UPDATE functions in Investments DB.

        This file is supposed to define all update functions,
        which will be used in INSTEAD OF UPDATE view triggers.

		Following actions will be performed in a given order:
			1. CREATE OR REPLACE all functions from scratch


    .RULES
		- Names consisted of more than 1 word must use '_' as words separator.
			Object names such as tables, constraints, functions are not case sensitive,
			so to make them easy easy-readable please use word separator.

        - Update function must have a prefix 'update_' followed by <view_name> in the name. 
            Because all functions are located in the common Object explorer directory.

        - Update function must return NULL if operation was successful, 
            otherwise raise an descriptive exception, which will be capture by backend.

        - Update function can be written in SQL or PL/Python, both languages are supported,
            however RECOMMENDED FOR DATA MODIFICATION IS SQL.

        - Update function must handle everything related to updating record to DB,
            including checks which are required to identify if such action is allowed.


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What

*/