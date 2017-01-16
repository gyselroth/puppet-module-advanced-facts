Facter.add("redis") do
    confine :kernel => :linux
    params = {
        'bind' => '0.0.0.0',
        'port' => '6379',
    }

    installed = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' redis-server | cut -d ' ' -f1")
    if installed != "install"
        setcode do
            {}
        end
    else
        list = {}
        cat = Facter::Util::Resolution.exec("/bin/cat /etc/redis/redis.conf")
        
        cat.each_line do |line|
            if line == "" or line[0] == "#"
                next
            end

            if line.include? "port "
               params["port"]=line.strip().split().join(" ").split()[1]
            end
                
            if line.include? "bind "
                params["bind"]=line.strip().split().join(" ").split()[1]
            end
        end
        
        setcode do
            params
        end
    end
end
