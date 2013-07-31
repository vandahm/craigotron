group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

    apt::key { '4F4EA0AAE5267A6C': }

#apt::ppa { 'ppa:ondrej/php5':
#  require => Apt::Key['4F4EA0AAE5267A6C']
#}

file { '/home/vagrant/.bash_aliases':
  ensure => 'present',
  source => 'puppet:///modules/puphpet/dot/.bash_aliases',
}

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core'
  ]:
  ensure  => 'installed',
}

class { 'apache': }

apache::dotconf { 'custom':
  content => 'EnableSendfile Off',
}

apache::module { 'rewrite': }

apache::vhost { 'wpvagrant.dev':
  server_name   => 'wpvagrant.dev',
  serveraliases => [
    'www.wpvagrant.dev'
  ],
  docroot       => '/var/www/default',
  port          => '80',
  env_variables => [
],
  priority      => '1',
}

# Apache should run under vagrant's username
file_line { 'apache_run_user':
  path => '/etc/apache2/envvars',
  line => 'export APACHE_RUN_USER=vagrant',
  match => 'export APACHE_RUN_USER',
  require => Class['apache'],
}
file_line { 'apache_run_group':
  path => '/etc/apache2/envvars',
  line => 'export APACHE_RUN_GROUP=vagrant',
  match => 'export APACHE_RUN_GROUP',
  require => Class['apache'],
}

# Delete the old stuff, just to keep it clean


class { 'php':
  service             => 'apache',
  service_autorestart => false,
  module_prefix       => '',
}

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

/*php::pecl::module { 'xhprof':
  use_package     => false,
  preferred_state => 'beta',
}

apache::vhost { 'xhprof':
  server_name => 'xhprof',
  docroot     => '/var/www/xhprof/xhprof_html',
  port        => 80,
  priority    => '1',
  require     => Php::Pecl::Module['xhprof']
}*/


class { 'xdebug':
  service => 'apache',
}

class { 'composer':
  require => Package['php5', 'curl'],
}

#puphpet::ini { 'xdebug':
#  value   => [
#    'xdebug.default_enable = 1',
#    'xdebug.remote_autostart = 0',
#    'xdebug.remote_connect_back = 1',
#    'xdebug.remote_enable = 1',
#    'xdebug.remote_handler = "dbgp"',
#    'xdebug.remote_port = 9000'
#  ],
#  ini     => '/etc/php5/conf.d/zzz_xdebug.ini',
#  notify  => Service['apache'],
#  require => Class['php'],
#}

#puphpet::ini { 'php':
#  value   => [
#    'date.timezone = "America/Chicago"'
#  ],
#  ini     => '/etc/php5/conf.d/zzz_php.ini',
#  notify  => Service['apache'],
#  require => Class['php'],
#}

#puphpet::ini { 'custom':
#  value   => [
#    'display_errors = On',
#    'error_reporting = -1'
#  ],
#  ini     => '/etc/php5/conf.d/zzz_custom.ini',
#  notify  => Service['apache'],
#  require => Class['php'],
#}


class { 'mysql::server':
  config_hash   => { 'root_password' => 'vagrant' }
}

mysql::db { 'vagrant':
  grant    => [
    'ALL'
  ],
  user     => 'vagrant',
  password => 'vagrant',
  host     => 'localhost',
  charset  => 'utf8',
  require  => Class['mysql::server'],
}

import "vhosts.pp"
