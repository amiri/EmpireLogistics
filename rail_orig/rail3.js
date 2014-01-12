var map = L.map('map', {maxZoom: 16});
var hash = new L.Hash(map);
if (!window.location.hash) {
    map.setView([29.7628, - 95.3831], 16);
}
var openStreet = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 16}).addTo(map);
openStreet.addTo(map);
var baseLayers = {
	"OpenStreetMap": openStreet
};
var overlays = {};

function lineStyle(feature) {
    var lineWidth;

    switch (feature.properties.densty) {
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
    //return "stroke-width: " + lineWidth + "px;";
}

new L.geoJson({"type":"LineString","coordinates":[[0,0],[0,0]]}).addTo(map);
var geojsonURL = "http://localhost:8888/lines/{z}/{x}/{y}.json";
var lineLayer = new L.TileLayer.d3_geoJSON(geojsonURL, {
  class: "rail-line",
  style: lineStyle,
});
map.addLayer(lineLayer);
overlays["Rail Lines"] = lineLayer;

L.control.layers(baseLayers, overlays).addTo(map);
