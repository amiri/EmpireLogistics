jQuery(function($) {
    $('form').on('submit', function(event) {
        var $form = $(this);
        var $container = $('.modal.fade.in');
        var $target = $container.find('.modal-body');
        var objectType = $container.data('object-type');

        $.ajax({
            type: $form.attr('method'),
            url: $form.attr('action'),
            data: $form.serialize(),
            success: function(data, status) {
                $target.html(data);
                $('.modal.fade.in').animate({
                    scrollTop: 0
                },
                'fast')
                $('<div class="alert alert-success"><p>' + objectType + ' updated</p></div>').insertAfter(".modal.fade.in .modal-header");
                $('.edithistory').dataTable({
                    "sPaginationType": "bootstrap",
                    "aaSorting": [[0, "desc"]],
                    "bDestroy": true
                });
                if ($('#affiliates, #affiliations') && typeof affiliationsOptions !== 'undefined') {
                    $('#affiliates, #affiliations').select2(affiliationsOptions);
                }

                if ($('#companies') && typeof companiesOptions !== 'undefined') {
                    $('#companies').select2(companiesOptions);
                }

                if ($('#labor-organization-payee-single') && typeof laborOrganizationPayeeSingleOptions !== 'undefined') {
                    $('#labor-organization-payee-single').select2(laborOrganizationPayeeSingleOptions);
                }

                if ($('#labor-organization-payees') && typeof laborOrganizationPayeesOptions !== 'undefined') {
                    $('#labor-organization-payees').select2(laborOrganizationPayeesOptions);
                }

                if ($('#labor-organizations') && typeof laborOrganizationsOptions !== 'undefined') {
                    $('#labor-organizations').select2(laborOrganizationsOptions);
                }

                if ($('#nlrb-decisions') && typeof nlrbDecisionsOptions !== 'undefined') {
                    $('#nlrb-decisions').select2(nlrbDecisionsOptions);
                }

                if ($('#osha-citations') && typeof oshaCitationsOptions !== 'undefined') {
                    $('#osha-citations').select2(oshaCitationsOptions);
                }

                if ($('#ports') && typeof portsOptions !== 'undefined') {
                    $('#ports').select2(portsOptions);
                }

                if ($('#rail-lines') && typeof railLinesOptions !== 'undefined') {
                    $('#rail-lines').select2(railLinesOptions);
                }

                if ($('#rail-nodes') && typeof railNodesOptions !== 'undefined') {
                    $('#rail-nodes').select2(railNodesOptions);
                }

                if ($('#warehouses') && typeof warehouseOptions !== 'undefined') {
                    $('#warehouses').select2(warehousesOptions);
                }

                if ($('#work-stoppages') && typeof workStoppagesOptions !== 'undefined') {
                    $('#work-stoppages').select2(workStoppagesOptions);
                }
            }
        });
        event.preventDefault();
    });
});

