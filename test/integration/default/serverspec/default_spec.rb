require 'spec_helper'

packages = %w(unzip)
packages.each do |p|
  describe package (p) do
    it { should is_installed }
  end
end

ports = %w(8080)
ports.each do |port|
  describe port (port) do
    it { should be_listening }
  end
end
