$(document).ready(function() {
    $('#list').dataTable({
        "sPaginationType": "bootstrap",
        "bServerSide": true,
        "sAjaxSource": $('#list').data('table-source'),
        "aoColumnDefs": [{
            "sType": "num-html",
            "aTargets": [0]
        }],
        "fnServerData": function(sSource, aoData, fnCallback, oSettings) {
            oSettings.jqXHR = $.ajax({
                "dataType": 'json',
                "type": "POST",
                "url": sSource,
                "data": aoData,
                "success": fnCallback
            });
        }
    });
});

