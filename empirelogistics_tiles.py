import sys
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7')
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/site-packages')
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/dist-packages')
sys.path.append('/var/local/EmpireLogistics/shared/python/lib/python2.7/distutils')
import os
import json
import datetime
from time import mktime

def new_default(self, obj):
    if isinstance(obj, datetime.datetime):
        return int(mktime(obj.timetuple()))

    raise TypeError(repr(o) + " is not JSON serializable")

json.JSONEncoder.default == new_default

import TileStache
application = TileStache.WSGITileServer('/var/local/EmpireLogistics/current/etc/empirelogistics_tiles.cfg')
