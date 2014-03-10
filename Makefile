########## Variables

SHELL=/bin/bash
rail_dir := data/rail
port_dir := data/ports
warehouse_dir := data/warehouses
media_dir := data/media
labor_dir := data/labor_organizations

########## Meta commands

all: chef data database

data: download-data rail warehouses ports labor

database: data create-database import-rail-data import-port-data import-port-teu import-warehouse-data import-labor

create-database:
	bin/create-database

clean:
	rm -rf data/{rail,ports,warehouses,media,labor_organizations}

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
	test -d $(media_dir) || mkdir -p $(media_dir)
	test -d $(labor_dir) || mkdir -p $(labor_dir)

download-data: download-port-data download-rail-data download-warehouse-data download-labor-data

download-port-data: make-data-directories
	test -s $(port_dir)/WPI_Shapefile.zip || curl -o $(port_dir)/WPI_Shapefile.zip 'http://msi.nga.mil/MSISiteContent/StaticFiles/NAV_PUBS/WPI/WPI_Shapefile.zip'
	test -s $(port_dir)/ports_major.zip || curl -o $(port_dir)/ports_major.zip 'http://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_atlas_database/2013/zip/ports_major.zip'

download-rail-data: make-data-directories $(rail_dir)/na-rail.zip $(rail_dir)/cta-sup/wconv.txt $(rail_dir)/qc28R.zip $(rail_dir)/QNdata.zip $(rail_dir)/cta-sup/subdiv.txt $(rail_dir)/shp/qn28n.shp $(rail_dir)/shp/qn28l.shp $(rail_dir)/na-rail-interlines.geojson $(rail_dir)/na-rail-ownership.json $(rail_dir)/na-rail-subdivisions.json

download-warehouse-data: make-data-directories $(warehouse_dir)/walmart-distribution-centers.json $(warehouse_dir)/target-distribution-centers.json $(warehouse_dir)/costco.txt $(warehouse_dir)/krogers.txt $(warehouse_dir)/walgreens.csv $(warehouse_dir)/amazon.tsv $(warehouse_dir)/homedepot.csv $(warehouse_dir)/ikea.csv $(warehouse_dir)/warehouse_data.sql

download-labor-data: make-data-directories $(labor_dir)/labor_organizations.html
	test -s $(labor_dir)/2000.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2000.zip&submitButton=Download" -o $(labor_dir)/2000.zip
	test -s $(labor_dir)/2001.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2001.zip&submitButton=Download" -o $(labor_dir)/2001.zip
	test -s $(labor_dir)/2002.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2002.zip&submitButton=Download" -o $(labor_dir)/2002.zip
	test -s $(labor_dir)/2003.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2003.zip&submitButton=Download" -o $(labor_dir)/2003.zip
	test -s $(labor_dir)/2004.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2004.zip&submitButton=Download" -o $(labor_dir)/2004.zip
	test -s $(labor_dir)/2005.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2005.zip&submitButton=Download" -o $(labor_dir)/2005.zip
	test -s $(labor_dir)/2006.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2006.zip&submitButton=Download" -o $(labor_dir)/2006.zip
	test -s $(labor_dir)/2007.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2007.zip&submitButton=Download" -o $(labor_dir)/2007.zip
	test -s $(labor_dir)/2008.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2008.zip&submitButton=Download" -o $(labor_dir)/2008.zip
	test -s $(labor_dir)/2009.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2009.zip&submitButton=Download" -o $(labor_dir)/2009.zip
	test -s $(labor_dir)/2010.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2010.zip&submitButton=Download" -o $(labor_dir)/2010.zip
	test -s $(labor_dir)/2011.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2011.zip&submitButton=Download" -o $(labor_dir)/2011.zip
	test -s $(labor_dir)/2012.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2012.zip&submitButton=Download" -o $(labor_dir)/2012.zip
	test -s $(labor_dir)/2013.zip || curl -XPOST "http://kcerds.dol-esa.gov/query/getYearlyDataFile.do" -d "selectedFileName=/esa/olms/local/queryweb/yearlydata/2013.zip&submitButton=Download" -o $(labor_dir)/2013.zip

########## Process data

rail: download-rail-data

warehouses: download-warehouse-data

ports: download-port-data

labor: download-labor-data

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
	bin/import-warehouse-data

import-media: $(media_dir)/media.sql
	bin/import-media

import-labor: labor $(labor_dir)/labor-organizations.json
	unzip -o $(labor_dir)/2000.zip -d $(labor_dir)/2000
	unzip -o $(labor_dir)/2001.zip -d $(labor_dir)/2001
	unzip -o $(labor_dir)/2002.zip -d $(labor_dir)/2002
	unzip -o $(labor_dir)/2003.zip -d $(labor_dir)/2003
	unzip -o $(labor_dir)/2004.zip -d $(labor_dir)/2004
	unzip -o $(labor_dir)/2005.zip -d $(labor_dir)/2005
	unzip -o $(labor_dir)/2006.zip -d $(labor_dir)/2006
	unzip -o $(labor_dir)/2007.zip -d $(labor_dir)/2007
	unzip -o $(labor_dir)/2008.zip -d $(labor_dir)/2008
	unzip -o $(labor_dir)/2009.zip -d $(labor_dir)/2009
	unzip -o $(labor_dir)/2010.zip -d $(labor_dir)/2010
	unzip -o $(labor_dir)/2011.zip -d $(labor_dir)/2011
	unzip -o $(labor_dir)/2012.zip -d $(labor_dir)/2012
	unzip -o $(labor_dir)/2013.zip -d $(labor_dir)/2013
	perl bin/import-labor.pl

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

$(warehouse_dir)/ikea.csv:
	test -s $(warehouse_dir)/ikea.csv || cp 'etc/data/warehouses/ikea/ikea.csv' $(warehouse_dir)/ikea.csv

$(warehouse_dir)/warehouse_data.sql:
	test -s $(warehouse_dir)/warehouse_data.sql || cp 'etc/data/warehouses/warehouse_data.sql' $(warehouse_dir)/warehouse_data.sql || echo 0

########## Media data download pieces

$(media_dir)/media.sql:
	test -s $(media_dir)/media.sql || cp 'etc/data/media.sql' $(media_dir)/media.sql

########## Labor organization data download pieces

$(labor_dir)/labor_organizations.html:
	test -s $(labor_dir)/labor_organizations.html || cp 'etc/data/labor_organizations/wikipedia_labor_unions.html' $(labor_dir)/labor_organizations.html

$(labor_dir)/labor-organizations.json: $(labor_dir)/labor_organizations.html
	perl bin/extract-labor-organizations.pl
