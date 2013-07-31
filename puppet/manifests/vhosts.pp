apache::vhost{'rockthevogt.dev':
    server_name => 'rockthevogt.dev',
    serveraliases => ['www.rockthevogt.dev'],
    docroot => '/var/www/rockthevogt.dev',
    port    => '80',
    env_variables => [],
    priority      => '2',
}

mysql::db {'rockthevogt':
  grant    => [
    'ALL'
  ],
  user     => 'vagrant',
  password => 'vagrant',
  host     => 'localhost',
  charset  => 'utf8',
  require  => Class['mysql::server'],
}
