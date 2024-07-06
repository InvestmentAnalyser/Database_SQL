/*
    .DESCRIPTION
        SQL script for PostgreSQL to define sub functions in Investments DB.

        This file is supposed to define all sub functions,
        which will be used in another functions, most likely those executed by triggers.

		Following actions will be performed in a given order:
			1. CREATE OR REPLACE all functions from scratch


    .RULES
		- Names consisted of more than 1 word must use '_' as words separator.
			Object names such as tables, constraints, functions are not case sensitive,
			so to make them easy easy-readable please use word separator.

        - Sub function must have a prefix 'subf_' followed by descriptive name what they are doing. 

        - Sub function can be written in SQL or PL/Python, both languages are supported,
            decision which one to use is made by person who need to use it.


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What

*/

CREATE FUNCTION get_fund_name(url_path varchar)
RETURNS varchar
AS $$
    return (
        url_path.split('/')[5].replace('-', ' ').title()
    )

$$ LANGUAGE plpython3u;

CREATE FUNCTION get_fund_id(url_path varchar)
RETURNS varchar
AS $$
    return (
        url_path.split('/')[4]
    )

$$ LANGUAGE plpython3u;

CREATE FUNCTION get_fund_category(url_path varchar)
RETURNS varchar
AS $$
    return (
        url_path.split('/')[3].replace('-', ' ').title()
    )

$$ LANGUAGE plpython3u;

CREATE FUNCTION get_fund_category_short(url_path varchar)
RETURNS varchar
AS $$
    categoryName = url_path.split('/')[3]
    return (
        ''.join(
            [word[0] for word in categoryName.split("-")]
        )
    )

$$ LANGUAGE plpython3u;

CREATE FUNCTION subtract_date_days (date_to_process timestamp, num_of_days int)
RETURNS timestamp
AS $$
import datetime
import re
    
converted_date = datetime.datetime(*[int(x) for x in re.findall(r'\d+', date_to_process)])
return (converted_date - datetime.timedelta(days= num_of_days))

$$ LANGUAGE plpython3u;

