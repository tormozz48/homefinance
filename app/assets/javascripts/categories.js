var CategoriesJS = function(){
    this.init = function(){

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

