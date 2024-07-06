#!/bin/sh
### DESCRIPTION
# Script to set up PostgreSQL config file in order to support pg_stat_statements.
# It should be invoked automatically during PostgreSQL container startup.

### INPUTS
# None

### OUTPUTS
# None

### CHANGE LOG
# Author:   Stanisław Horna
# GitHub Repository:  https://github.com/InvestmentAnalyser/Database_SQL
# Created:  22-Apr-2024
# Version:  1.0

# Date            Who                     What
#

MaxTrackedStatements=$EXTENSION_PG_STAT_TRACKED_STATEMENTS
CountedStatements=$EXTENSION_PG_STAT_COUNTED_STATEMENTS

Main() {
    {
        echo "shared_preload_libraries = 'pg_stat_statements'"
        echo "pg_stat_statements.max = $MaxTrackedStatements"
        echo "pg_stat_statements.track = $CountedStatements"
    } >> "$PGDATA/postgresql.conf"
}


Main
