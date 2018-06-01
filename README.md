# Puppet advanced facts

## Description

Deploy some facts to gather configuration data from already installed services (not managed by puppet).
This way you can perform puppet actions for services installed on an agent even though they are not managed by puppet itself.
For example you have an Apache2 webserver with various vhosts installed, but those vhosts are not deployed via puppet.
Now you would like to gather all logfiles from all those vhosts and do some crazy stuff with it, how?

This module will collect all those relevant informations from various software (if installed) and will make them availbale as facts.

## Facts

* Apache2 (Apache2 vhost facts)
  - apache.vhosts[].name - Hostname from ServerName
  - apache.vhosts[].port - Port
  - apache.vhosts[].ssl - Will be true if ssl is enabled on this vhost
  - apache.vhosts[].access_log - Path to the CustomLog
  - apache.vhosts[].error_log - Path to the ErrorLog
* APT packages/Windows packages
  - packages[] - All installed deb packages with version as value and package name as key or on windows all installed apps
* Elasticsearch
  - elasticsearch.bind - Bind interface
  - elasticsearch.port - Port
* fstab
  - fstab[],device - Device
  - fstab[].mount - Mountpoint
  - fstab[].filesystem - Filesystem
  - fstab[].options - Mount options
  - fstab[].freq - Needed by dump
  - fstab[].passno - fsck at boot time
  - fstab[].devicelabel - Device label (if set)
* MongoDB
  - mongodb.dbpath - Path to datastore
  - mongodb.logpath - Path to logfile
  - mongodb.replset - Replset name
  - mongodb.bind_ip - Bind interface
* MySQL (Maria or Percona)
  - mysql.type - Will be resolved to one of mysql, mariadb or percona
  - mysql.bind - Bind interface
  - mysql.port - Port
* Nginx (Nginx vhost facts)
  - nginx.vhosts[].name - Hostname from server_name
  - nginx.vhosts[].port - port
  - nginx.vhosts[].ssl - Will be true if ssl is enabled on this vhost
  - nginx.vhosts[].access_log - Path to the access_log
  - nginx.vhosts[].error_log - Path to the error_log
* Redis
  - redis.bind - Bind interface
  - redis.port - Port
* Services
  - services[] - Installed services from init or systemd
* Crontab
  - crontab[hash_id].min - Minute
  - crontab[hash_id].hour - Hour
  - crontab[hash_id].dom - Day of month
  - crontab[hash_id].month - Month
  - crontab[hash_id].dow - Day of week
  - crontab[hash_id].user - Cron user
  - crontab[hash_id].command - Command
* Kubernetes
  - pods[].name - Name of the pod
  - pods[].namespace - Pod namespace
  - pods[].ip - IP address
  - pods[].node - kubernetes node which started the pod
* Windows facts
  - windows_gui - `true` if explorer.exe is installed (`false` if it is a core server)
  - windows_default_language - Language on which the installed windows core is based on
