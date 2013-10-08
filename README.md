puppet-lianas-of-guyana.org
===================

Puppet module to install 

For more information using this tool: 

Parameters
-------------
All parameters are read from hiera

Classes
-------------
- 

Dependencies
-------------
- 

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
lianasofguyana::backmeup: true
lianasofguyana::backuphour: 3
lianasofguyana::backupminute: 3
lianasofguyana::backupdir: '/tmp/backups'
lianasofguyana::dest_id: 'provider_id'
lianasofguyana::dest_key: 'provider_key'
lianasofguyana::bucket: 'lianasofguyana'
lianasofguyana::autorestore: true
lianasofguyana::restoreversion: 'latest'
lianasofguyana::coderoot: '/var/www/lianasofguyana'      
```
Puppet code
```
class { lianasofguyana: }
```
Result
-------------
Working webserver, restored from latest backup version. with daily backup. 

Limitations
-------------
This module has been built on and tested against Puppet ... and higher.

The module has been tested on:
- 
- 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

