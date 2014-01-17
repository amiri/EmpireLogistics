name              "gdal"
maintainer        "Paul A. Jungwirth"
maintainer_email  "pj@illuminatedcomputing.com"
license           "Apache 2.0"
description       "Installs GDAL"
version           "0.1.1"

recipe "gdal", "Installs GDAL"

%w{ ubuntu }.each do |os|
  supports os
end

depends "ark"

