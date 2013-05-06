CategoriesIndex = function(config){
	this.init(config);
};

CategoriesIndex.prototype = {
	config: null,

    $data_wrapper: null,

	init: function(config){
		this.config = config;

        this.$data_wrapper = jQuery('#data_wrapper');

        mark_menu("menuCategoriesID");

        var _cs = sort('name', this, this.load_data);
        jQuery('.sorting-header').unbind('click').click(function(){
            _cs.sort(this);
            return false;
        });

        this.load_data(_cs.get_field(), _cs.get_direction());
    },

    /**
     * Loads data from server by AJAX
     * with server-side sorting and
     * pastes received data into table body
     */
    load_data: function(field, direction){
        var self = this;
        jQuery.ajax({
            url: "/categories/load",
            data: {
                    field: field,
                    direction: direction
                  }
            }
        ).done(function(data){
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
    }
};