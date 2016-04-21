include base

class solr {
   ###SOLR INSTALL###
   #Install solr
   puppi::netinstall{ "solr":
      url                 => 'http://archive.apache.org/dist/lucene/solr/5.4.1/solr-5.4.1.zip',
	   destination_dir     => '/usr1',
      postextract_command => 'mv /usr1/solr-5.4.0 /usr1/solr && /usr1/solr/bin/install_solr_service.sh',
   } -> #and then
   
   #Set solr to start on boot
   exec { 'solr on boot':
      command => '/bin/echo /usr1/solr/bin/solr start -p 8080 >> /etc/rc.local',
      unless  => '/bin/grep -c solr /etc/rc.local',
      timeout => 600 ,
   } -> #and then

   #Replace Default httpd.conf
   file { '/usr1/solr/server/solr/solr.xml':
      ensure => present,
#      source => 'puppet:///modules/demo/solr.xml',
      owner  => root,
      group  => root,
      mode   => '0644',
   } -> #and then

   file { '/usr3/logs/solr':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File[$server_dirs],
    }

   #Symlink logs to /usr3
   file {'/usr3/logs/solr/logs':
     ensure  => symlink,
     target  => '/usr1/solr/server/logs',
     require => File['/usr3/logs/solr'],
   } -> #and then

   #Restarts solr on changes in config file
   exec { "reload-solr":
      command     => "/usr1/solr/bin/solr stop -p 8080 && /usr1/solr/bin/solr start -p 8080",
      subscribe   => File["/usr1/solr/server/solr/solr.xml"],
      refreshonly => true,
   }
}