$(document).ready(function() {
    $.ajax({
        type: "POST",
        url: $('#list').data('table-source') + '/column-definitions/',
        dataType: "json",
        success: function(columnData) {
            // Here we are inserting rendering functions for all columns.
            // There are special rendering functions for restore_delete
            // and edit_url, the latter of which is hidden.
            $.each(columnData, function(index, el) {
                if (el.mData === 'restore_delete') {
                    el['mRender'] = function(data, type, row) {
                        if (row.delete_time) {
                            var restoreURL = row.edit_url.replace(/edit/, 'restore');
                            return '<a class="btn btn-info" href="' + restoreURL + '"><i class="glyphicon-undo glyphicon-white"></i>Restore</a>';
                        } else {
                            var deleteURL = row.edit_url.replace(/edit/, 'delete');
                            return '<a class="btn btn-danger" href="' + deleteURL + '"><i class="glyphicon-trash glyphicon-white"></i>Delete</a>';
                        }
                    };
                }
                else if (el.mData === 'edit_url') {
                    el['mRender'] = function(data, type, row) {
                        return null;
                    };
                } else {
                    el['mRender'] = function(data, type, row) {
                        if (data) {
                            return '<a href="' + row.edit_url + '">' + data + '</a>';
                        } else {
                            return '';
                        }
                    };
                }
            });
            $('#list').dataTable({
                "sPaginationType": "bootstrap",
                "bServerSide": true,
                "bProcessing": true,
                "oLanguage": {
                    "sProcessing": '<div class="col-md-12 alert alert-info"><p>Processing...</p></div>'
                },
                "sAjaxSource": $('#list').data('table-source'),
                "aoColumnDefs": columnData,
                "fnServerData": function(sSource, aoData, fnCallback, oSettings) {
                    oSettings.jqXHR = $.ajax({
                        "dataType": 'json',
                        "type": "POST",
                        "url": sSource,
                        "data": aoData,
                        "success": function(json) {
                            fnCallback(json);
                        }
                    });
                }
            });
        }
    });
});

