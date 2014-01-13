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

deploy_revision "empirelogistics" do
  repo "http://github.com/amiri/EmpireLogistics.git"
  deploy_to "/var/local/EmpireLogistics"
  revision "HEAD" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user "el"
  enable_submodules true
  environment "production"
  shallow_clone true
  keep_releases 10
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  symlink_before_migrate nil
  create_dirs_before_symlink   []
  purge_before_symlink         []
  symlinks                     nil
  scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
  notifies :restart, "service[uwsgi]"
end

user "el" do
  supports :manage_home => true
  comment "Empire Logistics"
  uid 1917
  gid "admin"
  home "/home/el"
  shell "/bin/bash"
end

user "amiri" do
  supports :manage_home => true
  comment "Amiri Barksdale"
  uid 1918
  gid "admin"
  home "/home/amiri"
  shell "/bin/bash"
end

group "el" do
  action :create
  gid 1917
  members ["amiri","el","www-data"]
  append true
end

include_recipe "nginx"
include_recipe "uwsgi"
include_recipe "uwsgi::emperor"
include_recipe "postgresql"
include_recipe "postgresql::apt_repository"
include_recipe "postgresql::postgis"
include_recipe "postgresql::server"
include_recipe "postgresql::server_dev"
include_recipe "postgresql::data_directory"
include_recipe "postgresql::contrib"
include_recipe "postgresql::configuration"
include_recipe "postgresql::libpq"
include_recipe "postgresql::client"
include_recipe "postgresql::pg_user"
include_recipe "postgresql::pg_database"
include_recipe "postgresql::service"
include_recipe "nodejs"
include_recipe "nodejs::npm"
include_recipe "sudo"

node['el']['npm_packages'].each do |package|
  execute "install_npm_#{package}" do
    command "npm install -g #{package}"
  end
end

cookbook_file "nginx.conf" do
  path "/etc/nginx/sites-enabled/empirelogistics"
  action :create_if_missing
end

service "nginx" do
   action :restart
end
