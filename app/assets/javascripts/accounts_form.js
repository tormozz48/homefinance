AccountsForm = function(config){
    this.init(config);
};

AccountsForm.prototype ={
    config: null,

    init: function(config){
        this.config = config;

        if(this.config.account_type == this.config.ACCOUNT_TYPE_CARD){
            mark_menu("menuAccountsID");
        }else if(this.config.account_type == this.config.ACCOUNT_TYPE_CASH){
            mark_menu("menuCashesID");
        }

        jQuery('#submit').click(function(){
            jQuery('form').submit();
        });
        //jQuery('.controls > .input-append > input, .controls > input, .controls > textarea').tooltip({placement: 'right'});
        //jQuery('.btn').tooltip();
    }
};