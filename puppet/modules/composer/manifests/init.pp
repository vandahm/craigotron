# Class: composer
#
# Installs Composer
class composer (
    $install_location = '/usr/bin',
    $filename         = 'composer'
) {
  $composer_location = $install_location
  $composer_filename = $filename

  exec { "composer-${install_location}":
    command => "curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/vagrant && mv /home/vagrant/composer.phar ${install_location}/${filename}",
    path    => ['/usr/bin' , '/bin'],
    onlyif  => "test ! `${install_location}/${filename}`",
  }
}
