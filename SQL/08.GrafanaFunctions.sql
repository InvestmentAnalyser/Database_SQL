/*
    .DESCRIPTION
        SQL script for PostgreSQL to define functions for Grafana in Investments DB.
        
        Unfortunately Grafana do not have plugin which allows to call API directly,
        however there is an Button panel plugin which allows to execute PostgreSQL query.
        It will be used to invoke PostgreSQL functions which will call Flask API,
        to perform needed operation


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      30-Mar-2024
        ChangeLog:

        Date            Who                     What
        2024-04-19      Stanisław Horna         add SECURITY DEFINER <- to invoke functions with owner's permissions, 
                                                    instead of caller ones.
*/

CREATE FUNCTION get_funds_quotation(api_address varchar, api_port varchar)
RETURNS int
AS $$

import requests
return (
	requests.put(f"http://{api_address}:{api_port}/FundQuotation").status_code
)

$$ LANGUAGE plpython3u;


CREATE FUNCTION get_investments_result(api_address varchar, api_port varchar)
RETURNS int
AS $$

import requests
return (
	requests.put(f"http://{api_address}:{api_port}/InvestmentRefund").status_code
)

$$ LANGUAGE plpython3u;

CREATE FUNCTION remove_investments_result ()
RETURNS void AS $$
BEGIN
	DELETE FROM investment_results;
	RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE FUNCTION remove_fund_quotation ()
RETURNS void AS $$
BEGIN
	DELETE FROM Quotations;
	RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;