var map = L.map('map').setView([29.7628, - 95.3831], 15);
var openStreet = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
var baseLayers = {
	"OpenStreetMap": openStreet
};
var overlays = {};

function project(point) {
	var latlng = new L.LatLng(point[1], point[0]);
	var layerPoint = map.latLngToLayerPoint(latlng);
	return [layerPoint.x, layerPoint.y];
}

var svgContainer = d3.select(map.getPanes().overlayPane).append("svg");

var railLineGroup = svgContainer.append("g").attr("class", "leaflet-zoom-hide");
var railNodeGroup = svgContainer.append("g").attr("class", "leaflet-zoom-hide");
var railInterlineGroup = svgContainer.append("g").attr("class", "leaflet-zoom-hide");

var path = d3.geo.path().projection(project);

d3.json("na-rail-lines.json", function(collection) {

	var feature;
    setFeature();
    reset();
	var bounds = d3.geo.bounds(collection);

	map.on("viewreset", reset);
	map.on("dragend", reset);
	map.on("moveend", reset);

    var mouseDown = function(d) {
        var coordinates = d3.mouse(this);
        L.popup()
            .setLatLng(map.layerPointToLatLng(coordinates))
            .setContent("<strong>Route:</strong> "
                 + d.properties.RTID
                 + "<br /><strong>Operator:</strong> "
                 + d.properties.W1)
            .openOn(map);
    };

	feature.on("mousedown", mouseDown);

	function reset() {
		bounds = [
            [map.getBounds()._southWest.lng, map.getBounds()._southWest.lat],
            [map.getBounds()._northEast.lng, map.getBounds()._northEast.lat]
        ];
		var bottomLeft = project(bounds[0]);
		var topRight = project(bounds[1]);

		svgContainer.attr("width", topRight[0] - bottomLeft[0])
            .attr("height", bottomLeft[1] - topRight[1])
            .style("margin-left", bottomLeft[0] + "px")
            .style("margin-top", topRight[1] + "px");

		railLineGroup.attr("transform", "translate(" + - bottomLeft[0] + "," + - topRight[1] + ")");
		feature.attr("d", path);
	}

    function setFeature() {
        feature = railLineGroup.selectAll("path")
            .data(collection.features)
            .enter()
            .append("path")
            .attr("id", "rail-lines-overlay")
            .attr("class", function(d) {
                return "rail-line " + (d.properties.owner ? d.properties.owner.reporting_mark : "");
            })
            .on("mousedown", mouseDown);
    }

    var lineLayer = L.Class.extend({

        initialize: function () {
            return;
        },

        onAdd: function (map) {
            railLineGroup.style("display", "block");
        },

        onRemove: function (map) {
            railLineGroup.style("display", "none");
        },
    });

    var railLineLayer = new lineLayer();

    overlays["Rail Lines"] = railLineLayer;

    L.control.layers(baseLayers, overlays).addTo(map);
});
