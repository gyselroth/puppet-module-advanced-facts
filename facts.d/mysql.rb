Facter.add("mysql") do
    confine :kernel => :linux
    params = {
        'bind' => '127.0.0.1',
        'port' => 3306,
        'type' => 'mysql'
    }

    installed_mariadb = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' mariadb-server | cut -d ' ' -f1")
    installed_mysql   = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' mysql-server | cut -d ' ' -f1")
    installed_percona = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' percona-server | cut -d ' ' -f1")

    if installed_mariadb != "install" && installed_mysql != "install" && installed_percona != "install"
        setcode do
            {}
        end
    else
        if installed_mariadb == "install"
            params['type'] = 'mariadb'
        elsif installed_mysql == "1"
            params['type'] = 'install'
        elsif installed_percona == "1"
            params['type'] = 'install'
        end

        cat = Facter::Util::Resolution.exec("cat /etc/mysql/my.cnf /etc/mysql/conf.d/* | grep -v '^#' | grep '='")

        cat.each_line do |line|
            config = line.strip().split().join().split('=')
            key    = config[0]
            value  = config[1]

            if key == "bind-address"
                params['bind'] = value
            elsif key == "port"
                params['port'] = value
            end
        end
        
        setcode do
            params
       end
    end
end
