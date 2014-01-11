postgis_version = node['postgis']['version']
pg_sharedir = node['postgis']['sharedir']
tarball = "postgis-#{postgis_version}.tar"
tarball_gz = "#{tarball}.gz"
remote_file "/tmp/#{tarball_gz}" do
  source "http://download.osgeo.org/postgis/source/#{tarball_gz}"
  mode "0644"
  action :create_if_missing
end

bash "install_postgis_#{postgis_version}" do
  untar_dir = "/usr/local/src"
  user "root"
  code <<-EOH
    cd #{untar_dir} && \
    tar xzvf /tmp/#{tarball_gz} && \
    cd postgis-#{postgis_version} && \
    ./configure --with-raster --with-topology  --enable-debug && \
    make && make install && \
    ldconfig
  EOH
  command ""
  creates "#{pg_sharedir}/extension/postgis--#{postgis_version}.sql"
  action :run
end

execute "create_postgis_template" do
  user "postgres"
  command "createdb -E UTF8 #{node['postgis']['template_name']} -T template0"
  not_if "psql -qAt --list | grep '^#{node['postgis']['template_name']}\|'", user: "postgres"
  action :run
end

execute "load_postgis_sql" do
  user "postgres"
  command "psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/#{node['postgis']['sql_folder']}/postgis.sql"
  only_if "psql -qAt --list | grep '^#{node['postgis']['template_name']}\|'", user: 'postgres'
  action :run
end

execute "load_spatial_ref_sys_sql" do
  user "postgres"
  command "psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/#{node['postgis']['sql_folder']}/spatial_ref_sys.sql"
  only_if "psql -qAt --list | grep '^#{node['postgis']['template_name']}\|'", user: 'postgres'
  action :run
end

execute "load_rtpostgis_sql" do
  user "postgres"
  command "psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/#{node['postgis']['sql_folder']}/rtpostgis.sql"
  only_if "psql -qAt --list | grep '^#{node['postgis']['template_name']}\|'", user: 'postgres'
  action :run
end

execute "load_topology_sql" do
  user "postgres"
  command "psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/#{node['postgis']['sql_folder']}/topology.sql"
  only_if "psql -qAt --list | grep '^#{node['postgis']['template_name']}\|'", user: 'postgres'
  action :run
end

