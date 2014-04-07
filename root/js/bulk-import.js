jQuery(function($) {
    $("a.sample-data").hide();
    $("#object_type").on('change', function(){
        var val = $(this).val();
        console.log("I selected something and the value is: "+val);
        var sampleDataAnchor = $("a.sample-data");
        sampleDataAnchor.attr('href', '/admin/bulk-import/sample-csv/' + val);
        sampleDataAnchor.show();
    });
});
