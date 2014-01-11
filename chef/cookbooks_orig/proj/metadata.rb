name              "proj"
maintainer        "Paul A. Jungwirth"
maintainer_email  "pj@illuminatedcomputing.com"
license           "Apache 2.0"
description       "Installs PROJ"
version           "0.1"

recipe "proj", "Installs PROJ"

%w{ ubuntu }.each do |os|
  supports os
end

