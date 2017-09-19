# WSO2 EI 6.1.1 Bootstrap script

This script configures different runtimes in WSO2 Enterprise Integrator 6.1.1.

## Supported Runtimes
1. WSO2 EI Integrator
2. WSO2 EI BPS

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
