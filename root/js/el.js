var map = L.map('map', {
    maxZoom: 16
});
var hash = new L.Hash(map);
if (!window.location.hash) {
    map.setView([29.7628, - 95.3831], 16);
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
    radius = (feature.properties.area ? (((feature.properties.area * map.getZoom() / 16) / 500000) * 4) : "6");
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

function railLineClass(feature) {
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

// Mouseover functions for each layer
function railLineMouseover(d) {
    d3.select(this).classed("stroke-highlight", true);
}
function railLineMouseout(d) {
    d3.select(this).classed("stroke-highlight", false);
}
function railInterlineMouseover(d) {
    d3.select(this).classed("stroke-highlight", true);
}
function railInterlineMouseout(d) {
    d3.select(this).classed("stroke-highlight", false);
}
function railNodeMouseover(d) {
    d3.select(this).classed("fill-highlight", true);
}
function railNodeMouseout(d) {
    d3.select(this).classed("fill-highlight", false);
}
function portMouseover(d) {
    d3.select(this).classed("fill-highlight", true);
}
function portMouseout(d) {
    d3.select(this).classed("fill-highlight", false);
}
function warehouseMouseover(d) {
    d3.select(this).classed("fill-highlight", true);
}
function warehouseMouseout(d) {
    d3.select(this).classed("fill-highlight", false);
}

// Tooltip functions for each layer
function railLineTip(d) {
    var html = "<div class='container-fluid'><div class='row'><p><h5>"+d.properties.name+"</h5></p><p><ul class='list-unstyled'>";
    if (d.properties.owner) { html += "<li>Owner: "+ d.properties.owner+"</li>";}
    if (d.properties.subdivision) { html += "<li>Subdivision: "+ d.properties.subdivision+"</li>";}
    if (d.properties.reporting_mark) { html += "<li>Reporting Mark: "+ d.properties.reporting_mark+"</li>";}
    if (d.properties.miles) { html += "<li>Length: "+ d.properties.miles+" miles</li>";}
    if (d.properties.density_detail) { html += "<li>Freight Volume: "+ d.properties.density_detail+"</li>";}
    html += "</ul></div></div>";
    return html;
}

function railInterlineTip(d) {
    var html = "<div class='container-fluid'><div class='row'><p><h5>"+d.properties.junction_code+"</h5></p><p><ul class='list-unstyled'>";
    if (d.properties.forwarding_node) { html += "<li>Forwarding Node: "+ d.properties.forwarding_node+"</li>";}
    if (d.properties.forwarding_node_owner) { html += "<li>Forwarding Node Owner: "+ d.properties.forwarding_node_owner+"</li>";}
    if (d.properties.receiving_node) { html += "<li>Receiving Node: "+ d.properties.receiving_node+"</li>";}
    if (d.properties.receiving_node_owner) { html += "<li>Receiving Node Owner: "+ d.properties.receiving_node_owner+"</li>";}
    if (d.properties.impedance) { html += "<li>Impedance/Expense: "+ d.properties.impedance+"</li>";}
    html += "</ul></div></div>";
    return html;
}

function railNodeTip(d) {
    var html = "<div class='container-fluid'><div class='row'><p><h5>"+d.properties.name+"</h5></p><p><ul class='list-unstyled'>";
    if (d.properties.forwarding_node) { html += "<li>Inbound links: "+ d.properties.incident_links+"</li>";}
    html += "</ul></div></div>";
    return html;
}

function warehouseTip(d) {
    var html = "<div class='container-fluid'><div class='row'><p><h5>"+d.properties.name+"</h5></p><p><ul class='list-unstyled'>";
    if (d.properties.owner) { html += "<li>Owner: "+ d.properties.owner+"</li>";}
    if (d.properties.description) { html += "<li>Description: "+ d.properties.description+"</li>";}
    if (d.properties.area) { html += "<li>Square Footage: "+ d.properties.area+"</li>";}
    if (d.properties.year_opened) { html += "<li>Year Opened: "+ d.properties.year_opened+"</li>";}
    html += "</ul></div></div>";
    return html;
}

function portTip(d) {
    var html = "<div class='container-fluid'><div class='row'><p><h5>"+d.properties.name+"</h5></p><p><ul class='list-unstyled'>";
    if (d.properties.harbor_size) { html += "<li>Harbor Size: "+ d.properties.harbor_size+"</li>";}
    if (d.properties.shelter) { html += "<li>Shelter: "+ d.properties.shelter+"</li>";}
    if (d.properties.cargo_pier_depth) { html += "<li>Cargo Pier Depth: "+ d.properties.cargo_pier_depth+"</li>";}
    if (d.properties.oil_terminal_depth) { html += "<li>Oil Terminal Depth: "+ d.properties.oil_terminal_depth+"</li>";}
    if (d.properties.max_vessel_size_from_port) { html += "<li>Max Vessel Size: "+ d.properties.max_vessel_size_from_port+"</li>";}
    html += "</ul></div></div>";
    return html;
}

// Rail lines layer
new L.geoJson({
    "type": "LineString",
    "coordinates": [[0, 0], [0, 0]]
}).addTo(map);
var geojsonURL = "http://localhost/tiles/rail_lines/{z}/{x}/{y}.json";
var lineLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: railLineClass,
    type: "path",
    style: railLineStyle,
    attribution: 'Rail: <a href="http://cta.ornl.gov/transnet/index.html">CTA Transportation Networks</a>',
    tip: railLineTip,
    mouseover: railLineMouseover,
    mouseout: railLineMouseout
});
// Put this one on the bottom with "true"
map.addLayer(lineLayer, true);
overlays["Rail Lines"] = lineLayer;

