# DEMO

    http://50.116.5.25/

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

# OVERVIEW

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
