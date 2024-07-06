/*
.DESCRIPTION
SQL script for PostgreSQL to DROP default DB 'postgres', 
which creation can not be skipped during container initialization.


.NOTES

Version:            1.0
Author:             Stanisław Horna
Mail:               stanislawhorna@outlook.com
GitHub Repository:  https://github.com/StanislawHornaGitHub/Investment
Creation Date:      24-Mar-2024
ChangeLog:

Date            Who                     What

 */
DROP DATABASE IF EXISTS postgres;