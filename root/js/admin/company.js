$(document).ready(function() {
    $("#ports").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter Ports Associated With Company',
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
    });
    $("#rail-nodes").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter RailNodes Associated With Company',
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
    });
    $("#warehouses").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter Warehouses Associated With Company',
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
    });
    $("#nlrb-decisions").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter NLRB Decisions Associated With This Company',
        "ajax": {
            "url": '/autocomplete/nlrb-decisions/',
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
                $.ajax("/autocomplete/nlrb-decisions-ids/?q=" + val, {
                    dataType: "json",
                    method: 'POST'
                }).done(function(data) {
                    callback(data);
                });
            }
        }
    });
    $("#osha-citations").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter OSHA Citations Associated With Company',
        "ajax": {
            "url": '/autocomplete/osha-citations/',
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
                $.ajax("/autocomplete/osha-citations-ids/?q=" + val, {
                    dataType: "json",
                    method: 'POST'
                }).done(function(data) {
                    callback(data);
                });
            }
        }
    });
});

