
=begin
execute "wget geos" do
  tarball_url = "http://download.osgeo.org/geos/#{tarball}"
  cwd "/tmp"
  command "wget #{tarball_url}"
  creates "/tmp/#{tarball}"
  action :run
end
=end

geos_version = node['geos']['version']
tarball = "geos-#{geos_version}.tar"
tarball_bz2 = "geos-#{geos_version}.tar.bz2"
remote_file "/tmp/#{tarball_bz2}" do
  source "http://download.osgeo.org/geos/#{tarball_bz2}"
  mode "0644"
  action :create_if_missing
  # notifies :run, "bash[install_geos_#{geos_version}]", :immediately
end

bash "install_geos_#{geos_version}" do
  untar_dir = "/usr/local/src"
  user "root"
  code <<-EOH
    cd /tmp && \
    bunzip2 -f #{tarball_bz2} && \
    cd #{untar_dir} && \
    tar xvf /tmp/#{tarball} && \
    cd geos-#{geos_version} && \
    ./configure && make && make install && \
    ldconfig
  EOH
  command ""
  creates untar_dir + "/geos-#{geos_version}"
  action :run
end




# Alas, ark doesn't support .bz2 files:
=begin
ark "geos" do
  url "http://download.osgeo.org/geos/geos-3.3.6.tar.bz2"
  action [:configure, :install_with_make]
end
=end
