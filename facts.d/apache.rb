Facter.add("apache") do
    confine :kernel => :linux
    params = {
        'vhosts' => [],
    }

    installed = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' apache2 | cut -d ' ' -f1")
    if installed != "install"
        setcode do
            params
        end
    else
        list = {}
        cat = Facter::Util::Resolution.exec("/bin/cat /etc/apache2/sites-enabled/*")
        
        name = ''
        port = ''
        ssl  = false
        error_log = ''
        access_log = ''
        
        cat.each_line do |line|
            if line.include? "</VirtualHost"
                if name != "" && port != ""
                    params['vhosts'].push({
                        'name'  => name,
                        'port'  => port,
                        'ssl'   => ssl,
                        'access_log' => access_log,
                        'error_log' => error_log
                    })
                    port = ""
                    ssl  = false
                    name = ""
                    error_log = ''
                    access_log = ''
                end
            end
            

            if line.include? "CustomLog "
                access_log=line.strip().split().join(" ").split()[1]
            end
            
            if line.include? "ErrorLog "
               error_log=line.strip().split().join(" ").split()[1]
            end
                
            if line.include? "ServerName "
                name=line.strip().split().join(" ").split()[1]
            end
            
            if line.include? "<VirtualHost "
                port=line.strip().split.join(" ").split()[1].split(':')[1].split('>')[0]
            end
                
            if line.include? "SSLEngine" and line.split()[1].downcase == "on"
                ssl = true
            end
        end
        
        setcode do
            params
        end
    end
end