// Rail interlines layer
new L.geoJson({
    "type": "LineString",
    "coordinates": [[0, 0], [0, 0]]
}).addTo(map);
var geojsonURL = "http://localhost/tiles/rail_interlines/{z}/{x}/{y}.json";
var interlinesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-interline",
    type: "path",
    style: railLineStyle,
    tip: railInterlineTip,
    mouseover: railInterlineMouseover,
    mouseout: railInterlineMouseout
});
map.addLayer(interlinesLayer);
overlays["Rail Interlines"] = interlinesLayer;

// Warehouses layer
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://localhost/tiles/warehouses/{z}/{x}/{y}.json";
var warehouseLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "warehouse",
    type: "circle",
    radius: warehouseRadius,
    attribution: 'Wal-Mart: <a href="http://www.mwpvl.com/">© MWPVL International Inc.</a>, Target: <a href="https://corporate.target.com/careers/global-locations/distribution-center-locations">© Target</a>',
    tip: warehouseTip,
    mouseover: warehouseMouseover,
    mouseout: warehouseMouseout
});
map.addLayer(warehouseLayer);
overlays["Warehouses"] = warehouseLayer;

// Rail nodes layer
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://localhost/tiles/rail_nodes/{z}/{x}/{y}.json";
var nodesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-node",
    type: "circle",
    radius: railNodeRadius,
    fill: "red",
    tip: railNodeTip,
    mouseover: railNodeMouseover,
    mouseout: railNodeMouseout
});
map.addLayer(nodesLayer);
overlays["Rail Nodes"] = nodesLayer;

// Ports layer
new L.geoJson({
    "type": "Point",
    "coordinates": [0, 0]
}).addTo(map);
var geojsonURL = "http://localhost/tiles/ports/{z}/{x}/{y}.json";
var portLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "port",
    type: "circle",
    radius: portRadius,
    fill: "dodgerblue",
    attribution: 'Ports: <a href="http://msi.nga.mil/NGAPortal/MSI.portal?_nfpb=true&_pageLabel=msi_portal_page_62&pubCode=0015">National Geospatial-Intelligence Agency</a>',
    tip: portTip,
    mouseover: portMouseover,
    mouseout: portMouseout
});
map.addLayer(portLayer);
overlays["Ports"] = portLayer;

// Legend
var legend = L.control({
    position: 'bottomright'
});

legend.onAdd = function(map) {

    var div = L.DomUtil.create('div', 'info legend'),
    elType = ["Rail Line", "Rail Node", "Rail Interline", "Port", "Costco", "Target", "Walmart", "Krogers", "Walgreens"],
    color = ["black", "red", "goldenrod", "dodgerblue", "blueviolet", "fuchsia", "darkorange", "mediumslateblue", "limegreen"];

    for (var i = 0; i < 9; i++) {
        div.innerHTML += '<i style="background:' + color[i] + '"></i> ' + elType[i] + '<br>';
    }

    return div;
};

legend.addTo(map);

L.control.layers(baseLayers, overlays).addTo(map);

