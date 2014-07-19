module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        concat: {
            css: {
                src: [
                    "root/css/lib/bootstrap.min.css",
                    "root/css/lib/bootstrap-theme.min.css",
                    "root/css/lib/select2.css",
                    "root/css/lib/select2-bootstrap.css",
                    "root/css/lib/leaflet.css",
                    "root/css/el.css",
                ],
                dest: "root/css/site.css",
            },
            js: {
                src: [
                    "root/js/lib/jquery-latest.min.js",
                    "root/js/lib/bootstrap.min.js",
                    "root/js/lib/leaflet.js",
                    "root/js/lib/leaflet-hash.js",
                    "root/js/lib/d3.v3.min.js",
                    "root/js/lib/topojson.v1.min.js",
                    "root/js/lib/TileLayer.custom_d3_geoJSON.js",
                    "root//d3js.org/d3.geo.tile.v0.min.js",
                    "root/js/lib/d3-bootstrap.min.js",
                    "root/js/lib/select2.js",
                    "root/js/lib/jquery.animate-colors-min.js",
                    "root/js/searchbar.js",
                ],
                dest: "root/js/site.js"
            }
        },
        cssmin: {
            css: {
                src: 'root/css/site.css',
                dest: 'root/css/site.min.css'
            }
        },
        uglify: {
            js: {
                files: {
                    'root/js/site.min.js': ['root/js/site.js']
                }
            }
        },
        filerev: {
            options: {
                encoding: 'utf8',
                algorithm: 'md5',
                length: 8
            },
            js: {
                src: 'root/js/site.min.js',
                dest: 'root/js'
            },
            css: {
                src: 'root/css/site.min.css',
                dest: 'root/css'
            }
        },
        userev: {
            css: { // Link to minified css in index html.
                src: 'root/templates/wrapper.tt',
                options: {
                    patterns: {
                        'Linking versioned css': /(css\/[a-z0-9.]*\.css)/,
                    },
                },
            },
            js: { // Link to minified css in index html.
                src: 'root/templates/wrapper.tt',
                options: {
                    patterns: {
                        'Linking versioned js': /(js\/[a-z0-9.]*\.js)/,
                    },
                },
            },
        }
    });

    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-filerev');
    grunt.loadNpmTasks('grunt-userev');

    // Default task(s).
    grunt.registerTask('default', ['concat', 'cssmin', 'uglify', 'filerev', 'userev']);
};

