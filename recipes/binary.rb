#
# Cookbook Name:: cookbooks-geoserver-tomcat
# Recipe:: binary
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# this method is based on documentation found at http://docs.geoserver.org/stable/en/user/installation/linux.html

geoserver_bin_zip = "#{Chef::Config['file_cache_path'] || '/tmp'}/geoserver_bin_#{version}.zip"
geoserver_unziped = "geoserver-#{node['geoserver']['version']}"

remote_file geoserver_bin_zip do
  owner 'root'
  group 'root'
  mode '0644'
  source "http://downloads.sourceforge.net/project/geoserver/GeoServer/2.8.2/geoserver-#{node['geoserver']['version']}-bin.zip"
  not_if ::FILE.readable?(geoserver_bin_zip)
end

bash 'unzip geoserver' do
  user 'root'
  cwd ::FILE.dirname(geoserver_bin_zip)
  code "unzip -qo geoserver geoserver_bin_#{version}.zip"
  not_if "::FILE.directory(geoserver-#{version})"
end

directory node['geoserver']['working_dir'] do
  action :create
end

bash 'move geoserver' do
  user 'root'
  cwd ::FILE.dirname(geoserver_bin_zip)
  code <<-EOH
      shopt -s dotglob;
      cp -r #{geoserver_unziped}/* #{node['geoserver']['working_dir']};
  EOH
end

service 'geoserver' do
  supports :status => true, :restart => true, :truereload => true
  start_command "node['geoserver']['working_dir']/bin/startup.sh"
  stop_command "node['geoserver']['working_dir']/bin/stopup.sh"
  action [ :enable, :start ]
end
