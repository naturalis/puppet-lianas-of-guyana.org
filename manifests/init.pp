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
  $backup = false,
  $backuphour = 1,
  $backupminute = 1,
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
  $coderoot = '/var/www/lianasofguyana',
  $webdirs = ['/var/www/lianasofguyana'],
  $ftpserver = false,
  $ftpbanner = 'lianas of guyana FTP server',
  $ftpusers = undef,
) {

  include concat::setup

  class { 'apache':
    default_mods => true,
    mpm_module => 'prefork',
  }

  include apache::mod::php

  # Create all virtual hosts from hiera
  class { 'lianasofguyana::instances': }

  # Add hostname to /etc/hosts, svn checkout requires a resolvable hostname
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [ $hostname ],
  }

  file { 'backupdir':
    ensure => 'directory',
    path   => $backupdir,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  group { 'webusers':
    ensure	=> present,
  }


  file { $webdirs:
    ensure      => 'directory',
    mode        => '0775',
    group       => 'webusers',
    owner       => 'root',
    require     => Group['webusers'],
  }



  if $ftpserver == true {
    class { 'lianasofguyana::ftpserver':
      ftpd_banner        => $ftpd_banner,
      ftpuserrootdirs    => ['/var','/var/www','/var/www/lianasofguyana'],
      ftpusers		 => $ftpusers,
    }
  }

  if $backup == true {
    class { 'lianasofguyana::backup':
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

  class { 'lianasofguyana::restore':
    version     => $restoreversion,
    bucket      => $bucket,
    dest_id     => $dest_id,
    dest_key    => $dest_key,
    cloud       => $cloud,
    pubkey_id   => $pubkey_id,
  }
}
