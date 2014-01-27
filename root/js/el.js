var map = L.map('map', {
    maxZoom: 16
});
var hash = new L.Hash(map);
if (!window.location.hash) {
    map.setView([29.7628, -95.3831], 16);
}
var openStreet = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 16,
    attribution: "© <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>"
}).addTo(map);
openStreet.addTo(map);
var baseLayers = {
    "OpenStreetMap": openStreet
};
var overlays = {};

function railNodeRadius(feature) {
    var radius;
    radius = (feature.properties.incident_links ? ((feature.properties.incident_links * map.getZoom() / 16) * 2) : "4");
    return radius;
}

function warehouseRadius(feature) {
    var radius;
    radius = (feature.properties.area ? (((feature.properties.area* map.getZoom() / 16) / 500000) * 4) : "6");
    return radius;
}

function portRadius(feature) {
    var radius;
    radius = 4;
    return radius;
}

function railLineStyle(feature) {
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
    return "stroke-width: " + (lineWidth * map.getZoom() / 16) + "px;";
}

function calculateClass(feature) {
    var className = "rail-line";
    if (feature.properties && feature.properties.reporting_mark) {}
    return className;
}

function onEachFeature(feature, layer) {
    if (feature.properties) {
        var popup = "<strong>Route:</strong> " + (feature.properties.name ? feature.properties.name : "Unknown") + "<br /><strong>Operator:</strong> " + (feature.properties.owner ? feature.properties.owner : "Unknown") + (feature.properties.reporting_mark ? "(" + feature.properties.reporting_mark + ")" : "");
        layer.bindPopup(popup);
    }
}

// Rail lines
new L.geoJson({
    "type": "LineString",
    "coordinates": [
        [0, 0],
        [0, 0]
    ]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/rail_lines/{z}/{x}/{y}.json";
var lineLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: calculateClass,
    type: "path",
    style: railLineStyle
});
map.addLayer(lineLayer);
overlays["Rail Lines"] = lineLayer;

// Rail interlines
new L.geoJson({
    "type": "LineString",
    "coordinates": [
        [0, 0],
        [0, 0]
    ]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/rail_interlines/{z}/{x}/{y}.json";
var interlinesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-interline",
    type: "path",
    style: railLineStyle
});
map.addLayer(interlinesLayer);
overlays["Rail Interlines"] = interlinesLayer;


// Rail nodes
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/rail_nodes/{z}/{x}/{y}.json";
var nodesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-node",
    type: "circle",
    radius: railNodeRadius,
    fill: "red"
});
map.addLayer(nodesLayer);
overlays["Rail Nodes"] = nodesLayer;

// Warehouses
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/warehouses/{z}/{x}/{y}.json";
var warehouseLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "warehouse",
    type: "circle",
    radius: warehouseRadius,
    fill: "orange"
});
map.addLayer(warehouseLayer);
overlays["Warehouses"] = warehouseLayer;


// Ports 
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/ports/{z}/{x}/{y}.json";
var portLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "port",
    type: "circle",
    radius: portRadius,
    fill: "aqua"
});
map.addLayer(portLayer);
overlays["Ports"] = portLayer;





L.control.layers(baseLayers, overlays).addTo(map);
