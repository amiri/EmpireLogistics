import sys
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7') # cautionary to load django
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/site-packages') # to load django
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/dist-packages') # to load django
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/distutils') # to load django
sys.path.append('/usr/lib/python2.7') # to load os
import os

import TileStache
application = TileStache.WSGITileServer('/var/local/EmpireLogistics/current/etc/empirelogistics_tiles.cfg')
