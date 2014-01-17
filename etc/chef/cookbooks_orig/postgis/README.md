# Description

Installs [PostGIS](http://postgis.refractions.net/).

## Platforms:

Tested on:

* Ubuntu 12.04

## Recipes:

* `default.rb` - Downloads, builds, and installs PostGIS from source. Adds a `template\_postgis` database template to your existing PostgreSQL installation.

## Attributes

* `node['postgis']['version']` - the version of PostGIS to use (default: "2.0.2").
* `node['postgis']['sql_folder']` - the directory where PostGIS installs its SQL files, somewhere inside `` `pg_config --sharedir`/contrib`` (default: "postgis-2.0").
* `node['postgis']['template_name']` - the name of the PostGIS template database to create (default: "template\_postgis").


Usage
=====

First, you'll need the [GEOS](https://github.com/pjungwir/chef-geos), [GDAL](https://github.com/pjungwir/chef-gdal), and [PROJ](https://github.com/pjungwir/chef-proj) cookbooks.
Then, put something like this in your node file:

    "geos": {
      "version": "3.3.6"
    },

    "gdal": {
      "version": "1.9.2"
    },

    "proj": {
      "version": "4.8.0"
    },

    "postgis": {
      "version": "2.0.2"
    },

    "run_list": [
      // ...
      "recipe[geos]",
      "recipe[gdal]",
      "recipe[proj]",
      "recipe[postgresql::server]",
      "recipe[postgis]"
      // ...
    ]

You'll also need to install PostgreSQL itself before PostGIS, but I assume you've already got a cookbook for that or will have no trouble finding/writing one. This PostGIS cookbook won't do it for you. Note that if you installed Postgres using [the Opscode cookbook](https://github.com/opscode-cookbooks/postgresql) on Ubuntu, you'll need to do this somewhere before the postgis recipe:

    package 'postgresql-server-dev-9.1'

Or you can set the `node['postgresql']['server']['packages']` attribute to include that package.

Author
======

Author:: Paul A. Jungwirth (<pj@illuminatedcomputing.com>)

Some code taken from [Osiloke Harold Emoekpere](https://github.com/osiloke/chef-postgis).


License
=======

Copyright:: 2013, Illuminated Computing Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
