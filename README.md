# Puppet Module: Advanced facts

### Description
Deploy some facts to gather configuration data from already installed services (not managed by puppet).
This way you can perform puppet actions for services installed on an agent even though they are not managed by puppet itself.
For example you have an Apache2 webserver with various vhosts installed, but those vhosts are not deployed via puppet.
Now you would like to gather all logfiles from all those vhosts and do some crazy stuff with it, how?

This module will collect all those relevant informations from various software (if installed) and will make them availbale as facts.

* Apache2
  apache2.vhosts[].name - Hostname from ServerName
  apache2.vhosts[].port - Port
  apache2.vhosts[].ssl - Will be true if ssl is enabled on this vhost
  apache2.vhosts[].access_log - Path to the CustomLog
  apache2.vhosts[].error_log - Path to the ErrorLog
