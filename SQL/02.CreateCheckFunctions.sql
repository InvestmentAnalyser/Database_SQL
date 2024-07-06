/*
    .DESCRIPTION
        SQL script for PostgreSQL to define CHECK functions in Investments DB.

        This file is supposed to define all check functions,
        which will be used in tables definition of CHECK CONSTRAINT.

		Following actions will be performed in a given order:
			1. CREATE OR REPLACE all functions from scratch


    .RULES
		- Names consisted of more than 1 word must use '_' as words separator.
			Object names such as tables, constraints, functions are not case sensitive,
			so to make them easy easy-readable please use word separator.

        - Check function must have a prefix 'check_' in the name. 
            Because all functions are located in the common Object explorer directory

        - Check function must return True or False values only. Try to avoid raising any exceptions.
            In order to prevent handling any CHECK related exceptions in INSERT / UPDATE statements

        - Check function can be written in SQL or PL/Python, both languages are supported,
            however if a Python one requires some additional packages to import,
            it would require to update Dockerfile.


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What

*/