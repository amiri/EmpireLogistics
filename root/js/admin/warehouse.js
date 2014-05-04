$(document).ready(function() {
    $("#companies").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter Companies Associated With This Warehouse',
        "ajax": {
            "url": '/autocomplete/companies/',
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
                $.ajax("/autocomplete/companies-ids/?q=" + val, {
                    dataType: "json",
                    method: 'POST'
                }).done(function(data) {
                    callback(data);
                });
            }
        }
    });
    $("#labor-organizations").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter Labor Organizations Associated With This Warehouse',
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
    });
    $("#work-stoppages").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter Labor Actions Associated With This Warehouse',
        "ajax": {
            "url": '/autocomplete/labor-actions/',
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
                $.ajax("/autocomplete/labor-actions-ids/?q=" + val, {
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
        "placeholder": 'Enter NLRB Decisions Associated With This Warehouse',
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
        "placeholder": 'Enter OSHA Citations Associated With Warehouse',
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


