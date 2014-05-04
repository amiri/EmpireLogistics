$(document).ready(function() {
    $("#companies").select2({
        "multiple": true,
        "minimumInputLength": 3,
        "placeholder": 'Enter Companies Associated With Port',
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
        "placeholder": 'Enter Labor Organizations Associated With Port',
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
        "placeholder": 'Enter Labor Actions Associated With Port',
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
    });
});

