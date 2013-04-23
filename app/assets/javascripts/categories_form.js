CategoriesForm = function(config){
    this.init(config);
};

CategoriesForm.prototype = {

    config: null,

    init: function(config){
        this.config = config;

        mark_menu("menuCategoriesID");

        this.bind_submit_button();
        this.init_color_picker();
    },

    /**
     * Bind accounts form submitting on submit button click event
     */
    bind_submit_button: function(){
        var submit_button = jQuery('#submit');
        var form = jQuery('form');

        submit_button.click(function(){
            form.submit();
        });
    },

    /**
     * Init color picker widget for category color field
     */
    init_color_picker: function(){
        var color_field = jQuery('#category_color');

        color_field.css('background-color', '#'+ color_field.val());
        color_field.css('color', '#'+ color_field.val());

        color_field.ColorPicker({
            flat: false,
            onSubmit: function(hsb, hex, rgb, el) {
                var _el = jQuery(el);
                _el.val(hex);
                _el.css('color', '#'+hex);
                _el.css('background-color', '#'+hex);
                _el.ColorPickerHide();
            },
            onBeforeShow: function () {
                jQuery(this).ColorPickerSetColor(this.value);
            }
        });
    }
};
