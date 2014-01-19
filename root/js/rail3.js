var map = L.map('map', {maxZoom: 16});
var hash = new L.Hash(map);
if (!window.location.hash) {
    map.setView([29.7628, - 95.3831], 16);
}
var openStreet = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 16, attribution: "© <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>"}).addTo(map);
openStreet.addTo(map);
var baseLayers = {
	"OpenStreetMap": openStreet
};
var overlays = {};

function lineStyle(feature) {
    var lineWidth;

    switch (feature.properties.traffic_density) {
        case 7:
            lineWidth = 18;
        case 6:
            lineWidth = 14;
        case 5:
            lineWidth = 12;
        case 4:
            lineWidth = 10;
        case 3:
            lineWidth = 8;
        case 2:
            lineWidth = 6;
        case 1:
            lineWidth = 4;
        case 0:
            lineWidth = 4;
        default:
            lineWidth = 4;
    }
    return "stroke-width: " + (lineWidth * map.getZoom()/16) + "px;";
}

function calculateClass(feature) {
    var className = "rail-line";
    if (feature.properties && feature.properties.reporting_mark) {
    }
    return className;
}

function onEachFeature(feature, layer) {
    var popup = "<strong>Route:</strong> " + (feature.properties.name ? feature.properties.name : "Unknown") + "<br /><strong>Operator:</strong> " + (feature.properties.owner ? feature.properties.owner : "Unknown") + (feature.properties.reporting_mark ? "(" + feature.properties.reporting_mark + ")" : "");
    layer.bindPopup(popup);
}

new L.geoJson({"type":"LineString","coordinates":[[0,0],[0,0]]}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/lines/{z}/{x}/{y}.json";
var lineLayer = new L.TileLayer.d3_geoJSON(geojsonURL, {
  class: calculateClass,
  style: lineStyle,
  onEachFeature: onEachFeature
});
map.addLayer(lineLayer);
overlays["Rail Lines"] = lineLayer;

L.control.layers(baseLayers, overlays).addTo(map);
