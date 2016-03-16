#
# Cookbook Name:: geoserver-tomcat
# Recipe:: default
#
# Copyright 2014, Strand Life Sciences
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java'
include_recipe 'postgis'

package 'unzip'


remote_file node['geoserver']['download'] do
  source   node['geoserver']['link']
  mode     0644
  action :create_if_missing
end

directory node['geoserver']['extracted'] do
  group 'root'
  mode '0755'
  path 'name'
  recursive false

  action :create
end
bash 'unpack geoserver' do
  code "unzip -o #{node['geoserver']['download']} -d #{node['geoserver']['extracted']}"
  # not_if "test -d #{node['geoserver']['extracted']}"
end

tmp_dir = '/tmp/geoserver-temp'
directory  tmp_dir do
  owner 'root'
  group 'root'
  mode '0755'

  action :create
end
bash 'Creating temporary working directory' do
  code "mkdir -p /tmp/geoserver-temp/WEB-INF/lib"
end

remote_directory '/tmp/geoserver-temp/WEB-INF/lib' do
  path "#{tmp_dir}/WEB-INF/lib"
  source 'geoserver-lib'
  recursive true
end

bash "Adding amdb jar to  geoserver  war file #{node['geoserver']['war']}" do
  cwd tmp_dir
  code <<-EOH
  jar -uvf #{node['geoserver']['war']} WEB-INF/lib;
  chmod +r #{node['geoserver']['war']};
  EOH
end

directory tmp_dir do
  recursive true
  action :delete
end

application node['geoserver']['context'] do
  path node['geoserver']['home']
  repository node['geoserver']['war']
  revision '...'
    scm_provider Chef::Provider::File::Deploy

  java_webapp do
    context_template 'geoserver.context.erb'
  end

  tomcat
end

remote_directory node['geoserver']['data'] do
  source       'data_dir'
  files_backup 0
  files_mode   '644'
  purge        true
  action       :create_if_missing
  recursive true
  not_if { File.exist? node['geoserver']['data'] }
end
