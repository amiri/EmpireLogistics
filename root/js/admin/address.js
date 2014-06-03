var countryOptions = {
    "multiple": false,
    "minimumInputLength": 3,
    "placeholder": 'Enter Country',
    "ajax": {
        "url": '/autocomplete/country/',
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
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/country-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                console.log(data);
                callback(data);
            });
        }
    }
};

var stateData = [];
var stateOptions = {
    "data": function() {
        return {
            results: stateData
        }
    },
    "allowClear": true,
    "multiple": false,
    "placeholder": 'Enter State',
    "initSelection": function(element, callback) {
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/state-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};
var cityData = [];
var cityOptions = {
    "data": function() {
        return {
            results: cityData
        }
    },
    "allowClear": true,
    "multiple": false,
    "placeholder": 'Enter City',
    "initSelection": function(element, callback) {
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/city-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};
var postalCodeData = [];
var postalCodeOptions = {
    "data": function() {
        return {
            results: postalCodeData
        }
    },
    "allowClear": true,
    "multiple": false,
    "placeholder": 'Enter Postal Code',
    "initSelection": function(element, callback) {
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/postal-code-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};

$(document).ready(function() {
    $(".country-select2").select2(countryOptions).on('change', function(e) {
        stateData = null;
        $.ajax("/autocomplete/state-options", {
            dataType: "json",
            data: {"country":e.val},
            method: "POST"
        }).done(function(data){
            stateData = data;
        });
    });
    $(".state-select2").select2(stateOptions).on('change', function(e) {
        cityData = null;
        postalCodeData = null;
        $.ajax("/autocomplete/city-and-postal-options", {
            dataType: "json",
            data: {"state":e.val},
            method: "POST"
        }).done(function(data){
            cityData = data.city;
            postalCodeData = data.postal;
        });
    });
    $(".city-select2").select2(cityOptions);
    $(".postal-code-select2").select2(postalCodeOptions);
});

