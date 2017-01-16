Facter.add("services") do
    services = []
    initd = Facter::Util::Resolution.exec("ls /etc/init.d")
        
    initd.each_line do |line|
        services.push(line.strip().split().join(" "))
    end
        
    setcode do
        services
    end
end
