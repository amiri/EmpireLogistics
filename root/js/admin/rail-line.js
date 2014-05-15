var companiesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Companies Associated With Rail Line',
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
};
var laborOrganizationsOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Labor Organizations Associated With Rail Line',
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
var workStoppagesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Labor Actions Associated With Rail Line',
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
$(document).ready(function() {
    $("#work-stoppages").select2(workStoppagesOptions);
    $("#companies").select2(companiesOptions);
    $("#labor-organizations").select2(laborOrganizationsOptions);
});



