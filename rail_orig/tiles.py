import sys
sys.path.append('/usr/local/lib/python2.7/site-packages') # to load django
sys.path.append('/usr/local/lib/python2.7/dist-packages') # cautionary to load django
sys.path.append('/usr/lib/python2.7') # to load os
import os

import PIL
import TileStache
application = TileStache.WSGITileServer('/home/amiri/EmpireLogistics/rail_orig/tilestache.cfg')
