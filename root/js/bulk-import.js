jQuery(function($) {
    $("a.sample-data").hide();
    $("#object_type").on('change', function(){
        var val = $(this).val();
        var sampleDataAnchor = $("a.sample-data");
        sampleDataAnchor.attr('href', '/admin/bulk-import/sample-csv/' + val);
        if (val === 'Warehouse') {
            $('<div class="col-md-12 alert-warning"><p><em>For warehouse data, you must provide a numeric owner ID.<br />Please check your CSV against the <a href="/admin/warehouse-owner">owners in our database</a>.</em></p></div>').insertAfter(sampleDataAnchor);
        }
        sampleDataAnchor.show();
    });
});
