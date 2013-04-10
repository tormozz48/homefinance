CategoriesIndex = function(config){
	this.init(config);
};

CategoriesIndex.prototype = {
	config: null,

    SORT_ASC: 'asc',
    SORT_DESC: 'desc',

    $data_wrapper: null,
    sort_field: null,
    sort_direction: null,

	init: function(config){
		this.config = config;

        this.$data_wrapper = jQuery('#data_wrapper');

        this.init_tooltip();

        mark_menu("menuCategoriesID");

        this.sort_field = 'name';
        this.sort_direction = this.SORT_ASC;

        var self = this;
        jQuery('.sorting-header').click(function(){
            var sort_field = jQuery(this).attr('data_field');

            if(self.sort_field == sort_field){
               self.sort_direction = self.sort_direction == self.SORT_ASC ? self.SORT_DESC : self.SORT_ASC;
            }else{
               self.sort_direction = self.SORT_ASC;
            }

            self.sort_field = sort_field;
            self.toggle_arrows();
            self.load_data();
        });

        this.load_data();
	},

    toggle_arrows: function(){
        jQuery('th > i').addClass('no-disp');

        var $sorted_header = jQuery('[data_field = "' + this.sort_field + '"]');
        if(this.sort_direction == this.SORT_ASC){
            $sorted_header.parent().children('.icon-arrow-up').removeClass('no-disp');
        }else{
            $sorted_header.parent().children('.icon-arrow-down').removeClass('no-disp');
        }
    },

    load_data: function(){
        var self = this;
        jQuery.ajax({
            url: "/categories/load",
            data: {field: this.sort_field, direction: this.sort_direction},
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
}