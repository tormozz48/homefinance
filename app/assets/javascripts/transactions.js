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
    resizeDataWrapper(180);
    jQuery(window).resize(function(){resizeDataWrapper(180);});

    initDatePickersInForm("transactionFilterFormId");

    jQuery('#category_id, #field_id, #direction_id').change(function(){
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

function toggleFilter(){
  if(jQuery('#transactionFilterFormId').css("display") == "none"){
    resizeDataWrapper(205);
    jQuery('#transactionFilterFormId').show();
    jQuery(window).resize(function(){resizeDataWrapper(205);});
  }else{
    resizeDataWrapper(180);
    jQuery('#transactionFilterFormId').hide();
    jQuery(window).resize(function(){resizeDataWrapper(180);});
  }
};
