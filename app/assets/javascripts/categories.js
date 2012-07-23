function categoriesListInit(){
    resizeDataWrapper();
    jQuery(window).resize(function(){resizeDataWrapper();});

    jQuery('#field_id, #direction_id ').change(function(){
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
            jQuery(el).val(hex);
            jQuery(el).css('color', '#'+hex);
            jQuery(el).css('background-color', '#'+hex);
            jQuery(el).ColorPickerHide();
        },
        onBeforeShow: function () {
            jQuery(this).ColorPickerSetColor(this.value);
        }
    });
};
