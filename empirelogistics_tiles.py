import sys
sys.path.append('/usr/local/lib/python2.7/site-packages') # to load django
sys.path.append('/usr/local/lib/python2.7/dist-packages') # cautionary to load django
sys.path.append('/usr/lib/python2.7') # to load os
import os

import TileStache
application = TileStache.WSGITileServer('/var/local/EmpireLogistics/current/etc/empirelogistics_tiles.cfg')
