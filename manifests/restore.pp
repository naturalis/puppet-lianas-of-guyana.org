# Parameters:
#
class lianasofguyana::restore (
  $version = undef,
  $restore_directory = '/tmp/restore/',
  $bucket = undef,
  $folder = undef,
  $dest_id = undef,
  $dest_key = undef,
  $cloud = undef,
  $pubkey_id = undef,
)
{
  notify {'Restore enabled':}

  package { 'unzip':
    ensure => present,
  }

  duplicity::restore { 'data':
    directory      => $restore_directory,
    bucket         => $bucket,
    folder	   => $folder,
    dest_id        => $dest_id,
    dest_key       => $dest_key,
    cloud          => $cloud,
    pubkey_id      => $pubkey_id,
    post_command   => '/usr/local/sbin/filerestore.sh',
  }

  file { "/usr/local/sbin/filerestore.sh":
    content => template('lianasofguyana/filerestore.sh.erb'),
    mode    => '0700',
  }

  exec { 'duplicityrestore.sh':
    command => '/bin/bash /usr/local/sbin/duplicityrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => [Package['duplicity'],File['/usr/local/sbin/duplicityrestore.sh','/usr/local/sbin/filerestore.sh']],
  }

  exec { 'filerestore.sh':
    command => '/bin/bash /usr/local/sbin/filerestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => Exec['duplicityrestore.sh'],
  }

}

