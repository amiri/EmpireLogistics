var portsOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Ports Associated With Labor Action',
    "ajax": {
        "url": '/autocomplete/ports/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/ports-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};
var railLinesOptions = {

    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter RailLines Associated With Labor Action',
    "ajax": {
        "url": '/autocomplete/rail-lines/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/rail-lines-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};
var railNodesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter RailNodes Associated With Labor Action',
    "ajax": {
        "url": '/autocomplete/rail-nodes/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/rail-nodes-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};
var warehousesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Warehouses Associated With Labor Action',
    "ajax": {
        "url": '/autocomplete/warehouses/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/warehouses-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};
var laborOrganizationsOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Labor Organizations Associated With This Labor Action',
    "ajax": {
        "url": '/autocomplete/labor-organizations/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/labor-organizations-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};

$(document).ready(function() {
    $("#ports").select2(portsOptions);
    $("#rail-lines").select2(railLinesOptions);
    $("#rail-nodes").select2(railNodesOptions);
    $("#warehouses").select2(warehousesOptions);
    $("#labor-organizations").select2(laborOrganizationsOptions);
});

