require 'json' 
Facter.add("packages") do
  confine :kernel => :windows
  setcode do
    powershell = if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
    elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
    else
      "powershell.exe"
    end
    query = 'Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion | ConvertTo-Json'
    response = JSON.parse(Facter::Util::Resolution.exec(%Q{#{powershell} -command "#{query}"}))

    if response
        list = {}
        response.each do |package|
            list[package['DisplayName']] = package['DisplayVersion']
        end
        
        list
    else
      {}
    end
  end
end
