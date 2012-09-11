var CategoriesJS = function(){
    this.init = function(){

        jQuery('.btn, #field, #direction').tooltip();

        //mark category menu item as active
        markMenuItemById("menuCategoriesID");

        //subscribe elements of sorting form for events
        jQuery('#field, #direction').change(function(){
            jQuery('#categorySortingFormId').submit();
        });

        //subscribe sorting form ajax success event
        jQuery('#categorySortingFormId').ajaxSuccess(function(evt, response, settings){
           categoriesJS.handleResponse(response);
        });

        //initial loading of categories by soft submitting sorting form with default parameters
        jQuery('#categorySortingFormId').submit();
    };

    this.handleResponse = function(response){
        jQuery('#dataWrapperID').empty();
        jQuery('#dataWrapperID').html(response.responseText);
        jQuery(".alert-success, .alert-error").fadeOut(5000);
    };

    this.formInit = function(){
        //mark category menu item as active
        markMenuItemById("menuCategoriesID");

        jQuery('.controls > input, .controls > textarea').tooltip({placement: 'right'});
        jQuery('.btn').tooltip();

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

