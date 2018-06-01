Facter.add("mongodb") do
    confine :kernel => :Linux
    params = {}
    installed = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' mongodb-server | cut -d ' ' -f1")
    if installed == "install"
        dbpath = ''
        logpath = ''
        replset = ''
        bind_ip = ''
        cat = Facter::Util::Resolution.exec("/bin/cat /etc/mongodb.conf")
        
        cat.each_line do |line|
            if line.include? "dbpath"
                dbpath=line.strip().split('=').join(" ").split()[1]
            end
            
            if line.include? "logpath"
               logpath=line.strip().split('=').join(" ").split()[1]
            end
                
            if line.include? "replSet"
                replset=line.strip().split('=').join(" ").split()[1]
            end
            
            if line.include? "bind_ip"
                bind_ip=line.strip().split('=').join(" ").split()[1]
            end
        end

        if dbpath != ""
            params['dbpath'] = dbpath
        end
        if logpath != ""
            params['logpath'] = logpath
        end
        if replset != ""
            params['replset'] = replset
        end
        if logpath != ""
            params['bind_ip'] = bind_ip
        end

        setcode do
            params
        end
    end
end
