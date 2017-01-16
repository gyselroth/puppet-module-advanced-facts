Facter.add("nginx") do
    confine :kernel => :linux
    params = {
        'vhosts' => [],
    }

    installed = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' nginx-common | cut -d ' ' -f1")
    if installed != "install"
        setcode do
            params
        end
    else
        list = {}
        cat = Facter::Util::Resolution.exec("/bin/cat /etc/nginx/sites-enabled/*")
        
        name = ''
        port = ''
        ssl  = false
        error_log = ''
        access_log = ''
        
        cat.each_line do |line|
            if line.include? "server {"
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
            

            if line.include? "access_log "
                access_log=line.strip!.split.join(" ").split()[1].split(';')[0]
            end
            
            if line.include? "error_log "
               error_log=line.strip!.split.join(" ").split()[1].split(';')[0]
            end
                
            if line.include? "server_name "
                name=line.strip!.split.join(" ").split()[1].split(';')[0]
            end
                
            if line.include? "listen "
                port=line.strip!.split.join(" ").split()[1].split(';')[0]
            end
            
            if line.downcase.include? "ssl on"
                ssl = true
            end
        end

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

        setcode do
            params
        end
    end
 end
