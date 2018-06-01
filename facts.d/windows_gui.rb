Facter.add(:windows_gui) do
  confine :kernel => 'windows'
  setcode do
    File.exist?("#{ENV['windir']}/explorer.exe")
  end
end

