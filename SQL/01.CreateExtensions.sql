/*
    .DESCRIPTION
        SQL script for PostgreSQL to execute any setup instructions in TravelNest DB,
        like adding extensions etc.


    .NOTES

        Version:            1.0
        Author:             Stanisław Horna
        Mail:               stanislawhorna@outlook.com
        GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
        Creation Date:      24-Mar-2024
        ChangeLog:

        Date            Who                     What
        2024-04-22      Stanisław Horna         Create extensions for server metrics:
                                                    - pg_stat_statements
                                                    - system_stats
*/

CREATE EXTENSION plpython3u;

CREATE EXTENSION pg_stat_statements;

CREATE EXTENSION system_stats;