/*
    .DESCRIPTION
        SQL script for PostgreSQL to CREATE users in Investments DB.

        Users to be created:
            - api_read <- will have access to SELECT views only.
            - api_write <- will have access to INSERT and UPDATE views only.
            - grafana_read <- will have access to SELECT views and invoke grafana functions.

    .NOTES

        Version:            1.2
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      19-Apr-2024
        ChangeLog:

        Date            Who                     What
        2024-04-22      Stanisław Horna         Add grafana_read user permissions to run system_stats functions:
                                                    - pg_sys_cpu_usage_info
                                                    - pg_sys_memory_info
        
        2024-04-23      Stanisław Horna         Add DELETE permissions for api_write user
*/

-- create required roles
CREATE ROLE "api_read" LOGIN PASSWORD 'inv!r_ap_ead1';
CREATE ROLE "api_write" LOGIN PASSWORD 'inv!w_ap_ite2';
CREATE ROLE "grafana_read" LOGIN PASSWORD 'inv!w_gf_ead3';


-- Grant privileges for API READ user
GRANT CONNECT ON DATABASE "Investments" TO "api_read";
GRANT USAGE ON SCHEMA public TO "api_read";
GRANT SELECT ON funds TO "api_read";
GRANT SELECT ON investment_results TO "api_read";
GRANT SELECT ON investments TO "api_read";
GRANT SELECT ON quotations TO "api_read";


-- Grant privileges for API WRITE user
GRANT CONNECT ON DATABASE "Investments" TO "api_write";
GRANT USAGE ON SCHEMA public TO "api_write";
GRANT SELECT, INSERT, UPDATE, DELETE ON funds TO "api_write";
GRANT SELECT, INSERT, UPDATE, DELETE ON investment_results TO "api_write";
GRANT SELECT, INSERT, UPDATE, DELETE ON investments TO "api_write";
GRANT SELECT, INSERT, UPDATE, DELETE ON quotations TO "api_write";

-- Grant privileges for Grafana user
GRANT CONNECT ON DATABASE "Investments" TO "grafana_read";
GRANT USAGE ON SCHEMA public TO "grafana_read";
GRANT SELECT ON funds TO "grafana_read";
GRANT SELECT ON investment_results TO "grafana_read";
GRANT SELECT ON investments TO "grafana_read";
GRANT SELECT ON quotations TO "grafana_read";

GRANT EXECUTE ON FUNCTION get_funds_quotation(varchar, varchar) TO "grafana_read";
GRANT EXECUTE ON FUNCTION get_investments_result(varchar, varchar) TO "grafana_read";
GRANT EXECUTE ON FUNCTION remove_investments_result() TO "grafana_read";
GRANT EXECUTE ON FUNCTION remove_fund_quotation() TO "grafana_read";
GRANT EXECUTE ON FUNCTION pg_sys_cpu_usage_info() TO "grafana_read";
GRANT EXECUTE ON FUNCTION pg_sys_memory_info() TO "grafana_read";