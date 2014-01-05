var width = 1500,
    height = 1160;

var projection = d3.geo.albers()
                .center([10,50])
                .rotate([105,0])
                .parallels([14,80])
                .scale(600)
                .translate([width/2, height/2]);
var path = d3.geo.path()
            .projection(projection);

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height);

d3.json("northAmerica.json", function(error, northAmerica) {
    var subunits = topojson.feature(northAmerica, northAmerica.objects.subunits);

    svg.selectAll(".subunit")
        .data(topojson.feature(northAmerica, northAmerica.objects.subunits).features)
      .enter().append("path")
        .attr("class", function(d) {
            var className = d.properties.name;
            className = className.replace(/\./gi,'');
            return "subunit " + className;
         })
        .attr("d", path);

  
    svg.append("path")
        .datum(topojson.mesh(northAmerica, northAmerica.objects.subunits, function(a,b){
                return a !== b && a.properties.name !== "Alaska";
            })
        )
        .attr("d", path)
        .attr("class", "subunit-boundary");


    svg.append("path")
        .datum(topojson.mesh(northAmerica, northAmerica.objects.subunits, function(a,b){
                return a === b && a.properties.name === "Alaska";
            })
        )
        .attr("d",path)
        .attr("class","subunit-boundary Alaska");


    //svg.append("path")
    //.datum(topojson.feature(northAmerica, northAmerica.objects.places))
    //.attr("d", path)
    //.attr("class", "place");

    //svg.selectAll(".place-label")
        //.data(topojson.feature(northAmerica, northAmerica.objects.places).features)
      //.enter().append("text")
        //.attr("class", "place-label")
        //.attr("transform", function(d) { return "translate(" + projection(d.geometry.coordinates) + ")"; })
        //.attr("dy", ".15em")
        //.text(function(d) { return d.properties.name; });


    //svg.selectAll(".place-label")
    //.attr("x", function(d) { return d.geometry.coordinates[0] > -1 ? 6 : -6; })
    //.style("text-anchor", function(d) { return d.geometry.coordinates[0] > -1 ? "start" : "end"; });

    svg.selectAll(".subunit-label")
    .data(topojson.feature(northAmerica, northAmerica.objects.subunits).features)
  .enter().append("text")
    .attr("class", function(d) { return "subunit-label " + d.id; })
    .attr("transform", function(d) { return "translate(" + path.centroid(d) + ")"; })
    .attr("dy", ".35em")
    .text(function(d) { return d.properties.name; });


});

    

