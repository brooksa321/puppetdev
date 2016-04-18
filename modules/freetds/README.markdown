# FreeTDS
[![Build Status](https://travis-ci.org/NERC-CEH/puppet-freetds.svg?branch=master)](https://travis-ci.org/NERC-CEH/puppet-freetds)
## Overview

This is the freetds module. It installs the freetds driver and manages database connections which use it

## Module Description

[FreeTDS](www.freetds.org) is a set of libraries for Unix and Linux which allow applications to natively talk to Microsoft SQL Server and Sybase databases. Anything which comunicates over the [Tabular Data Stream](http://en.wikipedia.org/wiki/Tabular_Data_Stream) protocol.

This module will install the freetds packages and manage odbcinst.ini file to register the driver. You can also specify the hostnames of database source which you which to connect to using freetds. This will create a system wide DSN which you can use during in your applications connection strings for database setups.

## Setup

### What FreeTDS affects

* Installs the freetds-dev, freetds-bin and tdsodbc packages
* Installs unixodbc and unixodbc-dev pacakges
* Manages the /etc/freetds/freetds.conf file
* Manages the /etc/odbcinst.ini file
* Manages database entries in /etc/odbc.ini

## Usage

Install the FreeTDS driver and register it

    include freetds

Manage a dsn entry for for database.myorganisation.com

    freetds::db { 'DatabaseDSN' :
      host => 'database.myorganisation.com',
    }

## Dependencies

This module requires puppetlabs/inifile for managing tds + odbc configuration files

## Limitations

This module has been tested on ubuntu (12.04, 14.04) lts

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk
