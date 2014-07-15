var searchBarOptions = {
    "multiple": false,
    "minimumInputLength": 3,
    "escapeMarkup": function(m) {
        return m;
    },
    "ajax": {
        "url": '/autocomplete/search/',
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
    }
};
$(document).ready(function() {
    $("#topnav-search").select2(searchBarOptions);
    $('#topnav-search').on("select2-selecting", function(e) {
        var targetText = $($(e.object.text).get(0));
        if (targetText) {
            var targetHref = targetText[0].href;
            if (targetHref) {
                window.location = targetHref;
            }
        }
    });
});

