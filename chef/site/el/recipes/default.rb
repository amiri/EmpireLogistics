#
# Cookbook Name:: el
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#node.override['locale']['lang'] = 'en_US.UTF-8'
#include_recipe 'locale::default'

include_recipe "nginx"
include_recipe "uwsgi"
include_recipe "postgresql"
include_recipe "postgresql::apt_repository"
include_recipe "postgresql::client"
include_recipe "postgresql::configuration"
include_recipe "postgresql::contrib"
include_recipe "postgresql::data_directory"
include_recipe "postgresql::dbg"
include_recipe "postgresql::libpq"
include_recipe "postgresql::postgis"
include_recipe "postgresql::server"
include_recipe "postgresql::server_dev"
include_recipe "postgresql::service"
include_recipe "postgresql::pg_user"
include_recipe "postgresql::pg_database"
include_recipe "nodejs"
include_recipe "nodejs::npm"

user "el" do
  supports :manage_home => true
  comment "Empire Logistics"
  uid 1917
  gid "admin"
  home "/home/el"
  shell "/bin/bash"
  password "3mp1r3"
end

