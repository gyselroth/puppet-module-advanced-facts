def parseCrontab(filename, user=nil)
    cat = Facter::Util::Resolution.exec("/bin/cat " + filename)
    crontab = []
    cat.each_line do |line|
        line = line.strip().split(" ").join(" ")
        if line == "" or line[0] == "#" # skip empty lines and comments
            next
        end

        fields = line.split(" ")

        if user.nil?  # there should be an user field in crontab line
          minFields = 7
          cronuser = fields[5]
        else
          minFields = 6
          cronuser = user
        end

        if fields.length < minFields # skip non-crontab lines
            next
        end

        crontab.push({
            'min' => fields[0],
            'hour' => fields[1],
            'dom' => fields[2],
            'month' => fields[3],
            'dow' => fields[4],
            'user' => cronuser,
            'command' => fields.drop(minFields-1).join(" "),
        })
    end
    return  crontab
end

Facter.add("crontab") do
    confine :kernel => :linux
    crontab = []

    crontab.concat parseCrontab('/etc/crontab') # parse system crontab

    Dir.glob('/var/spool/cron/crontabs/*').each do |file| # parse user crontabs
          user = file.split('/').last
          crontab.concat parseCrontab(file, user)
    end

    setcode do
        crontab
   end
end
