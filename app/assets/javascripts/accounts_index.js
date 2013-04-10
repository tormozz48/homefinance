AccountsIndex = function(config){
    this.init(config);
};

AccountsIndex.prototype = {
    config: null,

    $data_wrapper: null,
    $sort_field: null,
    $sort_direction: null,

    init: function(config){
        this.config = config;
        //var self = this;

        this.$data_wrapper = jQuery('#data_wrapper');
        this.$sort_field = jQuery('#field');
        this.$sort_direction = jQuery('#direction');

//        this.init_tooltip();

        if(this.config.account_type == this.config.ACCOUNT_TYPE_CARD){
            mark_menu("menuAccountsID");
        }else if(this.config.account_type == this.config.ACCOUNT_TYPE_CASH){
            mark_menu("menuCashesID");
        }

//        this.$sort_field.chosen();
//        this.$sort_direction.chosen();
//
//        this.$sort_field.on('change', function(){
//            self.load_data();
//        });
//
//        this.$sort_direction.on('change', function(){
//            self.load_data();
//        });

        this.load_data();
    },

    load_data: function(){
        var field = this.$sort_field.val();
        var direction = this.$sort_direction.val();
        var self = this;
        jQuery.ajax({
            url: "/accounts/load",
            data: {field: field, direction: direction, type: this.config.account_type},
            success: function(data){
                self.handleResponse(data);
            }
        });
    },

    init_tooltip: function(){
        jQuery('.btn, #field, #direction').tooltip();
    },

    handleResponse: function(data){
        this.$data_wrapper.empty();
        this.$data_wrapper.html(data);
    }
};
