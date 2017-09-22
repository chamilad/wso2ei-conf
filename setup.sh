#!/bin/bash

# This script should act as the init script to a starting instance
# that should be configured. The following environment variables
# should be provided (via user-data or any other prefered method).
#
#
# WSO2_SERVER_RUNTIME     - The runtime id of the server. Currently supports either
#                           "business-process" or "integrator"
#
#
# WSO2_CARBON_HOME        - The location where the WSO2 Server is located
# WSO2_SERVER_ARGS        - Arguments to pass to the WSO2 Server starter script
#
#
# WSO2_REG_DB_HOSTNAME    - The hostname of the registry DB server
# WSO2_REG_DB_PORT        - The port at which the registry DB server is operating
# WSO2_REG_DB_NAME        - The registry DB name
# WSO2_REG_DB_USERNAME    - The username to access the registry DB
# WSO2_REG_DB_PASSWORD    - The password to access the registry DB
# WSO2_REG_DB_PROTOCOL    - The JDBC URL Protocol to use for the registry
#                           DB. This would use a default value of "mysql"
# WSO2_REG_DB_DRIVER_NAME - The JDBC driver name to be used in the datasources
#                           for the registry DB. This would use a default value
#                           of "com.mysql.jdbc.Driver"
#
#
# WSO2_BPS_DB_HOSTNAME    - The hostname of the BPS DB server
# WSO2_BPS_DB_PORT        - The port at which the BPS DB server is operating
# WSO2_BPS_DB_NAME        - The BPS DB name
# WSO2_BPS_DB_USERNAME    - The username to access the BPS DB
# WSO2_BPS_DB_PASSWORD    - The password to access the BPS DB
# WSO2_BPS_DB_PROTOCOL    - The JDBC URL Protocol to use for the BPS DB. This
#                           would use a default value of "mysql"
# WSO2_BPS_DB_DRIVER_NAME - The JDBC driver name to be used in the datasources
#                           for the BPS DB. This would use a default value of
#                           "com.mysql.jdbc.Driver"
#
#
# WSO2_HOSTNAME           - The hostname to be used in the WSO2 servers
# WSO2_HTTP_PROXY_PORT    - The proxyPort value to be used for the HTTP port
# WSO2_HTTPS_PROXY_PORT   - The proxyPort value to be used for the HTTPS port
#
#
# These values will be used to configure the following WSO2 configuration files.
#
# carbon.xml
# master-datasources.xml
# bps-datasources.xml
# activiti-datasources.xml
#
# At the end of the configuration, the WSO2 server will be started.


if [ -z $WSO2_SERVER_RUNTIME ]; then
  echo "ERROR: Please specify WSO2_SERVER_RUNTIME environment variable."
  exit 1
fi

if [ -z $WSO2_CARBON_HOME ]; then
  echo "ERROR: Please specify WSO2_CARBON_HOME environment variable."
  exit 1
fi

if [ -z $WSO2_HOSTNAME ]; then
  echo "ERROR: Please specify WSO2_HOSTNAME environment variable."
  exit 1
fi

if [ -z $WSO2_REG_DB_HOSTNAME ]; then
  echo "ERROR: Please specify WSO2_REG_DB_HOSTNAME environment variable."
  exit 1
fi

if [ -z $WSO2_REG_DB_PORT ]; then
  echo "ERROR: Please specify WSO2_REG_DB_PORT environment variable."
  exit 1
fi

if [ -z $WSO2_REG_DB_USERNAME ]; then
  echo "ERROR: Please specify WSO2_REG_DB_USERNAME environment variable."
  exit 1
fi

if [ -z $WSO2_REG_DB_PASSWORD ]; then
  echo "ERROR: Please specify WSO2_REG_DB_PASSWORD environment variable."
  exit 1
fi

if [ -z $WSO2_REG_DB_DRIVER_NAME ]; then
  echo "WARN: WSO2_REG_DB_DRIVER_NAME environment variable not found. Using the default value \"com.mysql.jdbc.Driver\"."
  WSO2_REG_DB_DRIVER_NAME="com.mysql.jdbc.Driver"
fi

if [ -z $WSO2_REG_DB_PROTOCOL ]; then
  echo "WARN: WSO2_REG_DB_PROTOCOL environment variable not found. Using the default value \"mysql\"."
  WSO2_REG_DB_PROTOCOL="mysql"
fi

