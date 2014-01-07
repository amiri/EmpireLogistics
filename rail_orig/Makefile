all: \
	na-rail-lines.json \
	na-rail-nodes.json \
	na-rail-interlines.json \
	na-rail-ownership.json

clean:
	rm -rf shp/ cta-sup/ *.json *.zip

na-rail.zip:
	test -d shp || mkdir shp
	curl -o na-rail.zip 'http://cta.ornl.gov/transnet/qn28V.zip'

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

na-rail-lines.json: shp/qn28l.shp cta-sup/wconv.txt
	ogr2ogr -f GeoJSON na-rail-lines.json shp/qn28l.shp

na-rail-nodes.json: shp/qn28l.shp cta-sup/wconv.txt
	ogr2ogr -f GeoJSON na-rail-nodes.json shp/qn28n.shp

na-rail-interlines.json: cta-sup/qc28.iln
	perl interlineparser.pl

na-rail-ownership.json: cta-sup/wconv.txt cta-sup/subdiv.txt na-rail-lines.json
	perl ownershipparser.pl
	perl subdivisionparser.pl
	perl postprocess-rail-lines.pl
