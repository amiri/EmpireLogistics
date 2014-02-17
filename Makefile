########## Variables

SHELL=/bin/bash
rail_dir := data/rail
port_dir := data/ports
warehouse_dir := data/warehouses

########## Meta commands

all: chef data database

data: download-data rail warehouses ports

database: data create-database import-rail-data import-port-data import-port-teu import-warehouse-data

create-database:
	bin/create-database

clean:
	rm -rf data/{rail,ports,warehouses}

prereqs:
	sudo perl -pi.orig -e "s/%admin ALL=\(ALL\) ALL/%admin ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers
	curl -L https://www.opscode.com/chef/install.sh | sudo bash
	sudo apt-get -y install git ruby1.9.1-dev build-essential unzip
	sudo gem install rdoc
	sudo gem install librarian-chef

.PHONY: chef

chef:
	bin/install-empirelogistics

.PHONY: tilestache-cache

tilestache-cache:
	sudo -u el /var/local/EmpireLogistics/current/python/bin/tilestache-seed.py -c /var/local/EmpireLogistics/current/etc/empirelogistics_tiles.cfg -l lines -b 71.130988 -169.359741 13.068777 -53.695679 -e json 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 &

########## Download data

make-data-directories:
	test -d $(rail_dir) || mkdir -p $(rail_dir)/{cta-sup,shp}
	test -d $(warehouse_dir) || mkdir -p $(warehouse_dir)
	test -d $(port_dir) || mkdir -p $(port_dir)

download-data: download-port-data download-rail-data download-warehouse-data

download-port-data: make-data-directories
	test -s $(port_dir)/WPI_Shapefile.zip || curl -o $(port_dir)/WPI_Shapefile.zip 'http://msi.nga.mil/MSISiteContent/StaticFiles/NAV_PUBS/WPI/WPI_Shapefile.zip'
	test -s $(port_dir)/ports_major.zip || curl -o $(port_dir)/ports_major.zip 'http://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_atlas_database/2013/zip/ports_major.zip'


download-rail-data: make-data-directories $(rail_dir)/na-rail.zip $(rail_dir)/cta-sup/wconv.txt $(rail_dir)/qc28R.zip $(rail_dir)/QNdata.zip $(rail_dir)/cta-sup/subdiv.txt $(rail_dir)/shp/qn28n.shp $(rail_dir)/shp/qn28l.shp $(rail_dir)/na-rail-interlines.geojson $(rail_dir)/na-rail-ownership.json $(rail_dir)/na-rail-subdivisions.json

download-warehouse-data: make-data-directories $(warehouse_dir)/walmart-distribution-centers.json $(warehouse_dir)/target-distribution-centers.json $(warehouse_dir)/costco.txt $(warehouse_dir)/krogers.txt $(warehouse_dir)/walgreens.csv $(warehouse_dir)/amazon.tsv $(warehouse_dir)/homedepot.csv

########## Process data

rail: download-rail-data

warehouses: download-warehouse-data
	test -s $(warehouse_dir)/warehouse_data.sql || cp 'etc/data/warehouses/warehouse_data.sql' $(warehouse_dir)/warehouse_data.sql

ports: download-port-data

########## Import data

import-rail-data: rail
	perl bin/import-ownership.pl
	perl bin/import-subdivisions-states-and-rels.pl
	ogr2ogr -f PostgreSQL PG:"dbname='empirelogistics' host='localhost' port='5432' user='el'" $(rail_dir)/na-rail-interlines.geojson -s_srs EPSG:4326 -t_srs EPSG:900913 -overwrite -nln raw_rail_interline
	shp2pgsql -s 4326:900913 -t 2d -I $(rail_dir)/shp/qn28l raw_rail_line | psql -q -U el -d empirelogistics
	shp2pgsql -s 4326:900913 -t 2d -I $(rail_dir)/shp/qn28n raw_rail_node | psql -q -U el -d empirelogistics
	bin/postprocess-rail

import-port-data: ports $(port_dir)/WPI.shp
	shp2pgsql -s 4326:900913 -t 2d -I $(port_dir)/WPI raw_port | psql -q -U el -d empirelogistics
	bin/postprocess-port

import-port-teu: ports $(port_dir)/ports_major.shp
	test -s $(port_dir)/ports_major.json || ogr2ogr -f GeoJSON $(port_dir)/ports_major.json $(port_dir)/ports_major.shp
	bin/import-major-port-teu.pl

import-warehouse-data: warehouses
ifeq ($(wildcard $(warehouse_dir)/warehouse_data.sql),)
	perl bin/import-walmart.pl
	perl bin/import-target.pl
	perl bin/import-krogers.pl
	perl bin/import-costco.pl
	perl bin/import-walgreens.pl
	perl bin/import-amazon.pl
	perl bin/import-homedepot.pl
else
	bin/import-warehouse-data
	echo "Found data"
endif

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

$(port_dir)/ports_major.shp: download-port-data
	unzip -o -d $(port_dir)/ $(port_dir)/ports_major.zip

########## Warehouse data download pieces

$(warehouse_dir)/walmart.html:
	test -s $(warehouse_dir)/walmart.html || cp 'etc/data/warehouses/walmart/Walmart Distribution Center Network USA   MWPVL.html' $(warehouse_dir)/walmart.html

$(warehouse_dir)/walmart-distribution-centers.json: $(warehouse_dir)/walmart.html
	perl bin/extract-walmart-tables.pl

$(warehouse_dir)/target-distribution-centers.json:
	test -s $(warehouse_dir)/target-distribution-centers.json || cp 'etc/data/warehouses/target/target-distribution-centers.json' $(warehouse_dir)/target-distribution-centers.json

$(warehouse_dir)/costco.txt:
	test -s $(warehouse_dir)/costco.txt || cp 'etc/data/warehouses/costco/costco.txt' $(warehouse_dir)/costco.txt

$(warehouse_dir)/krogers.txt:
	test -s $(warehouse_dir)/krogers.txt || cp 'etc/data/warehouses/krogers/krogers.txt' $(warehouse_dir)/krogers.txt

$(warehouse_dir)/walgreens.csv:
	test -s $(warehouse_dir)/walgreens.csv || cp 'etc/data/warehouses/walgreens/walgreens.csv' $(warehouse_dir)/walgreens.csv

$(warehouse_dir)/amazon.tsv:
	test -s $(warehouse_dir)/amazon.tsv || cp 'etc/data/warehouses/amazon/amazon.tsv' $(warehouse_dir)/amazon.tsv

$(warehouse_dir)/homedepot.csv:
	test -s $(warehouse_dir)/homedepot.csv || cp 'etc/data/warehouses/homedepot/homedepot.csv' $(warehouse_dir)/homedepot.csv
