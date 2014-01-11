# Description

Installs the [Geospatial Data Abstraction Library (GDAL)](http://www.gdal.org/).

## Platforms:

Tested on:

* Ubuntu 12.04

## Recipes:

* `default.rb` - Downloads, builds, and installs GDAL from source.

## Attributes

* `node['gdal']['version']` - the version of GDAL to use.
* `node['gdal']['download_url']` - the URL to retrieve the GDAL tarball.
  Note that prior to GDAL 1.10, URLs look like this:

    http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz

  But as of 1.10 they look like this:

    http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz

  This attribute defaults to the former for backwards compatibility,
  so it is only required for GDAL 1.10 and up.

  (Thanks for [Ross Young](https://github.com/RossLYoung) for noticing the 1.10 URL change!)


License and Author
==================

Author:: Paul A. Jungwirth (<pj@illuminatedcomputing.com>)

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