# Runtime specific configs
if [[ "${WSO2_SERVER_RUNTIME}" == "business-process" ]]; then
  if [ -z $WSO2_BPS_DB_HOSTNAME ]; then
    echo "ERROR: Please specify WSO2_BPS_DB_HOSTNAME environment variable."
    exit 1
  fi

  if [ -z $WSO2_BPS_DB_PORT ]; then
    echo "ERROR: Please specify WSO2_BPS_DB_PORT environment variable."
    exit 1
  fi

  if [ -z $WSO2_BPS_DB_USERNAME ]; then
    echo "ERROR: Please specify WSO2_BPS_DB_USERNAME environment variable."
    exit 1
  fi

  if [ -z $WSO2_BPS_DB_PASSWORD ]; then
    echo "ERROR: Please specify WSO2_BPS_DB_PASSWORD environment variable."
    exit 1
  fi

  if [ -z $WSO2_BPS_DB_DRIVER_NAME ]; then
    echo "WARN: WSO2_BPS_DB_DRIVER_NAME environment variable not found. Using the default value \"com.mysql.jdbc.Driver\"."
    WSO2_BPS_DB_DRIVER_NAME="com.mysql.jdbc.Driver"
  fi

  if [ -z $WSO2_BPS_DB_PROTOCOL ]; then
    echo "WARN: WSO2_BPS_DB_PROTOCOL environment variable not found. Using the default value \"mysql\"."
    WSO2_BPS_DB_PROTOCOL="mysql"
  fi
fi

CARBON_HOME="${WSO2_CARBON_HOME}"
setup_root=$(pwd)

# Validate
if [ ! -d $setup_root/conf/$WSO2_SERVER_RUNTIME ]; then
  echo "ERROR: Unsupported WSO2_SERVER_RUNTIME: ${WSO2_SERVER_RUNTIME}."
  exit 1
fi

if [[ "${WSO2_SERVER_RUNTIME}" == "integrator" ]]; then
  CONF_HOME="${CARBON_HOME}/"
else
  CONF_HOME="${CARBON_HOME}/wso2/${WSO2_SERVER_RUNTIME}/"
fi

pushd $CONF_HOME > /dev/null 2>&1
  echo "Copying template configurations..."
  mv conf conf.bck
  cp -r "${setup_root}/conf/${WSO2_SERVER_RUNTIME}/" ./
  mv $WSO2_SERVER_RUNTIME conf

  echo "Making common configuration changes..."
  find . -type f -exec sed -i "s|WSO2_HOSTNAME|${WSO2_HOSTNAME}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_HOSTNAME|${WSO2_REG_DB_HOSTNAME}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_PORT|${WSO2_REG_DB_PORT}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_NAME|${WSO2_REG_DB_NAME}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_PROTOCOL|${WSO2_REG_DB_PROTOCOL}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_DRIVER_NAME|${WSO2_REG_DB_DRIVER_NAME}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_USERNAME|${WSO2_REG_DB_USERNAME}|" {} \;
  find . -type f -exec sed -i "s|WSO2_REG_DB_PASSWORD|${WSO2_REG_DB_PASSWORD}|" {} \;

  if [ ! -z $WSO2_HTTP_PROXY_PORT ]; then
    sed -i "/port=\"9763\"/a \
    proxyPort=\"${WSO2_HTTP_PROXY_PORT}\"" ./conf/tomcat/catalina-server.xml
  fi

  if [ ! -z $WSO2_HTTPS_PROXY_PORT ]; then
    sed -i "/port=\"9443\"/a \
    proxyPort=\"${WSO2_HTTPS_PROXY_PORT}\"" ./conf/tomcat/catalina-server.xml
  fi

  if [[ "${WSO2_SERVER_RUNTIME}" == "business-process" ]]; then
    echo "Making BPS specific configuration changes..."
    find . -type f -exec sed -i "s|WSO2_BPS_DB_HOSTNAME|${WSO2_BPS_DB_HOSTNAME}|" {} \;
    find . -type f -exec sed -i "s|WSO2_BPS_DB_PORT|${WSO2_BPS_DB_PORT}|" {} \;
    find . -type f -exec sed -i "s|WSO2_BPS_DB_NAME|${WSO2_BPS_DB_NAME}|" {} \;
    find . -type f -exec sed -i "s|WSO2_BPS_DB_PROTOCOL|${WSO2_BPS_DB_PROTOCOL}|" {} \;
    find . -type f -exec sed -i "s|WSO2_BPS_DB_DRIVER_NAME|${WSO2_BPS_DB_DRIVER_NAME}|" {} \;
    find . -type f -exec sed -i "s|WSO2_BPS_DB_USERNAME|${WSO2_BPS_DB_USERNAME}|" {} \;
    find . -type f -exec sed -i "s|WSO2_BPS_DB_PASSWORD|${WSO2_BPS_DB_PASSWORD}|" {} \;
  fi
popd > /dev/null 2>&1

if [ -d files ]; then
  echo "Copying files..."
  pushd "${setup_root}/files/common/" > /dev/null 2>&1
    cp -r ./ $CARBON_HOME/
  popd > /dev/null 2>&1
  pushd "${setup_root}/files/${WSO2_SERVER_RUNTIME}/" > /dev/null 2>&1
    cp -r ./ $CARBON_HOME/
  popd > /dev/null 2>&1
  pushd $CARBON_HOME > /dev/null 2>&1
    find . -name ".gitkeep" | xargs rm -rf
  popd > /dev/null 2>&1
fi

echo "Starting WSO2 Server..."
bash $CARBON_HOME/bin/$WSO2_SERVER_RUNTIME.sh $WSO2_SERVER_ARGS
