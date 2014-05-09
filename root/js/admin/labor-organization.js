var affiliationsOptions = {
    "multiple": true,
    "minimumInputLength": 3,
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
var portsOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Ports Associated With Organization',
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
    "placeholder": 'Enter RailNodes Associated With Organization',
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
    "placeholder": 'Enter Warehouses Associated With Organization',
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
var workStoppagesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Labor Actions Associated With Organization',
    "ajax": {
        "url": '/autocomplete/work-stoppages/',
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
            $.ajax("/autocomplete/work-stoppages-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};
var laborOrganizationPayeesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Payees Associated With Organization',
    "ajax": {
        "url": '/autocomplete/labor-organization-payees/',
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
            $.ajax("/autocomplete/labor-organization-payees-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};
var laborOrganizationPayeeSingleOptions = {
    "multiple": false,
    "minimumInputLength": 3,
    "placeholder": 'Enter Payee',
    "ajax": {
        "url": '/autocomplete/labor-organization-payees/',
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
            $.ajax("/autocomplete/labor-organization-payees-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }

};
$(document).ready(function() {
    $("#affiliates, #affiliations").select2(affiliationsOptions);
    $("#ports").select2(portsOptions);
    $("#rail-lines").select2(railLinesOptions);
    $("#rail-nodes").select2(railNodesOptions);
    $("#warehouses").select2(warehousesOptions);
    $("#work-stoppages").select2(workStoppagesOptions);
    $("#labor-organization-payees").select2(laborOrganizationPayeesOptions);
    $("#labor-organization-payee-single").select2(laborOrganizationPayeeSingleOptions);
});
