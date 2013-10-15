puppet-lianas-of-guyana.org
===================

Puppet module to install 

For more information using this tool: 

Parameters
-------------
All parameters are read from hiera

Classes
-------------
- vsftpd
- apache
- duplicity

Dependencies
-------------
- thias/puppet-vsftpd Release 0.2.0
- apache2 module from puppetlabs
- Jimdo/puppet-duplicity

Examples
-------------
Hiera yaml
dest_id and dest_key are API keys for amazon s3 account
```
lianasofguyana:
  www.lianas-of-guyana.org:
    serveraliases: 'lianas-org-guyana.org'
    docroot: /var/www/lianasofguyana
    port: 80
    ssl: no
    serveradmin: aut@naturalis.nl
lianasofguyana::backup: true
lianasofguyana::backuphour: 3
lianasofguyana::backupminute: 3
lianasofguyana::backupdir: '/tmp/backups'
lianasofguyana::dest_id: 'provider_id'
lianasofguyana::dest_key: 'provider_key'
lianasofguyana::bucket: 'lianasofguyana'
lianasofguyana::autorestore: true
lianasofguyana::ftpserver: true
lianasofguyana::ftpusers:
  wwwlianas-of-guyana:
    comment: "FTP User"
    home: "/var/www/lianasofguyana"
    password: "$1$A6ZSNQVG$hnRIP/LfJQNRyuEAwmssK/"

```
Puppet code
```
class { lianasofguyana: }
```
Result
-------------
Working webserver, restored from latest backup version. with daily backup and FTP server access.

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS
- 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

