var AccountsJS = function(){
    this.init = function(account_type){
        resizeDataWrapper();
        jQuery(window).resize(function(){
            resizeDataWrapper();
            accountsJS.resizeColumns();
        });

        jQuery('#field_id, #direction_id').change(function(){
            jQuery('#accountSortingFormId').submit();
        });

        jQuery('#accountSortingFormId').ajaxSuccess(function(evt, response, settings){
            accountsJS.handleResponse(response);
        });

        //load accounts after page loading
        jQuery.ajax({
            url: '/accounts/load?type='+account_type
        }).done(function (doc, status, jqXHR ) {
            accountsJS.handleResponse(jqXHR);
        });
    };

    this.handleResponse = function(response){
        jQuery('#dataWrapperID').empty();
        jQuery('#dataWrapperID').html(response.responseText);
        this.resizeColumns();
    };

    this.resizeColumns = function(){
        var dataItemWidth = jQuery('#dataTableID')[0].clientWidth;
        var buttonsColumnWidth = jQuery('#editButtonsHeaderID')[0].clientWidth;
        var amountColumnWidth = jQuery('#accountAmountHeaderID')[0].clientWidth;
        var nameColumnWidth = jQuery('#accountNameHeaderID')[0].clientWidth;
        var descriptionColumnWidth = dataItemWidth - buttonsColumnWidth - amountColumnWidth - nameColumnWidth - 35;

        jQuery('#accountDescriptionHeaderID').css("width", descriptionColumnWidth+"px");
        jQuery('.body-account-description').css("width", descriptionColumnWidth+"px");
    };
};
