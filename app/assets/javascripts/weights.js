function weightFormInit(){
    jQuery('#weightDateId').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#weightDateId').datepicker('hide')
        }
    });

    jQuery('#weightAmountId').ForceNumericOnly();

};
