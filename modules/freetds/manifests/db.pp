# == Define: freetds::db
#
# This is the freetds db resource type, it will register a database as a System
# Data Source Name and set that to use freetds driver
#
# === Parameters
# [*host*] the hostname of the database which you which to connect to
# [*dsn*] the Data Source Name which you want to register on this system. 
#   Defaults to the title of this defined resource
# [*manage_odbc*] If we should manage the the datasource in /etc/odbc.ini
#   Defaults to the manage::unixodbc setting of the init class
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
define freetds::db (
  $host,
  $dsn         = $title,
  $manage_odbc = $freetds::manage_unixodbc
){
  if $manage_odbc {
    # Define connections to database
    ini_setting { "ODBC Driver to ${dsn}" :
      ensure  => present,
      path    => '/etc/odbc.ini',
      section => $dsn,
      setting => 'Driver',
      value   => 'FreeTDS',
    }

    ini_setting { "ODBC Servername to ${dsn}" :
      ensure  => present,
      path    => '/etc/odbc.ini',
      section => $dsn,
      setting => 'Servername',
      value   => $dsn,
    }
  }

  ini_setting { "FreeTDS connection to ${dsn} database" :
    ensure  => present,
    path    => '/etc/freetds/freetds.conf',
    section => $dsn,
    setting => 'host',
    value   => $host,
  }
}
