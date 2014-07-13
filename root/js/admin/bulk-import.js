jQuery(function($) {
    $(".sample-data").hide();
    $("#object_type").on('change', function() {
        var val = $(this).val();
        var sampleDataAnchor = $(".sample-data a");
        var  sampleDataP = $(".sample-data p");
        sampleDataAnchor.attr('href', '/admin/bulk-import/sample-csv/' + val);
        if (val === 'Warehouse') {
            $('<p><em>For warehouse data, you must provide a numeric owner ID.<br />Please check your CSV against the <a href="/admin/warehouse-owner">owners in our database</a>.</em></p>').insertAfter(sampleDataP);
        }
        $(".sample-data").show();
    });
});

