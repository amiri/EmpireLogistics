var portsOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Ports Associated With Company',
    "ajax": {
        "url": '/autocomplete/ports/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/ports-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};
var railNodesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter RailNodes Associated With Company',
    "ajax": {
        "url": '/autocomplete/rail-nodes/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/rail-nodes-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};
var warehousesOptions = {
    "multiple": true,
    "minimumInputLength": 3,
    "placeholder": 'Enter Warehouses Associated With Company',
    "ajax": {
        "url": '/autocomplete/warehouses/',
        "dataType": 'json',
        "type": 'POST',
        "width": 'element',
        "quietMillis": 100,
        "data": function(term, page) {
            return {
                "q": term,
                //search term
                "page_limit": 25,
                // page size
                "page": page // page number
            };
        },
        "results": function(data, page) {
            return {
                "results": data.results
            };
        }
    },
    "initSelection": function(element, callback) {
        // the input tag has a value attribute preloaded with values
        // this function resolves those id attributes to an object that select2 can render
        // using its formatResult renderer
        var val = $(element).val();
        if (val !== "") {
            $.ajax("/autocomplete/warehouses-ids/?q=" + val, {
                dataType: "json",
                method: 'POST'
            }).done(function(data) {
                callback(data);
            });
        }
    }
};

function updateProgress(e, div) {
    if (e.lengthComputable) {
        var percent = (e.loaded / e.total) * 100;
        div.html('Progress: ' + percent + '%');
    }
};

$(document).ready(function() {
    $("#ports").select2(portsOptions);
    $("#rail-nodes").select2(railNodesOptions);
    $("#warehouses").select2(warehousesOptions);

    var image = $($(".preview img").get(0)),
    $dataX1 = $("#data-x1"),
    $dataY1 = $("#data-y1"),
    $dataX2 = $("#data-x2"),
    $dataY2 = $("#data-y2"),
    $dataHeight = $("#data-height"),
    $dataWidth = $("#data-width");

    image.cropper({
        aspectRatio: 16 / 9,
        preview: ".img-preview",
        done: function(data) {
            $dataX1.val(data.x1);
            $dataY1.val(data.y1);
            $dataX2.val(data.x2);
            $dataY2.val(data.y2);
            $dataHeight.val(data.height);
            $dataWidth.val(data.width);
        }
    });
    image.cropper("enable");

    var handleImageCrop = function() {
        //console.log(arguments);
        var cropClick = arguments[0] == "cropClick" ? true: false;
        //console.log(cropClick);
        // Remove error classes
        if ($("#server-error")) {
            $("#server-error").remove();
        }
        if ($("#size-error")) {
            $("#size-error").remove();
        }
        //console.log(arguments);
        //console.log(this);
        var field = $($('#media-form input[type="file"]').get(0));

        //console.log(field);
        var fieldName = field.attr('id');
        var fieldPrefix = fieldName.replace(/\.file/, "");
        var fieldId = '#' + fieldPrefix;

        //console.log(fieldId);
        var fileWrapperDiv = $($(field).closest('.col-lg-5').get(0));
        var fieldSet = $($(field).closest('fieldset').get(0));

        // Get the media div and img inside so we can change it later.
        var mediaField = $(field).find(".img-container").get(0);
        var imageField = $(mediaField).find("img").get(0);

        //console.log(fileWrapperDiv);
        var progressBar = document.createElement('div');
        $(progressBar).addClass('media-upload-progress');
        $(fileWrapperDiv).append($(progressBar));

        var action = field.data('ajax-url');
        //console.log(action);
        var reader = new FileReader();
        var formData = new FormData();

        // Define AJAX client 
        var xhr = new XMLHttpRequest();
        if (xhr) {
            xhr.upload.addEventListener("progress", function(e) {
                updateProgress(e, $(progressBar));
            },
            false);
            xhr.onload = function() {
                $(progressBar).remove();
                var newData = JSON.parse(this.responseText);
                //console.log(newData);
                $(fieldSet).animate({
                    backgroundColor: "#dff0d8"
                }).animate({
                    backgroundColor: "#ffffff"
                },
                2000);
                for (var k in newData) {
                    var target = $(document).find("[id='" + k + "']");
                    $(target).val(newData[k]);
                }

                image.cropper("disable");
                var imageAjax = $($(".preview img").get(0)),
                $dataX1 = $("#data-x1"),
                $dataY1 = $("#data-y1"),
                $dataX2 = $("#data-x2"),
                $dataY2 = $("#data-y2"),
                $dataHeight = $("#data-height"),
                $dataWidth = $("#data-width");

                imageAjax.cropper({
                    aspectRatio: 16 / 9,
                    preview: ".img-preview",
                    data: {
                        width: 380
                    },
                    done: function(data) {
                        $dataX1.val(data.x1);
                        $dataY1.val(data.y1);
                        $dataX2.val(data.x2);
                        $dataY2.val(data.y2);
                        $dataHeight.val(data.height);
                        $dataWidth.val(data.width);
                    }
                });
                imageAjax.cropper("enable");
                //console.log(imageAjax);
            };
            xhr.onerror = function(e) {
                var errorNotice = document.createElement('div');
                $(errorNotice).addClass('alert-danger');
                $(errorNotice).attr("id", "server-error");
                var errorTag = document.createElement("p");
                var errorString = document.createTextNode("A server-side error occurred: " + e.target.status);
                errorTag.appendChild(errorString);
                $(errorNotice).append($(errorTag));
                $(fileWrapperDiv).append($(errorNotice));
                $(fieldSet).animate({
                    backgroundColor: "#f2dede"
                }).animate({
                    backgroundColor: "#ffffff"
                },
                2000);
            };
        }

        xhr.open('POST', action, true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        formData.append("id", $('#id').val());
        formData.append("uuid", $('#uuid').val());
        formData.append('data-x1', $dataX1.val());
        formData.append('data-y1', $dataY1.val());
        formData.append('data-x2', $dataX2.val());
        formData.append('data-y2', $dataY2.val());
        formData.append('data-height', $dataHeight.val());
        formData.append('data-width', $dataWidth.val());

        //console.log(field);
        if (document.getElementById('file').files[0] && ! cropClick) {
            //console.log("File upload");
            var uploadField = document.getElementById('file');
            var file = uploadField.files[0];
            //console.log(file.size);
            if (file.size > 5242880) {
                var errorNotice = document.createElement('div');
                $(errorNotice).addClass('alert-danger');
                $(errorNotice).attr("id", "size-error");
                var errorP = document.createElement("p");
                var errorText = document.createTextNode("File larger than 5MB (" + file.size + ")");
                errorP.appendChild(errorText);
                $(errorNotice).append($(errorP));
                $(fileWrapperDiv).append($(errorNotice));
                return false;
            }
            reader.readAsDataURL(uploadField.files[0]);
            reader.onloadend = function(e) {
                var result = e.target.result;
                //console.log("Result: ");
                //console.log(result);
                if (result !== null) {
                    if (imageField) {
                        $(imageField).attr('src', result);
                    } else {
                        var imagePreview = $(".img-container").get(0);
                        if (imagePreview) {
                            var newImageField = $(imagePreview).find('img').get(0);
                            $(newImageField).attr('src', result);
                        }
                    }
                    var imageKey = $(uploadField).attr('name');
                    // Could not get blob upload to work, so use base64
                    // encoding (dataURI).
                    //console.log($dataX1);
                    //console.log($dataY1);
                    //console.log($dataX2);
                    //console.log($dataY2);
                    //console.log($dataHeight);
                    //console.log($dataWidth);
                    formData.append("file", result);
                    xhr.send(formData);
                }
            };
        } else {
            //console.log("No file upload");
            xhr.send(formData);
        }

    }
    // Handle ajax uploads
    $(document).on('change', '#media-form input[type="file"]', handleImageCrop);
    $(document).on('click', '#media-form button#crop', function(e) {
        handleImageCrop("cropClick");
    });
    $(document).on('click', '#media-form button#disable-crop', function() {
        console.log("Disabled crop");
        image.cropper("disable");
        $('#media-form button#crop').on('click', function(){return false;});
        $('#media-form input[type="file"]').on('click', function(){return false});
    });
    $(document).on('click', '#media-form button#enable-crop', function() {
        console.log("Enabled crop");
        image.cropper("enable");
        $('#media-form button#crop').bind('click', function(e) {
            handleImageCrop("cropClick");
        });
        $('#media-form input[type="file"]').bind('change', handleImageCrop);
    });
});

