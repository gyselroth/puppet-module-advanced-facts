Facter.add("kubernetes") do
    confine :kernel => :Linux
    params = {}
    installed = Facter::Util::Resolution.exec("/usr/bin/dpkg-query --show -f '${status}' kubelet | cut -d ' ' -f1")
    if installed == "install"
        params = { 
            'pods' => [], 
        }   
        pods = cat = Facter::Util::Resolution.exec("kubectl --kubeconfig=/etc/kubernetes/admin.conf get --all-namespaces pods -owide | grep $(hostname -f)")
        pods.each_line do |pod|
            pod = pod.split
            params['pods'].push ({
                'name'  => pod[1],
                'namespace' => pod[0],
                'ip' => pod[6],
                'node' => pod[7],
            })
        end

        setcode do
            params
        end 

    end
end
