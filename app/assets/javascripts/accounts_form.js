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

        this.bind_submit_button();
    },

    /**
     * Bind accounts form submitting on submit button click event
     */
    bind_submit_button: function(){
        var submit_button = jQuery('#submit');
        var form = jQuery('form');

        submit_button.click(function(){
            form.submit();
        });
    }
};