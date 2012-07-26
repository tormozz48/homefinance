var CategoriesJS = function(){
    this.init = function(){
        resizeDataWrapper();
        jQuery(window).resize(function(){
            resizeDataWrapper();
            categoriesJS.resizeColumns();
        });

        jQuery('#field_id, #direction_id ').change(function(){
            jQuery('#categorySortingFormId').submit();
        });

        jQuery('#categorySortingFormId').ajaxSuccess(function(evt, response, settings){
           categoriesJS.handleResponse(response);
        });

        //load categories after page loading
        jQuery.ajax({
            url: '/categories/load'
        }).done(function (doc, status, jqXHR ) {
           categoriesJS.handleResponse(jqXHR);
        });
    };

    this.handleResponse = function(response){
        jQuery('#dataWrapperID').empty();
        jQuery('#dataWrapperID').html(response.responseText);
        this.resizeColumns();
    };

    this.resizeColumns = function(){
        var dataItemWidth = jQuery('.data-item')[0].clientWidth;
        var buttonsColumnWidth = 165;
        var colorColumnWidth = jQuery('.body-category-color')[0].clientWidth;
        var nameColumnWidth = jQuery('.body-category-name')[0].clientWidth;
        var descriptionColumnWidth = dataItemWidth - buttonsColumnWidth - colorColumnWidth - nameColumnWidth - 35;

        jQuery('#categoryDescriptionHeaderID').css("width", descriptionColumnWidth+"px");
        jQuery('.body-category-description').css("width", descriptionColumnWidth+"px");
    };

    this.formInit = function(){
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
    }
};

