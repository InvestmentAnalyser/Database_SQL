/*
    .DESCRIPTION
        SQL script for PostgreSQL to configure Views in Investments DB.
        EXISTING DB VIEWS WILL BE REMOVED AND PRIVILEGES WILL BE FLUSHED.

		Following actions will be performed in a given order:
			1. DROP of all TravelNest Views.
			2. CREATE all Views from scratch.


	.RULES
		- DROP VIEW must include IF EXISTS.

		- Required columns must be defined with table alias for better visibility.

		- Aliases for VIEW columns must contain view name, column name in format:
			<view_name>_<column_name>


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What

*/

CREATE VIEW Funds AS
SELECT
    f.ID AS "fund_id",
    f.F_name AS "fund_name",
    fc.C_name AS "category_name",
    fc.C_shortname AS "category_short",
    f.Currency AS "currency",
    f.F_url AS "fund_url"
FROM Fund f
LEFT JOIN Fund_Category fc ON fc.ID = f.Category_ID;


CREATE VIEW Quotations AS
SELECT
    fq.Quotation_date AS "date",
    fq.fund_id AS "fund_id",
    fq.Quotation_value AS "value",
    fq.Day_value_change AS "daily_change",
    fq.Week_value_change AS "weekly_change",
    fq.Month_value_change AS "monthly_change",
    fq.Year_value_change AS "yearly_change"
FROM Fund_Quotation fq;


CREATE VIEW Investments AS
SELECT
    i.id AS "investment_id",
    i.I_name AS "investment_name",
    i.Start_date AS "investment_start_date",
    i.End_date AS "investment_end_date",
    io.id AS "investment_owner_id",
    io.O_Name AS "investment_owner",
    ifun.fund_id AS "investment_fund_id",
    fo.Quotation_date AS "operation_quotation_date",
    fo.Operation_date AS "operation_date",
    fo.Operation_value AS "operation_value",
    fo.Operation_currency AS "operation_currency"
FROM Investment i
LEFT JOIN Investment_Fund ifun ON ifun.investment_id = i.id
LEFT JOIN Investment_Owner io ON io.id = i.Owner_ID
LEFT JOIN Fund_Operations fo ON fo.ID = ifun.Operation_ID;


CREATE VIEW Investment_Results AS
SELECT
    ifr.Result_date AS "result_date",
    ifr.fund_id AS "fund_id",
    ifr.investment_id AS "investment_id",
    ifr.Participation_units AS "fund_participation_units",
    ifr.Invested_money AS "fund_invested_money",
    ifr.Fund_value AS "fund_value",
    ifr.Day_profit AS "last_day_result",
    ifr.Week_profit AS "last_week_result",
    ifr.Month_profit AS "last_month_result",
    ifr.Year_profit AS "last_year_result"
FROM Investment_Fund_Results ifr;


