var map = L.map('map', {maxZoom: 16});
var hash = new L.Hash(map);
if (!window.location.hash) {
    map.setView([29.7628, - 95.3831], 16);
}
var openStreet = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 16}).addTo(map);
openStreet.addTo(map);

function lineStyle(feature) {
    return "stroke-width: " + (((feature.properties.miles > 10) ? 10 : feature.properties.miles < 1 ? 4 : feature.properties.miles) * map.getZoom()/16) + "px;";
}

new L.geoJson({"type":"LineString","coordinates":[[0,0],[0,0]]}).addTo(map);
var geojsonURL = "http://localhost:8080/lines/{z}/{x}/{y}.json";
var lineLayer = new L.TileLayer.d3_geoJSON(geojsonURL, {
  class: "rail-line",
  style: lineStyle,
});
map.addLayer(lineLayer);
