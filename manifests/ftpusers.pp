# == Class: lianasofguyana::ftpusers
#
#Installs users from hiera.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { lianasofguyana::ftpusers: }
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
# === Copyright
#
# Copyright 2013 Naturalis, unless otherwise noted.
#
define lianasofguyana::ftpusers(
  $comment = '',
  $username = $title,
  $groups = 'ftpusers',
  $home = undef,
  $password = undef,
) {

 exec { $username:
    command 	=> "echo $username >> /etc/vsftpd.chroot_list",
    path 	=> "/usr/local/bin/:/bin/",
    require 	=> File['/etc/vsftpd.chroot_list'],
  }

#  file { $home:
#    ensure	=> 'directory',
#    owner	=> $title,
#    mode	=> 0770,
# }

  user { $username:
    ensure      => present,
    groups      => $groups,
    home	=> $home,
    password	=> $password,
    comment     => $comment,
    require	=> Group[$groups],
  }
}
