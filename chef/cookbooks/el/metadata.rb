name             'el'
maintainer       'Amiri Barksdale'
maintainer_email 'amiribarksdale@gmail.com'
license          'All rights reserved'
description      'Installs/Configures el'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "nginx"
depends "uwsgi"
depends "postgresql"
depends "nodejs"
depends "npm"
depends "python"
depends "perl"
depends "perlbrew"
depends "carton"
depends "sudo"
