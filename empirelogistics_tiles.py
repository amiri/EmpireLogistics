import sys
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7')
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/site-packages')
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/dist-packages')
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/distutils')
import os

import TileStache
application = TileStache.WSGITileServer('/var/local/EmpireLogistics/current/etc/empirelogistics_tiles.cfg')
