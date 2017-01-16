Facter.add("elasticsearch") do
    confine :kernel => :linux
    params = {
        'bind' => '0.0.0.0',
        'port' => 9200,
    }

    installed = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' elasticsearch | cut -d ' ' -f1")

    if installed != "install"
        setcode do
            {}
        end
    else
        require 'yaml'

        conf = YAML.load_file('/etc/elasticsearch/elasticsearch.yml')

        if conf.inspect["network.bind_host"]
            params["bind"] = conf.inspect["network.bind_host"]
        end
        
        if conf.inspect["http.port"]
            params["port"] = conf.inspect["http.port"]
        end
        
        setcode do
            params
       end
    end
end
