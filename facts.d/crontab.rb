require "digest"

def parseCrontab(filename, user=nil)
    cat = Facter::Util::Resolution.exec("/bin/cat " + filename)
    crontab = {}
    cat.each_line do |line|
        if line == "" or line[0] == "#" # skip empty lines and comments
            next
        end

        matches = line.match(/([0-9\-\,\*\/]+)\s+([0-9\-\,\*\/]+)\s+([0-9\-\,\*\/]+)\s+([0-9\-\,\*\/]+)\s+([0-9\-\,\*\/]+)\s+(.*)/)
        # skip non-crontab lines
        if matches.nil? or matches.length < 7
            next
        end
        if user.nil?  # there should be an user field in crontab line
          submatches = matches[6].match(/([[:alpha:]]+)\s+(.*)/)
          if submatches.nil? or submatches.length < 3
            next
          end
          cronuser = submatches[1]
          croncommand = submatches[2]
        else
          cronuser = user
          croncommand = matches[6]
        end

        hash = Digest::SHA1.hexdigest(line)
        crontab.merge!( { hash => {
            'min' => matches[1],
            'hour' => matches[2],
            'dom' => matches[3],
            'month' => matches[4],
            'dow' => matches[5],
            'user' => cronuser,
            'command' => croncommand,
        }})
    end
    return  crontab
end

Facter.add("crontab") do
    confine :kernel => :linux
    
 setcode do
    crontab = {}

    crontab.merge!(parseCrontab('/etc/crontab')) # parse system crontab

    Dir.glob('/var/spool/cron/crontabs/*').each do |file| # parse user crontabs
          user = file.split('/').last
          crontab.merge!(parseCrontab(file, user))
    end
 
       crontab
   end
end

