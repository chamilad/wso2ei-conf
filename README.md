# WSO2 EI 6.1.1 Bootstrap script

This script configures different runtimes in WSO2 Enterprise Integrator 6.1.1.

## Supported Runtimes
1. WSO2 EI Integrator
2. WSO2 EI BPS

## How To
The configuration options are expected to be set as environment variables.

1. WSO2_SERVER_RUNTIME - The runtime id of the server. Currently supports either "business-process" or "integrator"
2. WSO2_CARBON_HOME - The location where the WSO2 Server is located
3. WSO2_HOSTNAME - The hostname to be used in the WSO2 servers
4. WSO2_DB_HOSTNAME - The hostname of the DB server
5. WSO2_DB_PORT - The port at which the DB server is operating
6. WSO2_DB_NAME - The DB name
7. WSO2_DB_PROTOCOL - The JDBC URL Protocol to use. This would use a default value of "mysql"
8. WSO2_DB_DRIVER_NAME - The JDBC driver name to be used in the datasources. This would use a default value of "com.mysql.jdbc.Driver"
9. WSO2_DB_USERNAME - The username to access the DB
10. WSO2_DB_PASSWORD - The password to access the DB
11. WSO2_SERVER_ARGS - Arguments to pass to the WSO2 Server starter script


```bash
# Make a copy of the provided sample configuration file conf.sh.sample as conf.sh.
cp conf.sh.sample conf.sh
# Add the properites as needed. A sample set of values can be as follows.
# export WSO2_SERVER_RUNTIME="business-process"
# export WSO2_CARBON_HOME="/home/chamilad/dev/wso2ei-6.1.1"
# export WSO2_HOSTNAME="localhost"
# export WSO2_DB_HOSTNAME="localhost"
# export WSO2_DB_PORT="3306"
# export WSO2_DB_NAME="WSO2BPS_DB"
# export WSO2_DB_USERNAME="root"
# export WSO2_DB_PASSWORD="toor"
# export WSO2_SERVER_ARGS="-Dsetup"
vi conf.sh
# Source the conf.sh.
source conf.sh
# Run setup.sh file. This would start the WSO2 Server at the above specified location.
bash setup.sh
```

## Copying Files
Create the directory structure inside the `files/<runtime>` folder, as the file should be copied to the destination, relative to `CARBON_HOME`. For example, if the MySQL JDBC driver should be copied inside `$CARBON_HOME/lib` folder for the business-process runtim, then the folder structure inside `files` folder should be as follows.

```
files
├── business-process
│   ├── .gitkeep
│   └── lib
|     └──mysql-connector-java-5.1.39-bin.jar
├── common
│   └── .gitkeep
└── integrator
    └── .gitkeep
```

Files copied in the above manner in to the `common` folder will be copied into every runtime. If files exist with the same file name in both the `common` folder and the runtime specific folder, the file in the runtime specific folder would be used.
