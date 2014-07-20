$(document).ready(function() {

    function updateProgress(e, div) {
        if (e.lengthComputable) {
            var percent = (e.loaded / e.total) * 100;
            div.html('Progress: ' + percent + '%');
        }
    };

    var handleImageUpload = function() {
        //console.log(arguments);
        // Remove error classes
        if ($("#server-error")) {
            $("#server-error").remove();
        }
        if ($("#size-error")) {
            $("#size-error").remove();
        }
        var itemID = $('#item_id').get(0);
        var itemIDVal = $(itemID).val();
        //console.log("Parent item id: " + itemIDVal);
        if (itemIDVal.length == 0) {
            var saveFirst = document.createElement("div");
            $(saveFirst).addClass("alert");
            $(saveFirst).html("<p>Please save your item.</p>");
            $(this).parent().parent().append($(saveFirst));
            return;
        }
        var fieldName = $(this).attr('id');
        var fieldPrefix = fieldName.replace(/\.file/, "");
        var fieldId = '#' + fieldPrefix;

        // Cannot select with $('#' + fieldPrefix)! Even after escaping...
        var field = $('div[id="' + fieldPrefix + '"]').get(0);
        if (field[0]) {
            field = field[0];
        }

        //console.log("Field we deal with: ");
        //console.log(field);
        //console.log("Field prefix: ");
        //console.log(fieldPrefix);

        // Get the media div and img inside so we can change it later.
        var mediaField = $(field).find(".media-image").get(0);
        var imageField = $(mediaField).find("img").get(0);

        //console.log("Media image field: ");
        //console.log(mediaField);
        //console.log("Media image image field: ");
        //console.log(imageField);

        // Get the media info div so we can put a progress bar in it.
        var mediaInfoField = $(field).find(".media-info").get(0);

        //console.log("Media Info field: ");
        //console.log(mediaInfoField);

        // Put the progress bar in the media
        var progressBar = document.createElement('div');
        $(progressBar).addClass('media-upload-progress');
        $(mediaInfoField).append($(progressBar));

        var fieldInputs = $(field).find("input,textarea");

        //console.log("Field inputs: ");
        //console.log(fieldInputs);

        // Declare form action and some tools we need
        var form = $(field).closest("form").get(0);
        //console.log("Form: ");
        //console.log(form);
        var formAction = $(form).attr('action') + '/add-item-media';
        //console.log("Form action: ");
        //console.log(formAction);
        var reader = new FileReader();
        var formData = new FormData();

        // Define our AJAX client
        var xhr = new XMLHttpRequest();
        if (xhr) {
            xhr.upload.addEventListener("progress", function(e) {
                updateProgress(e, $(progressBar));
            },
            false);
            xhr.onload = function() {
                $(progressBar).remove();
                var newData = JSON.parse(this.responseText);
                $(field).animate({
                    backgroundColor: "#dff0d8"
                }).animate({
                    backgroundColor: "#ffffff"
                },
                2000);
                for (var k in newData) {
                    var target = $(document).find("[id='" + fieldPrefix + "." + k + "']");
                    $(target).val(newData[k]);
                }
            };
            xhr.onerror = function(e) {
                var errorNotice = document.createElement('div');
                $(errorNotice).addClass('alert-error');
                var errorString = document.createElement("<p>A server-side error occurred: " + e.target.status + "</p>");
                $(errorNotice).append($(errorString));
                $(mediaInfoField).append($(errorNotice));
                $(field).animate({
                    backgroundColor: "#f2dede"
                }).animate({
                    backgroundColor: "#ffffff"
                },
                2000);
            };
        }

        // Configure AJAX client
        xhr.open('POST', formAction, true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

        // Start processing the image, and then after
        // it is loaded, gather the other params.
        if (this.files[0]) {
            //console.log("Abot to do something");
            var uploadField = this;
            reader.readAsDataURL(this.files[0]);
            reader.onloadend = function(e) {
                var result = e.target.result;
                // Pop in the new preview image
                if (result !== null) {
                    var container = $("[id='" + fieldPrefix + "']").get(0);
                    //Refetch the image container, in case it is new.
                    if (imageField) {
                        $(imageField).attr('src', result);
                    } else {
                        var imagePreview = $(container).find(".media-image").get(0);
                        if (imagePreview) {
                            var newImageField = document.createElement("img");
                            $(newImageField).attr('src', result);
                            $(imagePreview).prepend($(newImageField));
                        } else {
                            //var info = $(container).find('.controls').get(0);
                            var rm_button = $(container).find('span.rm_element').parent();
                            $(rm_button).detach();
                            $(info).addClass('col-lg-8');
                            $(info).addClass('media-info');
                            //$(info).removeClass('controls');
                            imagePreview = document.createElement("div");
                            imagePreviewImg = document.createElement("img");
                            $(imagePreview).addClass('media-image');
                            $(imagePreview).addClass('col-lg-4');
                            $(imagePreviewImg).attr('src', result);
                            $(imagePreview).append($(imagePreviewImg));
                            $(imagePreview).append($(rm_button));
                            $(container).prepend($(imagePreview));
                        }
                    }
                    var imageKey = $(uploadField).attr('name');
                    imageKey = imageKey.replace(fieldPrefix + ".", "");
                    // Could not get blob upload to work, so use base64
                    // encoding (dataURI).
                    formData.append(imageKey, result);

                    // Gather other form data
                    $(fieldInputs).each(function(index, el) {
                        var key = $(el).attr('name');
                        if (typeof key === 'undefined') {
                            key = 'blog_tag';
                        } else {
                            key = key.replace(fieldPrefix + ".", "");
                        }
                        var val = $(el).val();
                        if ($(el).attr('type') === 'file') {
                            return 1;
                        } else {
                            formData.append(key, val);
                        }
                    });

                    // Send data only after image has loaded
                    // and all FormData has been populated.
                    xhr.send(formData);
                }
            };
        } else {
            //console.log("Didn't do anything");
        }
    }
    $(document).on('change', '#media input[type="file"]', handleImageUpload);

});

