# Craig-O-Tron WordPress 8000! #

This lets Craig use Vagrant and Puppet to set up VirtualBox for WordPress development.

## Installation

    cd ~/Source
    git clone https://github.com/vandahm/craigotron.git wordpress
    cd wordpress
    vagrant up

## Adding WordPress sites ##

    cd ~/Source/wordpress
    bin/new rockthevogt.dev # Or whatever your site will be called.
    vagrant provision

## MySQL Credentials ##

Username and password are always the same:

   * **Username:** `vagrant`
   * **Password:** `vagrant`

If your sitename is `rockthevogt.dev` or `www.rockthevogt.dev`, then your database name is `rockthevogt`.
