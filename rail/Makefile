all: \
	subunits.json \
	places.json \
	na-rail-lines.json \
	na-rail-nodes.json \
	na-rail-interlines.json \
	na-rail-ownership.json

clean:
	rm -rf shp/ cta-sup/ *.json *.zip

na-rail.zip:
	test -d shp || mkdir shp
	curl -o na-rail.zip 'http://cta.ornl.gov/transnet/qn28V.zip'

subunits.zip:
	test -s subunits.zip || curl -o subunits.zip 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip'

populated.zip:
	curl -o populated.zip 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_populated_places.zip'

cta-sup/wconv.txt:
	test -d cta-sup || mkdir cta-sup
	test -s cta-sup/wconv.txt || curl -o cta-sup/wconv.txt 'http://cta.ornl.gov/transnet/wconv.txt'

qc28R.zip:
	test -s qc28R.zip || curl -o qc28R.zip 'http://cta.ornl.gov/transnet/qc28R.zip'

QNdata.zip:
	test -s QNdata.zip || curl -o QNdata.zip 'http://cta.ornl.gov/transnet/QNdata.zip'

cta-sup/qc28.%: qc28R.zip cta-sup/wconv.txt
	unzip -o -d cta-sup qc28R.zip

cta-sup/subdiv.txt: QNdata.zip
	unzip -o -d cta-sup QNdata.zip

shp/qn28%.shp: na-rail.zip
	unzip -o -d shp na-rail.zip

shp/ne_10m_admin_0_map_subunits.shp: subunits.zip
	unzip -o -d shp subunits.zip

shp/ne_10m_populated_places.shp: populated.zip
	unzip -o -d shp populated.zip

subunits.json: shp/ne_10m_admin_0_map_subunits.shp
	ogr2ogr \
	-f GeoJSON \
	-where "adm0_a3 IN ('USA','MEX','CAN')" \
	subunits.json \
	shp/ne_10m_admin_0_map_subunits.shp

places.json: shp/ne_10m_populated_places.shp
	ogr2ogr \
	-f GeoJSON \
	-where "iso_a2 IN ('CA','US','MX') \
	AND scalerank < 8" \
	places.json \
	shp/ne_10m_populated_places.shp

na-rail-lines.json: shp/qn28l.shp cta-sup/wconv.txt
	ogr2ogr -f GeoJSON na-rail-lines.json shp/qn28l.shp

na-rail-nodes.json: shp/qn28l.shp cta-sup/wconv.txt
	ogr2ogr -f GeoJSON na-rail-nodes.json shp/qn28n.shp

na-rail-interlines.json: cta-sup/qc28.iln
	perl interlinkparser.pl

na-rail-ownership.json: cta-sup/wconv.txt cta-sup/subdiv.txt
	perl ownershipparser.pl
	perl subdivisionparser.pl
	perl postprocess-rail-lines.pl
