########## Variables

SHELL=/bin/bash
rail_dir := data/rail
ports_dir := data/ports
warehouses_dir := data/warehouses

########## Meta commands

all: data database

data: download-data rail warehouses ports

database: download-data rail warehouses ports

clean:
	rm -rf data/{rail,ports,warehouses}

########## Download data

make-data-directories:
	test -d $(rail_dir) || mkdir -p $(rail_dir)/{cta-sup,shp}
	test -d $(warehouses_dir) || mkdir -p $(warehouses_dir)
	test -d $(ports_dir) || mkdir -p $(ports_dir)

download-data: download-port-data download-rail-data download-warehouse-data

download-port-data: make-data-directories
	test -s $(ports_dir)/ne_10m_ports.zip || curl -o $(ports_dir)/ne_10m_ports.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_ports.zip'

download-rail-data: make-data-directories $(rail_dir)/na-rail.zip $(rail_dir)/cta-sup/wconv.txt $(rail_dir)/qc28R.zip $(rail_dir)/QNdata.zip $(rail_dir)/cta-sup/subdiv.txt $(rail_dir)/shp/qn28n.shp $(rail_dir)/shp/qn28l.shp $(rail_dir)/na-rail-interlines.json $(rail_dir)/na-rail-ownership.json

download-warehouse-data: make-data-directories

########## Process data

rail: download-rail-data

warehouses: download-warehouse-data

ports: download-port-data

########## Rail data download pieces

$(rail_dir)/na-rail.zip: $(rail_dir)/shp
	test -s $(rail_dir)/na-rail.zip || curl -o $(rail_dir)/na-rail.zip 'http://cta.ornl.gov/transnet/qn28V.zip'

$(rail_dir)/cta-sup/wconv.txt: $(rail_dir)/cta-sup
	test -s $(rail_dir)/cta-sup/wconv.txt || curl -o $(rail_dir)/cta-sup/wconv.txt 'http://cta.ornl.gov/transnet/wconv.txt'

$(rail_dir)/qc28R.zip:
	test -s $(rail_dir)/qc28R.zip || curl -o $(rail_dir)/qc28R.zip 'http://cta.ornl.gov/transnet/qc28R.zip'

$(rail_dir)/QNdata.zip:
	test -s $(rail_dir)/QNdata.zip || curl -o $(rail_dir)/QNdata.zip 'http://cta.ornl.gov/transnet/QNdata.zip'

$(rail_dir)/cta-sup/qc28.%: $(rail_dir)/qc28R.zip $(rail_dir)/cta-sup/wconv.txt
	unzip -o -d $(rail_dir)/cta-sup $(rail_dir)/qc28R.zip

$(rail_dir)/cta-sup/subdiv.txt: $(rail_dir)/QNdata.zip
	unzip -o -d $(rail_dir)/cta-sup $(rail_dir)/QNdata.zip

$(rail_dir)/shp/qn28%.shp: $(rail_dir)/na-rail.zip
	unzip -o -d $(rail_dir)/shp $(rail_dir)/na-rail.zip

$(rail_dir)/na-rail-lines.json: $(rail_dir)/shp/qn28l.shp $(rail_dir)/cta-sup/wconv.txt
	ogr2ogr -f GeoJSON $(rail_dir)/na-rail-lines.json $(rail_dir)/shp/qn28l.shp

$(rail_dir)/na-rail-interlines.json: $(rail_dir)/cta-sup/qc28.iln
	test -s $(rail_dir)/na-rail-interlines.json || perl bin/interlineparser.pl

$(rail_dir)/na-rail-ownership.json: $(rail_dir)/cta-sup/wconv.txt $(rail_dir)/cta-sup/subdiv.txt $(rail_dir)/na-rail-lines.json
	test -s $(rail_dir)/na-rail-ownership.json || perl bin/ownershipparser.pl
	test -s $(rail_dir)/na-rail-subdivisions.json || perl bin/subdivisionparser.pl
	perl bin/postprocess-rail-lines.pl

########## Port data download pieces

$(ports_dir)/ne_10m_ports.shp: download-port-data
	unzip -o -d $(ports_dir)/ $(ports_dir)/ne_10m_ports.zip

########## Warehouse data download pieces

$(warehouses_dir)/walmart.html:
	test -s $(warehouses_dir)/walmart.html || cp 'data/seed_data/warehouses/walmart/Walmart Distribution Center Network USA   MWPVL.html' $(warehouses_dir)/walmart.html

$(warehouses_dir)/target-distribution-centers.json:
	test -s $(warehouses_dir)/target-distribution-centers.json || cp 'data/seed_data/warehouses/target/target-distribution-centers.json' $(warehouses_dir)/target-distribution-centers.json
