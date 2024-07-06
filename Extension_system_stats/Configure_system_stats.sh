#!/bin/sh
### DESCRIPTION
# Script to set up PostgreSQL to use system_stats extension.
# It requires to unpack archive file, compile code and install it.

### INPUTS
# None, all inputs are pulled in from environmental variables

### OUTPUTS
# None

### CHANGE LOG
# Author:   Stanisław Horna
# GitHub Repository:  https://github.com/InvestmentAnalyser/Database_SQL
# Created:  22-Apr-2024
# Version:  1.0

# Date            Who                     What
#

archiveFileName="$EXTENSION_SYSTEM_STATS_FILE"
workingDir="$EXTENSION_SYSTEM_STATS_WORKDIR"

Main(){
    cd "$workingDir" || exit 1
    UnpackArchive
    CompileCode
    InstallCode
}

UnpackArchive(){
    tar -zxvf "./$archiveFileName" 
    directoryName="${archiveFileName%.*}"
    directoryName="${directoryName%.*}"
    cd "./$directoryName" || exit 1
}

CompileCode(){
    PATH="/usr/local/pgsql/bin:$PATH" make USE_PGXS=1
}

InstallCode(){
    PATH="/usr/local/pgsql/bin:$PATH" make install USE_PGXS=1
}

Main
