AccountsIndex = function(config){
    this.init(config);
};

AccountsIndex.prototype = {
    config: null,

    SORT_ASC: 'asc',
    SORT_DESC: 'desc',

    $data_wrapper: null,
    sort_field: null,
    sort_direction: null,

    init: function(config){
        this.config = config;

        this.$data_wrapper = jQuery('#data_wrapper');

        if(this.config.account_type == this.config.ACCOUNT_TYPE_CARD){
            mark_menu("menuAccountsID");
        }else if(this.config.account_type == this.config.ACCOUNT_TYPE_CASH){
            mark_menu("menuCashesID");
        }

        this.sort_field = 'name';
        this.sort_direction = this.SORT_ASC;

        this.bind_sorting();
        this.load_data();
    },

    /**
     * Loads data from server by AJAX
     * with server-side sorting and
     * pastes received data into table body
     */
    load_data: function(){
        var self = this;
        jQuery.ajax({
            url: "/accounts/load",
            data: {
                    field: this.sort_field,
                    direction: this.sort_direction,
                    type: this.config.account_type
                  }
        }).done(function(data){
            self.$data_wrapper.empty().html(data);
            jQuery('.link-delete').unbind('click').on('click', function(){
                return self.del(this);
            });
        });
    },

    /**
     * Deletes record from table
     * We should send request to server via AJAX and
     * hide and remove row from table
     * @param obj - link object
     * @returns false for preventing link action
     */
    del: function(obj){
        if(confirm(this.config.delete_confirm)){
            var url = jQuery(obj).attr('href');
            var row = jQuery(obj).parents('tr');

            jQuery.when(jQuery.ajax({type: 'DELETE', url: url}),row.hide(400)).then(function(){
                row.remove();
            });
        }
        return false;
    },


    /**
     * Binds sorting functionality to table column headers
     */
    bind_sorting: function(){
        var self = this;
        jQuery('.sorting-header').click(function(){
            var sort_field = jQuery(this).attr('data_field');

            if(self.sort_field == sort_field){
                self.sort_direction =
                    self.sort_direction == self.SORT_ASC ? self.SORT_DESC : self.SORT_ASC;
            }else{
                self.sort_direction = self.SORT_ASC;
            }

            self.sort_field = sort_field;
            self.toggle_arrows();
            self.load_data();
        });
    },

    /**
     * Shows and hides sorting arrow indicators
     * on every column header click
     */
    toggle_arrows: function(){
        jQuery('th > i').addClass('no-disp');

        var sorted_header = jQuery('[data_field = "' + this.sort_field + '"]');
        if(this.sort_direction == this.SORT_ASC){
            sorted_header.parent().children('.icon-arrow-up').removeClass('no-disp');
        }else{
            sorted_header.parent().children('.icon-arrow-down').removeClass('no-disp');
        }
    }
};
