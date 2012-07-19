function categoriesListInit(){
    resizeDataWrapper();
    jQuery(window).resize(function(){resizeDataWrapper();});

    jQuery('#field_id').change(function(){
        jQuery('#categorySortingFormId').submit();
    });

    jQuery('#direction_id').change(function(){
        jQuery('#categorySortingFormId').submit();
    });

    jQuery('#categorySortingFormId').ajaxSuccess(function(evt, response, settings){
        jQuery('.data-wrapper').empty();
        jQuery('.data-wrapper').html(response.responseText);
    });

    //load categories after page loading
    jQuery.ajax({
        url: '/categories/load'
    }).done(function (doc, status, jqXHR ) {
        jQuery('.data-wrapper').empty();
        jQuery('.data-wrapper').html(jqXHR.responseText);
    });
};

function categoriesFormInit(){
    jQuery('#colorFieldId').css('background-color', '#'+jQuery('#colorFieldId').val());
    jQuery('#colorFieldId').css('color', '#'+jQuery('#colorFieldId').val());

    jQuery('#colorFieldId').ColorPicker({
        flat: false,
        onSubmit: function(hsb, hex, rgb, el) {
            $(el).val(hex);
            $(el).css('color', '#'+hex);
            $(el).css('background-color', '#'+hex);
            $(el).ColorPickerHide();
        },
        onBeforeShow: function () {
            $(this).ColorPickerSetColor(this.value);
        }
    });
};
