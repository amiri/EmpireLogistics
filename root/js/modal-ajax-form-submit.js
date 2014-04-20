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
            }
        });

        event.preventDefault();
    });
});

