# DEMO

    [http://50.116.5.25/](http://50.116.5.25/)

# CONTRIBUTOR OVERVIEW

There's a lot going on here.

## Application

Here are the layers of the application, from bottom to top:

1. [PostgreSQL](http://www.postgresql.org/)

    Database

2. [Catalyst](https://metacpan.org/pod/Catalyst)

    Backend Application, serving such URLs as

    * /admin
    * /blog
    * /details

    et cetera.

3. [TileStache](http://tilestache.org/)

    Backend Application, serving such URLs as

    * /tiles/ports/16/15401/27089.json
    * /tiles/warehouses/15/15021/89.json

    et cetera.

4. [uwsgi](https://uwsgi-docs.readthedocs.org/en/latest/)

    Backend Application Server, serving the above 2 backend applications at specified ports.

5. [nginx](http://nginx.org/)

    Frontend Web Server, serving the two uwsgi applications from their specified ports to the internet.

## Code

Here is how the code is laid out in this directory.

1. lib/

    The Catalyst application lives here.

2. bin/

    Lots of data-mangling scripts live here.

3. data/

    When you run make chef, or some other Makefile targets, data gets downloaded from various sources and it is stored here for use by the scripts.

4. etc/
    
    * Our [chef](http://docs.getchef.com/) configuration lives here
    * As does some static, unchanging data in etc/data.
    * And our database changes are managed out of etc/schema by a tool call [sqitch](http://sqitch.org/). This is for when we need to add a new column to a PostgreSQL table or add a new table entirely.
    * There are also some configuration files in here. That's a traditional use of the etc/ directory.

5. local/

    "Sandboxed" versions of perl and python libraries, custom to this application, live here.

6. node_modules

   We use a tool called [Grunt](http://gruntjs.com/) to manage css and javascript assets, namely to combine and compress them. The [node package manager](https://www.npmjs.org/) downloads the plugins we use and stores them here. Grunt's configuration file is

        Gruntfile.js 

    The npm configuration is

        package.json

7. root/

    * css

        Our static javascript and css assets live here. The main css file for the site is

            root/css/el.css

    * js

        The main js file for the site is

            root/templates/js/el.tt
         
        The main javascript file is, you will notice, a template. That is because we need to interpolate some variables, depending on what environment the application is running in. Namely, the tile server runs on a different port on a sandbox versus the real webserver.

    * templates

        We use [Template::Toolkit](https://metacpan.org/pod/Template) for templating. These file are in

            root/templates

        The main template for the site is

            root/templates/wrapper.tt
    

# INSTALLATION

## BARE METAL

If you are running a Debian-derived distribution, preferably Ubuntu 13.10,
Saucy Salamander, you can run the following on the command line:

    make sandbox

The "sandbox" target in the Makefile does all the hard work. It configures
the server, imports and populates all the data, and it will overwrite
existing data if you run it again. This is dangerous in production, of
course, but it's OK for a sandbox.

If you want to break it down, you can build the parts individually:

    make prereqs
    make chef
    make database
    make sqitch

Now you should have a populated PostgreSQL database with
a lot of data in place. You also have nginx, PostgreSQL, and uwsgi
installed and everything running.

## VAGRANT/VIRTUALBOX

This installation is more complicated. Here is the Mac installation:

1. Clone the repository.
    * Go to https://mac.github.com and download https://central.github.com/mac/latest
    * Install it.
    * Clone the repository to your Desktop, e.g., /Users/You/Desktop
            *OR*
    * Open a Terminal: /Applications/Utilities/Terminal.app
    * Type the following commands:

            cd ~/Desktop
            git clone https://github.com/amiri/EmpireLogistics.git

2. Install X11
    * Go to http://xquartz.macosforge.org/landing/
    * Download XQuartz from http://xquartz.macosforge.org/downloads/SL/XQuartz-2.7.6.dmg
    * Install it.
    * Open the application and leave it running.

3. Install VirtualBox
    * Download https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3.dmg
    * Install it.
    * Open a Terminal: /Applications/Utilities/Terminal.app
    * Type the following commands:

            cd ~/Desktop/EmpireLogistics

4. Install a base box for Virtualbox.
    * Leave the Terminal where it is, open a web browser and go to:
                https://cloud-images.ubuntu.com/vagrant/saucy/current/
    * Choose a vagrant base box image. I have chosen the amd64-vagrant image in the command below. Your Mac is most likely a 64-bit machine, so that's the one you probably want, too.
    * Run the following command in the Terminal:

                vagrant box add base http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box
                vagrant up
You should see some setup information as this is working. You may have to answer some questions. The defaults should be fine. Once the setup is done, you can ssh to the machine.

5. SSH to the Virtual Machine

            vagrant ssh -- -A

6. cd to the shared folder

    Now you are inside the virtual machine. Run the following commands:

        cd /vagrant

    Now you are in a shared directory, the directory of the repository.

        ls

    These are the files in the repository.

7. Install the application
    * Run the installation commands:

            make prereqs && make all

8. Install a browser to the VM
    * Open up another Terminal: /Applications/Utilities/Terminal.app
    * Run the following commands:

            cd ~/Desktop/EmpireLogistics
            vagrant ssh -- -A
            cd /vagrant
            sudo apt-get install chromium-browser
            chromium-browser --disable-accelerated-compositing --blacklist-accelerated-compositing
9. Test your installation

    At the last command of the step above, you should now have a Chromium browser window
    open.

    Now you are running a browser inside the virtual machine. Visit
    http://localhost and you will see the application running.
    
    The idea here is that now you have 2 Terminal windows open. One
    is running chromium, and the other is sitting at the /vagrant
    directory inside the virtual machine. You can open up a text
    editor on your Mac and edit files inside the repo directory. When you
    are done editing, you can reinstall the application and check it.

    Reinstallation, again, is make all, which you will run inside the
    first Terminal window. It takes a much shorter time each time after
    the first.

# DATA OVERVIEW

We have all the rail, warehouse, and port data importing now. Remaining
is original data from the current site, which must be imported
manually.

We have three major data layers:

* rail
* ports
* warehouses

In North America:

* USA
* Mexico
* Canada

North American port data comes from:

* http://msi.nga.mil/MSISiteContent/StaticFiles/NAV_PUBS/WPI/WPI_Shapefile.zip

North American rail data comes from:

* http://cta.ornl.gov/transnet/qc28R.zip
* http://cta.ornl.gov/transnet/qn28V.zip
* http://cta.ornl.gov/transnet/wconv.txt
* http://cta.ornl.gov/transnet/QNdata.zip

North American warehouse data comes from:

* http://www.mwpvl.com/html/walmart.html
* https://corporate.target.com/_ui/js/main.comb.xml
* a lot of legwork and research for Costco, Amazon,
Home Depot, Ikea, Krogers, and Walgreens.

The shapefiles are imported directly into a PostGIS-enabled
database. Other data sources are imported into the same database
after being prepared/mangled/reformatted. Once all the data is in
the database, we make new tables in that database by joining and
selecting from the raw data tables. This produces the set of tables
that our application, finally, consumes.

The visualization of each layer is a separate Leaflet TileLayer,
rendered by d3, which is faster than Leaflet options now.

# ARCHITECTURE

We run two uwsgi app servers behind nginx:

* TileStache (http://tilestache.org/)

    uwsgi serves a TileStache app for the vector tiles.

* EmpireLogistics

    uwsgi serves a PSGI app for the main application.

The database server is PostgreSQL 9.3 with PostGIS extensions.

We cache vector tiles on disk, where they are served
directly, speedily, from nginx.
