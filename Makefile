########## Variables

SHELL=/bin/bash
rail_dir := data/rail
port_dir := data/ports
warehouse_dir := data/warehouses

########## Meta commands

all: data database

data: download-data rail warehouses ports

database: data create-database import-rail-data import-port-data import-warehouse-data

create-database:
	bin/create-database

clean:
	rm -rf data/{rail,ports,warehouses}

########## Download data

make-data-directories:
	test -d $(rail_dir) || mkdir -p $(rail_dir)/{cta-sup,shp}
	test -d $(warehouse_dir) || mkdir -p $(warehouse_dir)
	test -d $(port_dir) || mkdir -p $(port_dir)

download-data: download-port-data download-rail-data download-warehouse-data

download-port-data: make-data-directories $(port_dir)/WPI.shp
	test -s $(port_dir)/WPI_Shapefile.zip || curl -o $(port_dir)/WPI_Shapefile.zip 'http://msi.nga.mil/MSISiteContent/StaticFiles/NAV_PUBS/WPI/WPI_Shapefile.zip'

download-rail-data: make-data-directories $(rail_dir)/na-rail.zip $(rail_dir)/cta-sup/wconv.txt $(rail_dir)/qc28R.zip $(rail_dir)/QNdata.zip $(rail_dir)/cta-sup/subdiv.txt $(rail_dir)/shp/qn28n.shp $(rail_dir)/shp/qn28l.shp $(rail_dir)/na-rail-interlines.geojson $(rail_dir)/na-rail-ownership.json $(rail_dir)/na-rail-subdivisions.json

download-warehouse-data: make-data-directories $(warehouse_dir)/walmart-distribution-centers.json $(warehouse_dir)/target-distribution-centers.json

########## Process data

rail: download-rail-data

warehouses: download-warehouse-data

ports: download-port-data

########## Import data

import-rail-data: rail
	perl bin/import-ownership.pl
	perl bin/import-subdivisions-states-and-rels.pl
	ogr2ogr -f PostgreSQL PG:"dbname='empirelogistics' host='localhost' port='5432' user='el'" $(rail_dir)/na-rail-interlines.geojson -t_srs EPSG:3857 -nln raw_rail_interline
	shp2pgsql -s 3857 -I $(rail_dir)/shp/qn28l raw_rail_line | psql -q -U el -d empirelogistics
	shp2pgsql -s 3857 -I $(rail_dir)/shp/qn28n raw_rail_node | psql -q -U el -d empirelogistics
	bin/postprocess-rail

import-port-data: ports
	shp2pgsql -s 3857 -I $(port_dir)/WPI raw_port | psql -q -U el -d empirelogistics
	bin/postprocess-port

import-warehouse-data: warehouses
	perl bin/import-walmart.pl
	perl bin/import-target.pl

########## Rail data download pieces

# Current raw network for rail line shapefiles
$(rail_dir)/na-rail.zip: $(rail_dir)/shp
	test -s $(rail_dir)/na-rail.zip || curl -o $(rail_dir)/na-rail.zip 'http://cta.ornl.gov/transnet/qn28V.zip'

# Text file for ancestry/ownership
$(rail_dir)/cta-sup/wconv.txt: $(rail_dir)/cta-sup
	test -s $(rail_dir)/cta-sup/wconv.txt || curl -o $(rail_dir)/cta-sup/wconv.txt 'http://cta.ornl.gov/transnet/wconv.txt'

# Current operational network archive for interlines
$(rail_dir)/qc28R.zip:
	test -s $(rail_dir)/qc28R.zip || curl -o $(rail_dir)/qc28R.zip 'http://cta.ornl.gov/transnet/qc28R.zip'

# Supplemental data archive for subdivisions
$(rail_dir)/QNdata.zip:
	test -s $(rail_dir)/QNdata.zip || curl -o $(rail_dir)/QNdata.zip 'http://cta.ornl.gov/transnet/QNdata.zip'

# Unzip operational network
$(rail_dir)/cta-sup/qc28.%: $(rail_dir)/qc28R.zip $(rail_dir)/cta-sup/wconv.txt
	unzip -o -d $(rail_dir)/cta-sup $(rail_dir)/qc28R.zip

# Unzip supplemental data archive
$(rail_dir)/cta-sup/subdiv.txt: $(rail_dir)/QNdata.zip
	unzip -o -d $(rail_dir)/cta-sup $(rail_dir)/QNdata.zip

# Unzip raw network
$(rail_dir)/shp/qn28%.shp: $(rail_dir)/na-rail.zip
	unzip -o -d $(rail_dir)/shp $(rail_dir)/na-rail.zip

# Create rail lines geojson
$(rail_dir)/na-rail-lines.geojson: $(rail_dir)/shp/qn28l.shp $(rail_dir)/cta-sup/wconv.txt
	ogr2ogr -f GeoJSON $(rail_dir)/na-rail-lines.geojson $(rail_dir)/shp/qn28l.shp

# Create interlines geojson
$(rail_dir)/na-rail-interlines.geojson: $(rail_dir)/cta-sup/qc28.iln
	test -s $(rail_dir)/na-rail-interlines.geojson || perl bin/interlineparser.pl

# Create ancestry/ownership json
$(rail_dir)/na-rail-ownership.json: $(rail_dir)/cta-sup/wconv.txt
	test -s $(rail_dir)/na-rail-ownership.json || perl bin/ownershipparser.pl

# Create subdivisions json
$(rail_dir)/na-rail-subdivisions.json: $(rail_dir)/cta-sup/subdiv.txt $(rail_dir)/na-rail-ownership.json
	test -s $(rail_dir)/na-rail-subdivisions.json || perl bin/subdivisionparser.pl

########## Port data download pieces

$(port_dir)/WPI.shp: download-port-data
	unzip -o -d $(port_dir)/ $(port_dir)/WPI_Shapefile.zip

########## Warehouse data download pieces

$(warehouse_dir)/walmart.html:
	test -s $(warehouse_dir)/walmart.html || cp 'etc/data/warehouses/walmart/Walmart Distribution Center Network USA   MWPVL.html' $(warehouse_dir)/walmart.html

$(warehouse_dir)/walmart-distribution-centers.json: $(warehouse_dir)/walmart.html
	test -s $(warehouse_dir)/walmart-distribution-centers.json || perl bin/extract-walmart-tables.pl

$(warehouse_dir)/target-distribution-centers.json:
	test -s $(warehouse_dir)/target-distribution-centers.json || cp 'etc/data/warehouses/target/target-distribution-centers.json' $(warehouse_dir)/target-distribution-centers.json
