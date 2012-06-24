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
