Facter.add("fstab") do
    confine :kernel => :Linux
    
  setcode do
    cat = Facter::Util::Resolution.exec("/bin/cat /etc/fstab")

    fstab = []    
    cat.each_line do |line|
        line = line.strip().split(" ").join(" ")
        if line == "" or line[0] == "#"
            next
        end
        
        params = line.split(" ")

        device = params[0].split("=")
        if device[0] == "UUID" 
            device = Facter::Util::Resolution.exec("/sbin/findfs "+params[0])
        else 
            device = params[0]
        end

        label = Facter::Util::Resolution.exec("/sbin/blkid -o value -s LABEL "+device) 
 
        fstab.push({
            'device' => device,
            'mount' => params[1],
            'filesystem' => params[2],
            'options' => params[3],
            'freq' => params[4],
            'passno' => params[5],
            'device_label' => label,
        })
    end

        fstab
   end
end
