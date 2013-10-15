# Parameters:
#


class lianasofguyana::ftpserver (
  $ftpd_banner 		= undef,
  $ftpuserrootdirs 	= undef,
  $ftpusers 		= undef,
  $anonymous_enable 	= 'NO',
  $write_enable		= 'YES',
  $chroot_local_user 	= 'YES',
  $chroot_list_enable   = 'YES',
  $userlist_enable	= 'NO',
  $chroot_list_file     = '/etc/vsftpd.chroot_list', 
  $pasv_min_port     	= '10000',
  $pasv_max_port     	= '10200',

)
{
  notify {'FTP Server enabled':}

  create_resources('lianasofguyana::ftpusers', hiera('lianasofguyana::ftpusers', []))

  file { $chroot_list_file:
    content	=> template('lianasofguyana/vsftpd.chroot_list.erb'),
  }

  group { 'ftpusers':
    ensure	=> present,
  }

  class { 'vsftpd':
    anonymous_enable  => $anonymous_enable,
    write_enable      => $write_enable,
    ftpd_banner       => $ftpd_banner,
    chroot_local_user => $chroot_local_user,
    chroot_list_enable=> $chroot_list_enable,
    chroot_list_file  => $chroot_list_file, 
    userlist_enable   => $userlist_enable,
    pasv_min_port     => $pasv_min_port,
    pasv_max_port     => $pasv_max_port,
  }


}

