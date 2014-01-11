#
# Cookbook Name:: el
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node.override['locale']['lang'] = 'en_US.UTF-8'
include_recipe 'locale::default'

include_recipe "nginx"
include_recipe "uwsgi"
include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "database::postgresql"
include_recipe "nodejs"
include_recipe "nodejs::npm"
include_recipe "geos"
include_recipe "gdal"
include_recipe "proj"
include_recipe "postgis"

postgresql_database node['el']['database'] do
  connection(
    :host      => '127.0.0.1',
    :port      => 5432,
    :username  => 'postgres',
    :password  => node['postgresql']['password']['postgres']
  )
  template 'template_postgis'
  encoding 'UTF8'
  action :create
end

postgresql_connection_info = {
  :host     => 'localhost',
  :port     => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database_user node['el']['db_username'] do
  connection postgresql_connection_info
  password   node['el']['db_password']
  action     :create
end

postgresql_database_user node['el']['db_username'] do
  connection    postgresql_connection_info
  database_name node['el']['database'] 
  privileges    [:all]
  action        :grant
end
