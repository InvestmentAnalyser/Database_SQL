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

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      18-Mar-2024
        ChangeLog:

        Date            Who                     What

*/