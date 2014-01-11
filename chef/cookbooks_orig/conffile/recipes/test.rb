#
# Cookbook Name:: conffile
# Recipe:: default
#
# Copyright (C) 2013 Guilhem Lettron
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "conffile"

conffile_ini "test creation" do
  path "#{Chef::Config[:file_cache_path]}/test.conf"
  parameters( "global" => {"parameter1" => "value1"})
  action :install
end

conffile_ini "test add" do
  path "#{Chef::Config[:file_cache_path]}/test.conf"
  parameters( "global" => {"parameter2" => "value2"})
  action :configure
end
