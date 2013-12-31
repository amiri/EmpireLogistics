var width = 1000,
        height = 2000;

var svg = d3.select("body").append("svg")
    .attr("width", width)
        .attr("height", height);

var projection = d3.geo.mercator()
    .scale(40)
    .translate([width / 2, height / 2]);

var path = d3.geo.path()
    .projection(projection);

d3.json("na-rail-links.json", function(error, links) {

    console.log(links);

    //svg.append("path")
        //.datum(topojson.mesh(links, links.features))
        //.attr("class", "lines")
        //.attr("d", d3.geo.path());


    //svg.append("path")
        //.datum({type: "MultiLineString", features: links.features})
        //.attr("d", d3.geo.path());


    svg.selectAll("path")
        .data(links.features)
        .enter()
        .append("path")
        //.attr("class", function(d) {
            ////console.log(d);
            //return "rail-link";
        //})
        .attr("d", d3.geo.path());


    //svg.selectAll("path")
        //.datum(topojson.mesh(links, links))
        ////.enter().append("path")
        ////.attr("class", function(d) {
            //////console.log(d);
            ////return "rail-link";
        ////})
        //.attr("d", path);

});
