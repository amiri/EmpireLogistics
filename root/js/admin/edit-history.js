$(document).ready(function() {
    $('.edithistory').dataTable({
        "sPaginationType": "bootstrap",
        "aaSorting": [[0, "desc"]],
        "bDestroy": true
    }).fnSetFilteringDelay(500);
});

