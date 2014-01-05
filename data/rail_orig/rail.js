var width = 1000,
height = 2000;

var projection = d3.geo.mercator().scale(400).translate([width / 2, height / 2]);

var path = d3.geo.path().projection(projection);

var svg = d3.select("body").append("svg").attr("width", width).attr("height", height).call(d3.behavior.zoom().translate(projection.translate()).scale(projection.scale()).on("zoom", redraw));

var axes = svg.append("g").attr("id", "axes"),
xAxis = axes.append("line").attr("y2", height),
yAxis = axes.append("line").attr("x2", width);

function redraw() {
	if (d3.event) {
		projection.translate(d3.event.translate).scale(d3.event.scale);
	}
	svg.selectAll("path").attr("d", path);
	var t = projection.translate();
	xAxis.attr("x1", t[0]).attr("x2", t[0]);
	yAxis.attr("y1", t[1]).attr("y2", t[1]);
}

d3.json("na-rail-lines.json", function(error, links) {
	svg.selectAll("path").data(links.features).enter().append("path").attr("class", function(d) {
		return "rail-line";
	}).attr("d", path);
});
