class base {

	yum::group { 'Development Tools':
		ensure => present,
	}

	#Setup Directory Structure
	$server_dirs = [ '/usr1', '/usr2', '/usr3', '/usr4'
					'/usr4/logs', '/usr4/logs/apache',
                      '/usr4/logs/solr']

	file { $server_dirs:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
}