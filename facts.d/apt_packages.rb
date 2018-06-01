Facter.add("packages") do
    confine :kernel => 'Linux'
 setcode do
    list = {}
    packs = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show --showformat '${Package};${Version};${Status}\n' | grep 'installed\\|half-configured\\|unpacked'")

    packs.each_line do |package|
        split = package.split(';')
        list[split[0]] = split[1].split("\n")[0]
    end

      list
    end
end
