CategoriesForm = function(config){
    this.init(config);
};

CategoriesForm.prototype = {

    config: null,

    $color_field: null,

    init: function(config){
        this.config = config;
        this.$color_field = jQuery('#category_color');

        mark_menu("menuCategoriesID");

        jQuery('#submit').click(function(){
           jQuery('form').submit();
        });

        //jQuery('.controls > input, .controls > textarea').tooltip({placement: 'right'});
        //jQuery('.btn').tooltip();

        this.$color_field.css('background-color', '#'+ this.$color_field.val());
        this.$color_field.css('color', '#'+ this.$color_field.val());

        this.$color_field.ColorPicker({
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
