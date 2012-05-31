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

jQuery.fn.ForceNumericOnly =function(){
        return this.each(function(){
            jQuery(this).keydown(function(e){
                var key = e.charCode || e.keyCode || 0;
                // allow backspace, tab, delete, arrows, numbers and keypad numbers ONLY
                return (
                    key == 8 ||
                        key == 9 ||
                        key == 46 ||
                        (key >= 37 && key <= 40) ||
                        (key >= 48 && key <= 57) ||
                        (key >= 96 && key <= 105));
            });
        });
    };