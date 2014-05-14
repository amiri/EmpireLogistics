jQuery(function($) {
    function ajaxifyForm() {
        $('div.modal-body form').on('submit', function(event) {
            var $form = $(this);
            var $container = $('.modal.fade.in');
            var $target = $container.find('.modal-body');
            var objectType = $container.data('object-type');

            function successHandler(data, status) {
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
                if ($('#affiliates, #affiliations').length && typeof affiliationsOptions !== 'undefined') {
                    $('#affiliates, #affiliations').select2(affiliationsOptions);
                }

                if ($('#companies').length && typeof companiesOptions !== 'undefined') {
                    $('#companies').select2(companiesOptions);
                }

                if ($('#labor-organization-payee-single').length && typeof laborOrganizationPayeeSingleOptions !== 'undefined') {
                    $('#labor-organization-payee-single').select2(laborOrganizationPayeeSingleOptions);
                }

                if ($('#labor-organization-payees').length && typeof laborOrganizationPayeesOptions !== 'undefined') {
                    $('#labor-organization-payees').select2(laborOrganizationPayeesOptions);
                }

                if ($('#labor-organizations').length && typeof laborOrganizationsOptions !== 'undefined') {
                    $('#labor-organizations').select2(laborOrganizationsOptions);
                }

                if ($('#nlrb-decisions').length && typeof nlrbDecisionsOptions !== 'undefined') {
                    $('#nlrb-decisions').select2(nlrbDecisionsOptions);
                }

                if ($('#osha-citations').length && typeof oshaCitationsOptions !== 'undefined') {
                    $('#osha-citations').select2(oshaCitationsOptions);
                }

                if ($('#ports').length && typeof portsOptions !== 'undefined') {
                    $('#ports').select2(portsOptions);
                }

                if ($('#rail-lines').length && typeof railLinesOptions !== 'undefined') {
                    $('#rail-lines').select2(railLinesOptions);
                }

                if ($('#rail-nodes').length && typeof railNodesOptions !== 'undefined') {
                    $('#rail-nodes').select2(railNodesOptions);
                }

                if ($('#warehouses').length && typeof warehouseOptions !== 'undefined') {
                    $('#warehouses').select2(warehousesOptions);
                }

                if ($('#work-stoppages').length && typeof workStoppagesOptions !== 'undefined') {
                    $('#work-stoppages').select2(workStoppagesOptions);
                }
                if ($("#description").length) {
                    CKEDITOR.replace("description");
                }
                ajaxifyForm();
            };

            $.ajax({
                type: $form.attr('method'),
                url: $form.attr('action'),
                data: $form.serialize(),
                success: successHandler
            });
            event.preventDefault();
        });
    };
    ajaxifyForm();
});

