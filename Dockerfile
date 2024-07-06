### DESCRIPTION
# Docker file to create Docker image for Investments DB, with python functions support.

### INPUTS
# TZ - time zone to be set in container
# POSTGRES_DB - Database name (do not change)
# POSTGRES_PASSWORD - Super admin password
# POSTGRES_USER - Super admin username
# POSTGRES_INITDB_ARGS - init args used to set encoding collate, etc.
# EXTENSION_SYSTEM_STATS_FILE - name of the archive with additional code required for system_stats
# EXTENSION_SYSTEM_STATS_WORKDIR - in container directory used to unpack archive, cleand after initialization.

### CHANGE LOG
# Author:   Stanisław Horna
# GitHub Repository:  https://github.com/InvestmentAnalyser/Database_SQL
# Created:  24-Mar-2024
# Version:  1.1

# Date            Who                     What
# 2024-04-22      Stanisław Horna         Add support for following extensions:
#                                           - system_stats
#                                           - pg_stats_statement

FROM postgres:16.2

#### Environmental variables ####
# Set timezone
ENV TZ="Europe/Warsaw"
# Set DB name and default user
ENV POSTGRES_DB="Investments"
ENV POSTGRES_PASSWORD="DefP4550RD"
ENV POSTGRES_USER="Investments"
# Set DB collate
ENV POSTGRES_INITDB_ARGS="--encoding=UTF-8 --lc-collate=pl_PL.utf8 --lc-ctype=pl_PL.utf8"

##### system_stats extension
# EXTENSION_SYSTEM_STATS_FILE - file name of the archive file located in SystemStats directory,
#    which includes necessary code to enable extension.
#
# EXTENSION_SYSTEM_STATS_WORKDIR - working directory location used to unpack the archive file
#    and store initialization script. This location will be flushed after extension init
ENV EXTENSION_SYSTEM_STATS_FILE="system_stats-2.1.tar.gz"
ENV EXTENSION_SYSTEM_STATS_WORKDIR="/tmp"

##### pg_stat_statements extension
# EXTENSION_PG_STAT_TRACKED_STATEMENTS -  maximum number of statements tracked by the module 
#    (i.e., the maximum number of rows in the pg_stat_statements view). 
#    If more distinct statements than that are observed, information about the least-executed statements is discarded. 
#    The number of times such information was discarded can be seen in the pg_stat_statements_info view. 
#    The default value is 5000.
# 
# EXTENSION_PG_STAT_COUNTED_STATEMENTS - controls which statements are counted by the module. 
#    Specify top to track top-level statements (those issued directly by clients), all to also track nested statements 
#    (such as statements invoked within functions), or none to disable statement statistics collection. 
#    The default value is top.
ENV EXTENSION_PG_STAT_TRACKED_STATEMENTS="10000"
ENV EXTENSION_PG_STAT_COUNTED_STATEMENTS="all"


#### Install packages ####
# Install plpython extension for code written in Python support
RUN apt-get update
RUN apt-get install -y postgresql-plpython3-16
RUN apt-get install -y locales locales-all
RUN apt-get install -y python3-requests

# Install dependencies for system_stats extension
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y postgresql-server-dev-16


#### Copy files ####
# Copy scripts to run on startup
COPY ./SQL/* /docker-entrypoint-initdb.d/

# Copy archive with system_stats extension code and initialization script
COPY ./Extension_system_stats/*  ${EXTENSION_SYSTEM_STATS_WORKDIR}/

# Run system_stats initialization script
RUN chmod +x ${EXTENSION_SYSTEM_STATS_WORKDIR}/Configure_system_stats.sh
RUN ${EXTENSION_SYSTEM_STATS_WORKDIR}/Configure_system_stats.sh

# Cleanup temp directory
RUN rm -fr ${EXTENSION_SYSTEM_STATS_WORKDIR}/*


EXPOSE 5432
CMD ["postgres"]
