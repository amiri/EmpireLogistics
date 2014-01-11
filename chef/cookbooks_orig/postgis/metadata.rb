name              "postgis"
maintainer        "Paul A. Jungwirth"
maintainer_email  "pj@illuminatedcomputing.com"
license           "Apache 2.0"
description       "Installs PostGIS"
version           "0.1"

recipe "postgis", "Installs PostGIS"

%w{ ubuntu }.each do |os|
  supports os
end

# depends "postgres"
depends "geos"
depends "gdal"
depends "proj"

