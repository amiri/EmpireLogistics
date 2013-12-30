all: \
	na-rail.json \
	subunits.json \
	places.json \
	tqconv.dat \
	qniln.dat \
	na-rail-wconv.json

clean: 
	rm ne_10* *.zip *.json *.dat subdiv.txt

na-rail.zip:
	curl -o na-rail.zip 'http://cta.ornl.gov/transnet/qn28V.zip'

subunits.zip:
	curl -o subunits.zip 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip'

populated.zip:
	curl -o places.zip 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_populated_places.zip'

QNdata.zip:
	curl -o QNdata.zip 'http://cta.ornl.gov/transnet/QNdata.zip'

qc28R.zip:
	curl -o qc28R.zip 'http://cta.ornl.gov/transnet/qc28R.zip'

wconv.dat: QNdata.zip
	unzip QNdata.zip

qniln.dat: QNdata.zip
	unzip QNdata.zip

tqconv.dat: QNdata.zip
	unzip QNdata.zip

qn28l.shp: na-rail.zip
	unzip na-rail.zip

qn28n.shp: na-rail.zip
	unzip na-rail.zip

qc28.iln: qc28R.zip
	unzip qc28R.zip

ne_10m_admin_0_map_subunits.shp: subunits.zip
	unzip subunits.zip

ne_10m_populated_places.shp: populated.zip
	unzip places.zip

subunits.json: ne_10m_admin_0_map_subunits.shp
	ogr2ogr \
	-f GeoJSON \
	-where "adm0_a3 IN ('USA','MEX','CAN')" \
	subunits.json \
	ne_10m_admin_0_map_subunits.shp

places.json: ne_10m_populated_places.shp
	ogr2ogr \
	-f GeoJSON \
	-where "iso_a2 IN ('CA','US','MX') \
	AND scalerank < 8" \
	places.json \
	ne_10m_populated_places.shp

na-rail-links.json: qn28l.shp wconv.dat
	ogr2ogr -f GeoJSON na-rail-links.json qn28l.shp

na-rail-nodes.json: qn28l.shp wconv.dat
	ogr2ogr -f GeoJSON na-rail-nodes.json qn28n.shp

na-rail-wconv.json: wconv.dat
	perl ownershipparser.pl
