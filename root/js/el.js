var map = L.map('map', {
    maxZoom: 16
});
var hash = new L.Hash(map);
if (!window.location.hash) {
    map.setView([29.7628, -95.3831], 16);
}
var openStreet = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 16,
    attribution: "© <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap contributors</a>"
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
    if (feature && feature.properties && feature.properties.reporting_mark) {
        var subClass = feature.properties.reporting_mark;
        subClass = subClass.replace(/[^\w]|_|\s/g, "");
        if (subClass.length > 0) {
            className += " " + subClass;
        }
    }
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
    class: calculateClass
  , type: "path"
  , style: railLineStyle
  , attribution: 'Rail: <a href="http://cta.ornl.gov/transnet/index.html">CTA Transportation Networks</a>'
});
// Put this one on the bottom with "true"
map.addLayer(lineLayer, true);
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
    class: "rail-interline"
  , type: "path"
  , style: railLineStyle
});
map.addLayer(interlinesLayer);
overlays["Rail Interlines"] = interlinesLayer;

// Warehouses
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/warehouses/{z}/{x}/{y}.json";
var warehouseLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "warehouse"
  , type: "circle"
  , radius: warehouseRadius
  , fill: "darkorange"
  , attribution: 'Wal-Mart: <a href="http://www.mwpvl.com/">© MWPVL International Inc.</a>; Target: <a href="https://corporate.target.com/careers/global-locations/distribution-center-locations">© Target</a>'
});
map.addLayer(warehouseLayer);
overlays["Warehouses"] = warehouseLayer;

// Rail nodes
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/rail_nodes/{z}/{x}/{y}.json";
var nodesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-node"
  , type: "circle"
  , radius: railNodeRadius
  , fill: "red"
});
map.addLayer(nodesLayer);
overlays["Rail Nodes"] = nodesLayer;

// Ports 
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/ports/{z}/{x}/{y}.json";
var portLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "port"
  , type: "circle"
  , radius: portRadius
  , fill: "dodgerblue"
  , attribution: 'Ports: <a href="http://msi.nga.mil/NGAPortal/MSI.portal?_nfpb=true&_pageLabel=msi_portal_page_62&pubCode=0015">National Geospatial-Intelligence Agency</a>'
});
map.addLayer(portLayer);
overlays["Ports"] = portLayer;


// Legend
var legend = L.control({position: 'bottomright'});

legend.onAdd = function (map) {

    var div = L.DomUtil.create('div', 'info legend'),
        elType = ["Rail Line", "Rail Node", "Rail Interline", "Warehouse", "Port" ],
        color = [ "black", "red", "goldenrod", "darkorange", "dodgerblue"];

    for (var i = 0; i < 5; i++) {
        div.innerHTML +=
            '<i style="background:' + color[i] + '"></i> ' + elType[i] + '<br>';
    }

    return div;
};

legend.addTo(map);



L.control.layers(baseLayers, overlays).addTo(map);
