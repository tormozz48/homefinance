var AccountsJS = function(){
    this.init = function(account_type){

        jQuery('.btn, #field, #direction').tooltip();

        //mark menu items cards or cashes as active depending on account type
        if(account_type == ACCOUNT_TYPE_CARD){
            markMenuItemById("menuAccountsID");
        }else if(account_type == ACCOUNT_TYPE_CASH){
            markMenuItemById("menuCashesID");
        }

        //subscribe sorting form ajax success event
        jQuery('#field, #direction').change(function(){
            jQuery('#accountSortingFormId').submit();
        });

        //subscribe sorting form ajax success event
        jQuery('#accountSortingFormId').ajaxSuccess(function(evt, response, settings){
            accountsJS.handleResponse(response);
        });

        //initial loading of categories by soft submitting sorting form with default parameters
        jQuery('#accountSortingFormId').submit();
    };

    this.handleResponse = function(response){
        jQuery('#dataWrapperID').empty();
        jQuery('#dataWrapperID').html(response.responseText);
    };
};
