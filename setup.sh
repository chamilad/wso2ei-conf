#!/bin/bash

# This script should act as the init script to a starting instance
# that should be configured. The following environment variables
# should be provided (via user-data or any other prefered method).
#
# WSO2_SERVER_RUNTIME - The runtime id of the server. Currently supports either
#                       "bps" or "integrator".
# WSO2_HOSTNAME - The hostname to be used in the WSO2 servers
# WSO2_DB_HOSTNAME - The hostname of the DB server
# WSO2_DB_PORT - The port at which the DB server is operating
# WSO2_DB_NAME - The DB name
# WSO2_DB_USERNAME - The username to access the DB
# WSO2_DB_PASSWORD - The password to access the DB
#
# These values will be used to configure the following WSO2 configuration files.
#
# carbon.xml
# master-datasources.xml
# bps-datasources.xml
#
# At the end of the configuration, the WSO2 server will be started.


CARBON_HOME="/opt/wso2ei-6.1.1/"
conf_root=$(pwd)

# Validate 
if [ ! -d $conf_root/conf/$WSO2_SERVER_RUNTIME ]; then
  echo "ERROR: Unsupported WSO2_SERVER_RUNTIME: ${WSO2_SERVER_RUNTIME}."
  exit 1
fi

if [[ "${WSO2_SERVER_RUNTIME}" == "integrator" ]]; then
  CONF_HOME="${CARBON_HOME}/conf/"
else
  CONF_HOME="${CARBON_HOME}/wso2/${WSO2_SERVER_RUNTIME}/conf/"
fi

echo "Copying configuration files..."
cp -r "conf/${WSO2_SERVER_RUNTIME}/*" $CONF_HOME

echo "Making configuration changes..."
find $CONF_HOME -type f -exec sed -i "s|WSO2_HOSTNAME|${WSO2_HOSTNAME}|" {} \;
find $CONF_HOME -type f -exec sed -i "s|WSO2_DB_HOSTNAME|${WSO2_DB_HOSTNAME}|" {} \;
find $CONF_HOME -type f -exec sed -i "s|WSO2_DB_PORT|${WSO2_DB_PORT}|" {} \;
find $CONF_HOME -type f -exec sed -i "s|WSO2_DB_NAME|${WSO2_DB_NAME}|" {} \;
find $CONF_HOME -type f -exec sed -i "s|WSO2_DB_USERNAME|${WSO2_DB_USERNAME}|" {} \;
find $CONF_HOME -type f -exec sed -i "s|WSO2_DB_PASSWORD|${WSO2_DB_PASSWORD}|" {} \;
# sed -i "s|WSO2_HOSTNAME|${WSO2_HOSTNAME}|" $CONF_HOME/carbon.xml

if [ -d files ]; then
  echo "Copying files..."
  if [ -z "$(ls files/)" ]; then
     echo "No files were found inside ${conf_root}/files/ folder. Skipping file copy..."
  else
     cp -r files/* $CARBON_HOME/.
  fi
fi

echo "Starting WSO2 Server..."
bash $CARBON_HOME/bin/$WSO2_SERVER_RUNTIME.sh
