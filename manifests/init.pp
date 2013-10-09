# == Class: lianasofguyana
#
# Full description of class lianas-of-guyana.org here.
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
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { lianasofguyana:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name : Hugo van Duijn <hugo,vanduijn@naturalis.nl>
#
# === Copyright
#
# 
#
class lianasofguyana (
  $backmeup = false,
  $backuphour = 1,
  $backupminute = 1,
  $autorestore = true,
  $version = 'latest',
  $backupdir = '/tmp/backups',
  $restore_directory = '/tmp/restore',
  $bucket = 'lianasofguyana',
  $dest_id = undef,
  $dest_key = undef,
  $cloud = 's3',
  $pubkey_id = undef,
  $full_if_older_than = undef,
  $remove_older_than = undef,
#  $coderepo = 'svn://dev2.etibioinformatics.nl/linnaeus_ng/trunk',
#  $repotype = 'svn',
  $coderoot = '/var/www/lianasofguyana',
  $webdirs = ['/var/www/lianasofguyana',
              '/var/www/lianasofguyana/admin',
              '/var/www/lianasofguyana/templates'],
  $rwwebdirs = ['/var/www/lianasofguyana/log/',
                '/var/www/lianasofguyana/cache'],
) {

  include concat::setup
  include mysql::php

  class { 'apache':
    default_mods => true,
    mpm_module => 'prefork',
  }

  include apache::mod::php

  # Create all virtual hosts from hiera
  class { 'lianasofguyana::instances': }

  # Create mysql server
  include mysql::server

  # Add hostname to /etc/hosts, svn checkout requires a resolvable hostname
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [ $hostname ],
  }

#  package { 'subversion':
#    ensure => installed,
#  }

#  vcsrepo { $coderoot:
#    ensure   => latest,
#    provider => $repotype,
#    source   => $coderepo,
#    require  => [ Package['subversion'],Host['localhost'] ],
# }

  file { 'backupdir':
    ensure => 'directory',
    path   => $backupdir,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  file { $webdirs:
    ensure      => 'directory',
    mode        => '0755',
#    require     => Vcsrepo[$coderoot],
  }

  file { $rwwebdirs:
    ensure      => 'directory',
    mode        => '0777',
    require     => File[$webdirs],
  }
                                                                                                                                                                                                       
  if ($backmeup == true) or ($autorestore == true) {
    class { 'mysql::backup':                                                                                                                                                                                           
      backupuser     => 'myuser',                                                                                                                                                                                      
      backuppassword => 'mypassword',                                                                                                                                                                                  
      backupdir      => $backupdir,                                                                                                                                                                                    
    }     
  }

  if $backmeup == true {
    class { 'lianasofguyana::backmeup':
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $backupdir,
      bucket             => $bucket,
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
      full_if_older_than => $full_if_older_than,
      remove_older_than  => $remove_older_than,
    }
  }

  if $autorestore == true {
    class { 'lianasofguyana::restore':
      version     => $restoreversion,
      bucket      => $bucket,
      dest_id     => $dest_id,
      dest_key    => $dest_key,
      cloud       => $cloud,
      pubkey_id   => $pubkey_id,
    }
  }

}
