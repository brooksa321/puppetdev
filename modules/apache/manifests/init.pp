include base

class apache {

   ###APACHE INSTALL###
   ####APR AND APR-UTIL COMPILED FROM SOURCE DUE TO INCOMPATIBLE VERSION IN YUM###
   #Install apr
   puppi::netinstall{ "apr":
      url                 => 'http://apache.mirrors.ionfish.org//apr/apr-1.5.2.tar.gz',
      destination_dir     => '/usr4',
      postextract_command => '/usr4/apr-1.5.2/configure --prefix=/usr4/apr/; make ; make install',
   } -> #and then
   
   #Install apr-util
   puppi::netinstall{ "apr-util":
      url                 => 'http://apache.mirrors.ionfish.org//apr/apr-util-1.5.4.tar.gz',
      destination_dir     => '/usr4',
      postextract_command => '/usr4/apr-util-1.5.4/configure --prefix=/usr4/apr-util/ --with-apr=/usr4/apr/; make ; make install',
   } -> #and then

   #Install pcre
   puppi::netinstall{ "pcre":
      url                 => 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz',
      destination_dir     => '/usr4',
      postextract_command => '/usr4/pcre-8.38/configure --prefix=/usr4/pcre/; make ; make install',
   } -> #and then

   #Install httpd
   puppi::netinstall{ "httpd":
      url                 => 'http://mirror.reverse.net/pub/apache//httpd/httpd-2.4.18.tar.gz',
      destination_dir     => '/usr4',
      postextract_command => '/usr4/httpd-2.4.18/configure --prefix=/usr1/apache/ --with-apr=/usr4/apr/ --with-apr-util=/usr4/apr-util/ --with-pcre=/usr4/pcre; make ; make install',      
   } -> #and then

   #Install mod_perl
   puppi::netinstall{ "mod_perl":
     url                 => 'http://www-eu.apache.org/dist/perl/mod_perl-2.0.9.tar.gz',
     destination_dir     => '/usr4',
     postextract_command => '/usr/bin/perl /usr4/mod_perl-2.0.9/Makefile.PL MP_APXS=/usr1/apache/bin/apxs; make ; make install',
   } -> #and then

   #Set httpd to start on boot
   exec { 'httpd on boot':
      command => '/bin/echo /usr1/apache/bin/httpd -k start >> /etc/rc.local',
      unless  => '/bin/grep -c httpd /etc/rc.local',
      timeout => 600 ,
   } -> #and then

   #Replace Default httpd.conf
   file { '/usr1/apache/conf/httpd.conf':
      ensure => present,
      source => 'puppet:///modules/apache/httpd.conf',
      owner  => root,
      group  => root,
      mode   => '0644',
   } -> #and then

   #Symlink logs to /usr3
   file {'/usr3/logs/apache/logs':
     ensure  => symlink,
     target  => '/usr1/apache/logs',
     require => File[$server_dirs],
   } -> #and then

   #Restarts httpd on changes in config file
   exec { "reload-apache":
      command     => "/usr1/apache/bin/httpd -k restart",
      subscribe   => File["/usr1/apache/conf/httpd.conf"],
      refreshonly => true,
   }
}