#!/bin/sh
### DESCRIPTION
# Script to set up logging settings.

### INPUTS
# None

### OUTPUTS
# None

### CHANGE LOG
# Author:   Stanisław Horna
# GitHub Repository:  https://github.com/InvestmentAnalyser/Database_SQL
# Created:  30-Apr-2024
# Version:  1.1

# Date            Who                     What
# 2024-05-04      Stanisław Horna         Add echos after each change in config file.
#

LOG_PREFIX_PHRASE_NEW="log_line_prefix = '%m '"
LOG_PREFIX_PHRASE_DEFAULT="\#log_line_prefix = '%m \[%p\] '"

LOG_LOGGING_COLLECTOR_NEW="logging_collector = on"
LOG_LOGGING_COLLECTOR_DEFAULT="\#logging_collector = off"

LOG_FILENAME_NEW="log_filename = 'postgresql.log'"
LOG_FILENAME_DEFAULT="\#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'"

LOG_ROTATION_AGE_NEW="log_rotation_age = 60min"
LOG_ROTATION_AGE_DEFAULT="\#log_rotation_age = 1d"

LOG_TRUNCATE_NEW="log_truncate_on_rotation = on"
LOG_TRUNCATE_DEFAULT="\#log_truncate_on_rotation = off"

LOG_MIN_LEVEL_NEW="log_min_messages = info"
LOG_MIN_LEVEL_DEFAULT="\#log_min_messages = warning"

LOG_MIN_ERROR_STATEMENT_NEW="log_min_error_statement = info"
LOG_MIN_ERROR_STATEMENT_DEFAULT="\#log_min_error_statement = error"

LOG_CHECKOINTS_NEW="log_checkpoints = on"
LOG_CHECKOINTS_DEFAULT="\#log_checkpoints = on"

LOG_CONNECTIONS_NEW="log_connections = on"
LOG_CONNECTIONS_DEFAULT="\#log_connections = off"

LOG_DISCONNECTIONS_NEW="log_disconnections = on"
LOG_DISCONNECTIONS_DEFAULT="\#log_disconnections = off"

LOG_ERROR_VERBOSITY_NEW="log_error_verbosity = verbose"
LOG_ERROR_VERBOSITY_DEFAULT="\#log_error_verbosity = default"

LOG_DESTINATION_NEW="log_destination = 'jsonlog'"
LOG_DESTINATION_DEFAULT="\#log_destination = 'stderr'"

LOG_FILE_MODE_NEW="log_file_mode = 0666"
LOG_FILE_MODE_DEFAULT="\#log_file_mode = 0600"

Main() {
    setLogPrefix
    setLogFileMode
    setLogDestination
    setLogFileName
    setLogRotationAge
    setLogTruncate
    setLogMinLevel
    setLogMinStatement
    setLogCheckpoints
    setLogErrorVerbosity
    setLogConnections
    setLogColletorEnabled
}

setLogPrefix() {
    sed -i "s/$LOG_PREFIX_PHRASE_DEFAULT/$LOG_PREFIX_PHRASE_NEW/" "$PGDATA/postgresql.conf"
    echo "Log prefix set"
}
setLogFileMode() {
    sed -i "s/$LOG_FILE_MODE_DEFAULT/$LOG_FILE_MODE_NEW/" "$PGDATA/postgresql.conf"
    echo "Log file mode set"
}
setLogFileName() {
    sed -i "s/$LOG_FILENAME_DEFAULT/$LOG_FILENAME_NEW/" "$PGDATA/postgresql.conf"
    echo "Log file name set"
}
setLogDestination() {
    sed -i "s/$LOG_DESTINATION_DEFAULT/$LOG_DESTINATION_NEW/" "$PGDATA/postgresql.conf"
    echo "Log destination set"
}
setLogRotationAge() {
    sed -i "s/$LOG_ROTATION_AGE_DEFAULT/$LOG_ROTATION_AGE_NEW/" "$PGDATA/postgresql.conf"
    echo "Log rotation age set"
}
setLogTruncate() {
    sed -i "s/$LOG_TRUNCATE_DEFAULT/$LOG_TRUNCATE_NEW/" "$PGDATA/postgresql.conf"
    echo "Log truncate set"
}
setLogMinLevel() {
    sed -i "s/$LOG_MIN_LEVEL_DEFAULT/$LOG_MIN_LEVEL_NEW/" "$PGDATA/postgresql.conf"
    echo "Log min level set"
}
setLogMinStatement() {
    sed -i "s/$LOG_MIN_ERROR_STATEMENT_DEFAULT/$LOG_MIN_ERROR_STATEMENT_NEW/" "$PGDATA/postgresql.conf"
    echo "Log min statement set"
}
setLogCheckpoints() {
    sed -i "s/$LOG_CHECKOINTS_DEFAULT/$LOG_CHECKOINTS_NEW/" "$PGDATA/postgresql.conf"
    echo "Log checkpoints set"
}
setLogErrorVerbosity() {
    sed -i "s/$LOG_ERROR_VERBOSITY_DEFAULT/$LOG_ERROR_VERBOSITY_NEW/" "$PGDATA/postgresql.conf"
    echo "Log error verbosity set"
}
setLogConnections() {
    sed -i "s/$LOG_CONNECTIONS_DEFAULT/$LOG_CONNECTIONS_NEW/" "$PGDATA/postgresql.conf"
    sed -i "s/$LOG_DISCONNECTIONS_DEFAULT/$LOG_DISCONNECTIONS_NEW/" "$PGDATA/postgresql.conf"
    echo "Log connections set"
}
setLogColletorEnabled() {
    sed -i "s/$LOG_LOGGING_COLLECTOR_DEFAULT/$LOG_LOGGING_COLLECTOR_NEW/" "$PGDATA/postgresql.conf"
    echo "Log collector set"
}

Main
