function accountsListInit(account_type){
    resizeDataWrapper();
    jQuery(window).resize(function(){resizeDataWrapper();});

    jQuery('#field_id, #direction_id').change(function(){
        jQuery('#accountSortingFormId').submit();
    });

    jQuery('#accountSortingFormId').ajaxSuccess(function(evt, response, settings){
        jQuery('.data-wrapper').empty();
        jQuery('.data-wrapper').html(response.responseText);
    });

    //load accounts after page loading
    jQuery.ajax({
        url: '/accounts/load?type='+account_type
        }).done(function (doc, status, jqXHR ) {
            jQuery('.data-wrapper').empty();
            jQuery('.data-wrapper').html(jqXHR.responseText);
        });
};