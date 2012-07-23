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

function transactionsListInit(type){
    resizeDataWrapper(220);
    jQuery(window).resize(function(){resizeDataWrapper(220);});

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

    jQuery('#field_id').change(function(){
        jQuery('#transactionFilterFormId').submit();
    });

    jQuery('#direction_id').change(function(){
        jQuery('#transactionFilterFormId').submit();
    });

    jQuery('#transactionFilterFormId').ajaxSuccess(function(evt, request, settings){
        jQuery('.data-wrapper').empty();
        jQuery('.data-wrapper').html(request.responseText);
    });

    //load transactions after page loading
    jQuery.ajax({
        url: '/transactions/load?type='+type
    }).done(function (doc, status, jqXHR ) {
       jQuery('.data-wrapper').empty();
       jQuery('.data-wrapper').html(jqXHR.responseText);
    });
};
