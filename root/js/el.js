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

// Minimum radius of 4 px
function warehouseRadius(feature) {
    var defaultRadius = ((map.getZoom()/16) * 8);
    var radius = (defaultRadius > 4) ? ((map.getZoom()/16) * 8) : 4;
    if (feature.properties.area) {
        var area = feature.properties.area;
        area = area.replace(/\D/g,'');
        if (area.length == 0) {
            return radius;
        } else {
            radius = ((((area * map.getZoom() / 16) / 75000) * 1) > defaultRadius) ? (((area * map.getZoom() / 16) / 75000) * 1) : defaultRadius;
            return radius;
        }
    } else {
        return radius;
    }
}

// Minimum radius of 3 px
function portRadius(feature) {
    var defaultRadius = ((map.getZoom()/16) * 8);
    var radius = (defaultRadius > 3) ? defaultRadius : 3;
    if (feature.properties.total_tonnage) {
        var tonnage = feature.properties.total_tonnage;
        tonnage = tonnage.replace(/\D/g,'');
        if (tonnage.length == 0) {
            return radius;
        } else {
            radius = ((((tonnage * map.getZoom() / 16) / 3800000)) > defaultRadius) ? (((tonnage * map.getZoom() / 16) / 3800000)) : defaultRadius;
            return radius;
        }
    } else {
        return radius;
    }
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
function railLineTitle(d) {
    var html = "<span class='rail-line-bug'></span>"+d.properties.name;
    return html;
}
function railLinePopoverContent(d) {
    var html = "<dl class='dl-horizontal'>";
    if (d.properties.owner) { html += "<dt>Owner</dt><dd>"+ d.properties.owner+"</dd>";}
    if (d.properties.subdivision) { html += "<dt>Subdivision</dt><dd>"+ d.properties.subdivision+"</dd>";}
    if (d.properties.reporting_mark) { html += "<dt>Reporting Mark</dt><dd>"+ d.properties.reporting_mark+"</dd>";}
    if (d.properties.miles) { html += "<dt>Length</dt><dd>"+ d.properties.miles+" miles</dd>";}
    if (d.properties.density_detail) { html += "<dt>Freight Volume</dt><dd>"+ d.properties.density_detail+"</dd>";}
    html += "</dl>";
    return html;
}

function railInterlineTitle(d) {
    var html = "<span class='rail-interline-bug'><span>"+d.properties.junction_code;
    return html;
}
function railInterlinePopoverContent(d) {
    var html = "<dl class='dl-horizontal'>";
    if (d.properties.forwarding_node) { html += "<dt>Forwarding Node</dt><dd>"+ d.properties.forwarding_node+"</dd>";}
    if (d.properties.forwarding_node_owner) { html += "<dt>Forwarding Node Owner</dt><dd>"+ d.properties.forwarding_node_owner+"</dd>";}
    if (d.properties.receiving_node) { html += "<dt>Receiving Node</dt><dd>"+ d.properties.receiving_node+"</dd>";}
    if (d.properties.receiving_node_owner) { html += "<dt>Receiving Node Owner</dt><dd>"+ d.properties.receiving_node_owner+"</dd>";}
    if (d.properties.impedance) { html += "<dt>Impedance/Expense</dt><dd>"+ d.properties.impedance+"</dd>";}
    html += "</dl>";
    return html;
}

function railNodeTitle(d) {
    var html = "<span class='rail-node-bug'></span>"+d.properties.name;
    return html;
}
function railNodePopoverContent(d) {
    var html = "<dl class='dl-horizontal'>";
    if (d.properties.incident_links) { html += "<dt>Inbound links</dt><dd>"+ d.properties.incident_links+"</dd>";}
    html += "</dl>";
    return html;
}

function warehouseTitle(d) {
    var html = "<span class='warehouse-bug'></span>"+d.properties.name;
    return html;
}
function warehousePopoverContent(d) {
    var html = "<dl class='dl-horizontal'>";
    if (d.properties.owner) { html += "<dt>Owner</dt><dd>"+ d.properties.owner+"</dd>";}
    if (d.properties.description) { html += "<dt>Description</dt><dd>"+ d.properties.description+"</dd>";}
    if (d.properties.area) { html += "<dt>Square Footage</dt><dd>"+ d.properties.area+"</dd>";}
    if (d.properties.year_opened) { html += "<dt>Year Opened</dt><dd>"+ d.properties.year_opened+"</dd>";}
    html += "</dl>";
    return html;
}

function portTitle(d) {
    var html = "<span class='port-bug'></span>"+d.properties.name;
    return html;
}
function portPopoverContent(d) {
    var html = "<dl class='dl-horizontal'>";
    if (d.properties.harbor_size) { html += "<dt>Harbor Size</dt><dd>"+ d.properties.harbor_size+"</dd>";}
    if (d.properties.shelter) { html += "<dt>Shelter</dt><dd>"+ d.properties.shelter+"</dd>";}
    if (d.properties.cargo_pier_depth) { html += "<dt>Cargo Pier Depth</dt><dd>"+ d.properties.cargo_pier_depth+"</dd>";}
    if (d.properties.oil_terminal_depth) { html += "<dt>Oil Terminal Depth</dt><dd>"+ d.properties.oil_terminal_depth+"</dd>";}
    if (d.properties.max_vessel_size_from_port) { html += "<dt>Max Vessel Size</dt><dd>"+ d.properties.max_vessel_size_from_port+"</dd>";}
    if (d.properties.domestic_tonnage !== "Unknown") { html += "<dt>Domestic Tonnage</dt><dd>"+ d.properties.domestic_tonnage+" ("+ d.properties.year +")</dd>";}
    if (d.properties.foreign_tonnage !== "Unknown") { html += "<dt>Foreign Tonnage</dt><dd>"+ d.properties.foreign_tonnage+" ("+ d.properties.year +")</dd>";}
    if (d.properties.import_tonnage !== "Unknown") { html += "<dt>Import Tonnage</dt><dd>"+ d.properties.import_tonnage+" ("+ d.properties.year +")</dd>";}
    if (d.properties.export_tonnage !== "Unknown") { html += "<dt>Export Tonnage</dt><dd>"+ d.properties.export_tonnage+" ("+ d.properties.year +")</dd>";}
    if (d.properties.total_tonnage !== "Unknown") { html += "<dt>Total Tonnage</dt><dd>"+ d.properties.total_tonnage+" ("+ d.properties.year +")</dd>";}
    html += "</dl>";
    return html;
}

// Rail lines layer
new L.geoJson({
    "type": "LineString",
    "coordinates": [[0, 0], [0, 0]]
}).addTo(map);
var geojsonURL = "http://50.116.5.25/tiles/rail_lines/{z}/{x}/{y}.json";
var lineLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: railLineClass,
    type: "path",
    style: railLineStyle,
    attribution: 'Rail: <a href="http://cta.ornl.gov/transnet/index.html">CTA Transportation Networks</a>',
    title: railLineTitle,
    content: railLinePopoverContent,
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
var geojsonURL = "http://50.116.5.25/tiles/rail_interlines/{z}/{x}/{y}.json";
var interlinesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-interline",
    type: "path",
    style: railLineStyle,
    title: railInterlineTitle,
    content: railInterlinePopoverContent,
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
var geojsonURL = "http://50.116.5.25/tiles/warehouses/{z}/{x}/{y}.json";
var warehouseLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "warehouse",
    type: "circle",
    radius: warehouseRadius,
    attribution: 'Wal-Mart: <a href="http://www.mwpvl.com/">© MWPVL International Inc.</a>, Target: <a href="https://corporate.target.com/careers/global-locations/distribution-center-locations">© Target</a>',
    title: warehouseTitle,
    content: warehousePopoverContent,
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
var geojsonURL = "http://50.116.5.25/tiles/rail_nodes/{z}/{x}/{y}.json";
var nodesLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "rail-node",
    type: "circle",
    radius: railNodeRadius,
    fill: "red",
    title: railNodeTitle,
    content: railNodePopoverContent,
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
var geojsonURL = "http://50.116.5.25/tiles/ports/{z}/{x}/{y}.json";
var portLayer = new L.TileLayer.custom_d3_geoJSON(geojsonURL, {
    class: "port",
    type: "circle",
    radius: portRadius,
    fill: "dodgerblue",
    attribution: 'Ports: <a href="http://msi.nga.mil/NGAPortal/MSI.portal?_nfpb=true&_pageLabel=msi_portal_page_62&pubCode=0015">National Geospatial-Intelligence Agency</a>; TEU data: <a href="http://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_atlas_database/2013/points.html">USDOT Bureau of Transportation Statistics</a>',
    title: portTitle,
    content: portPopoverContent,
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
    elType = ["Rail Line", "Rail Node", "Rail Interline", "Port", "Costco", "Target", "Walmart", "Krogers", "Walgreens", "Amazon", "Home Depot"],
    color = ["black", "red", "goldenrod", "dodgerblue", "blueviolet", "fuchsia", "darkorange", "mediumslateblue", "limegreen", "forestgreen", "maroon"];

    for (var i = 0; i < 11; i++) {
        div.innerHTML += '<i style="background:' + color[i] + '"></i> ' + elType[i] + '<br>';
    }

    return div;
};

legend.addTo(map);

L.control.layers(baseLayers, overlays).addTo(map);

