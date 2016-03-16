#
# Cookbook Name:: geoserver-tomcat
# Attributes:: default
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



default['geoserver']['install_method'] = 'binary'
default['geoserver']['version'] = '2.8.2'
default['geoserver']['working_dir'] = '/usr/share/geoserver'

default['geoserver']['link']      = "http://downloads.sourceforge.net/project/geoserver/GeoServer/#{geoserver.version}/geoserver-#{geoserver.version}-war.zip"
default['geoserver']['extracted'] = "#{geoserver.working_dir}/geoserver-#{geoserver.version}"
default['geoserver']['war']       = "#{geoserver.extracted}/geoserver.war"
default['geoserver']['download']  = "#{geoserver.working_dir}/geoserver-#{geoserver.version}.zip"

default['geoserver']['home']          = "/var/local/geoserver-#{geoserver.version}"
default['geoserver']['data']          = "/var/local/geoserver-#{geoserver.version}/data"
default['geoserver']['context']       = 'geoserver'
