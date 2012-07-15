function transactionFormInit(){
    jQuery('#transactionDateId').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#transactionDateId').datepicker('hide')
        }
    });

    jQuery('#transactionAmountId').ForceNumericOnly();
};

function transactionFilterFormInit(){
    jQuery.datepicker.setDefaults($.extend($.datepicker.regional["ru"]));
    jQuery('#date_from_id').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#date_to_id').datepicker('option', 'minDate', jQuery('#date_from_id').datepicker('getDate'));
            jQuery('#date_from_id').datepicker('hide');
            jQuery('#transactionFilterFormId').submit();
        }
    });
    jQuery('#date_to_id').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#date_from_id').datepicker('option', 'maxDate', jQuery('#date_to_id').datepicker('getDate'));
            jQuery('#date_to_id').datepicker('hide');
            jQuery('#transactionFilterFormId').submit();
        }
    });

    jQuery('#category_id').change(function(){
        jQuery('#transactionFilterFormId').submit();
    });
};
