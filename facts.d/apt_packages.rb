Facter.add("packages") do
    confine :kernel => :linux
    list = {}
    packs = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show --showformat '${Package};${Version}\n'")

    packs.each_line do |package|
        split = package.split(';')
        list[split[0]] = split[1].split("\n")[0]
    end

    setcode do
      list
    end
end
