jQuery(document).ready(function(){

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
});
