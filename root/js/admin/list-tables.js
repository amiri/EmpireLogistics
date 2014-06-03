$(document).ready(function() {
    $('#list').dataTable({
        "sPaginationType": "bootstrap",
        "aoColumnDefs": [{
            "sType": "num-html",
            "aTargets": [0]
        }]
    }).fnSetFilteringDelay(500);
});

