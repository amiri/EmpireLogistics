name              "geos"
maintainer        "Paul A. Jungwirth"
maintainer_email  "pj@illuminatedcomputing.com"
license           "Apache 2.0"
description       "Installs GEOS"
version           "0.1.1"

recipe "geos", "Installs GEOS"

%w{ ubuntu }.each do |os|
  supports os
end


