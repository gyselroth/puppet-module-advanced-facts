Facter.add("services") do
    services = []
    systemd = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' systemd | cut -d ' ' -f1")
  
    if systemd == "install"
        list = Facter::Util::Resolution.exec("systemctl list-units   | grep '.service' | cut -d ' ' -f1 | cut -d '.' -f1")
    else
        list = Facter::Util::Resolution.exec("ls /etc/init.d")
    end
    
    list.each_line do |line|
        services.push(line.strip().split().join(" "))
    end
        
    setcode do
        services
    end
end
