Transactions = function(config){
   this.init(config)
};

Transactions.prototype = {
    config: null,

    SORT_ASC: 'asc',
    SORT_DESC: 'desc',

    SORT_FIELD_DATE: 'date',

    MODE_EDIT: 'edit',
    MODE_VIEW: 'view',

    sort_field: null,
    sort_direction: null,

    type: null,
    mode: null,

    init: function(config){
        this.config = config;

        mark_menu("menuTransactionID");

        this.sort_field = this.SORT_FIELD_DATE;
        this.sort_direction = this.SORT_DESC;

        this.bind_switch_type_event();
        this.bind_filter_button_event();
    },

    /**
     * Binds click events to navigation buttons
     * for switch transaction type
     */
    bind_switch_type_event: function(){
        var self = this;
        jQuery('li.navigation-item > a').click(function(){

            /**
             * Remove active class from all navigation links
             * and mark selected link as active
             */
            jQuery('li.navigation-item > a').removeClass('btn-primary').addClass('btn-info');
            jQuery(this).removeClass('btn-info').addClass('btn-primary');

            //Send AJAX request to server
            jQuery.get(jQuery(this).attr('href')).done(function(data){

                //Paste table markup on page
                jQuery('.table-container').html(data);

                //set current selected transaction type to model
                self.type = jQuery('.table-container > table').attr('data-type');

                //bind add button click event
                jQuery('.link-add').unbind('click').on('click', function(){
                    self.show_form(this);
                    return false;
                });

                //bind sorting header click event for sorting table data
                jQuery('.sorting-header').unbind('click').click(function(){
                    var sort_field = jQuery(this).attr('data_field');

                    if(self.sort_field == sort_field){
                        self.sort_direction =
                            self.sort_direction == self.SORT_ASC ? self.SORT_DESC : self.SORT_ASC;
                    }else{
                        self.sort_direction = self.SORT_ASC;
                    }

                    self.sort_field = sort_field;

                    //toggle arrows in table headers for indicate current sorting state
                    jQuery('th > i').addClass('no-disp');

                    var sorted_header = jQuery('[data_field = "' + this.sort_field + '"]');
                    if(this.sort_direction == this.SORT_ASC){
                        sorted_header.parent().children('.icon-arrow-up').removeClass('no-disp');
                    }else{
                        sorted_header.parent().children('.icon-arrow-down').removeClass('no-disp');
                    }

                    self.load_data();
                });

                //loads data from server via AJAX
                self.load_data();
            });

            return false;
        });

        jQuery('.nav-pills > li:first > a').triggerHandler('click');
    },

    bind_filter_button_event: function(){
        var self = this;
        jQuery('.filter-item > a').click(function(){
            var url = jQuery(this).attr('href');
            jQuery.get(url, {type: self.type}).done(function(data){
                jQuery('.filter-container').empty().html(data);
                var modal_form = jQuery('.filter-container > .modal');
                modal_form.modal({
                    keyboard: true,
                    show: true
                });
                modal_form.on('shown', function(){
                    jQuery('#summa_min').ForceNumericOnly();
                    jQuery('#summa_max').ForceNumericOnly();

                    var date_from_selector = jQuery('#date_from');
                    var date_to_selector = jQuery('#date_to');

                    //bind date picker for date from field
                    date_from_selector.datepicker({
                        dateFormat: 'yy-mm-dd',
                        maxDate: new Date(),
                        changeMonth: true,
                        changeYear: true,
                        onSelect: function(dateText, inst) {
                            date_to_selector.datepicker('option', 'minDate', date_from_selector.datepicker('getDate'));
                            date_from_selector.datepicker('hide');
                        }
                    });

                    //bind date picker for date to field
                    date_to_selector.datepicker({
                        dateFormat: 'yy-mm-dd',
                        maxDate: new Date(),
                        changeMonth: true,
                        changeYear: true,
                        onSelect: function(dateText, inst) {
                            date_from_selector.datepicker('option', 'maxDate', date_to_selector.datepicker('getDate'));
                            date_to_selector.datepicker('hide');
                        }
                    });

                    jQuery('#filter_form')
                    .on("ajax:success", function(evt, data, status, xhr) {
                        if(xhr.status == 200){
                            self.handle_response(data);
                        }else{

                        }
                    })
                    .on("ajax:error", function(xhr, data, status) {

                    });

                    jQuery('#filter_submit').unbind('click').click(function(){
                        jQuery('#filter_form').submit();
                        jQuery('.filter-container > .modal').modal('hide');
                        return false;
                    });
                });
            });
            return false;
        });
    },

    /**
     * Loads transaction data from server via AJAX
     * At first we should set up request params from
     * default and optional additional params that can be set
     * @param params
     */
    load_data: function(params){
        var self = this;
        var default_params = {field: this.sort_field,
                              direction: this.sort_direction,
                              type: +this.type };

        var ajax_params = params != undefined ?
            jQuery.extend({}, default_params, params) : default_params;

        //send AJAX request to server
        jQuery.ajax({
            url: "/transactions/load",
            data: ajax_params,
            success: function(data){
                self.handle_response(data);
            }
        });
    },

    /**
     * Handle response callback for loading table data
     * @param data
     */
    handle_response: function(data){
        var self = this;
        //append data to tbody DOM elemen
        jQuery('#data_wrapper').hide(0, function(){
            jQuery('#data_wrapper').empty().html(data).fadeIn(500);
        });

        //bind popover to date color labels
        jQuery(".badge-black-font").popover({
            animation: true,
            html: true,
            placement: 'right',
            trigger: 'hover',
            title: this.config.color_popup_title,
            content: jQuery("#day_popup").html()
        });

        //bind click event handler for edit record link
        jQuery('.link-edit').unbind('click').on('click', function(){
            return self.show_form(this);
        });

        //bind click event handler to delete record link
        jQuery('.link-delete').unbind('click').on('click', function(){
            return self.del(this);
        });
    },

    /**
     * Show editing form for transaction
     * We should:
     * 1. send AJAX request to server
     * 2. Past received form html markup on special div on page
     * 3. Show form with twitter bootstrap modal
     * 4. Bind event handlers for AJAX form submitting
     * 5. Bind event handlers to form fields and buttons
     * @param obj - link object
     * @returns {boolean} false for preventing link action
     */
    show_form: function(obj){
        var self = this;
        jQuery.get(jQuery(obj).attr('href')).done(function(data){
            jQuery('.form-container').empty().html(data);

            var modal_form = jQuery('.form-container > .modal');
            modal_form.modal({
                keyboard: true,
                show: true
            });
            modal_form.on('shown', function(){
                jQuery('#transaction_form')
                .on("ajax:success", function(evt, data, status, xhr) {
                    if(xhr.status == 200){
                        self.load_data();
                        jQuery('.form-container > .modal').modal('hide');
                    }else{
                        alert(data);
                    }
                })
                .on("ajax:error", function(xhr, data, status) {
                    alert(data);
                });

                //amount field should accept only numbers
                jQuery('#amount').ForceNumericOnly();

                //bind click event to form submit button for form submitting
                //we should return false for preventing link action
                jQuery('#form_submit').click(function(){
                    jQuery('#transaction_form').submit();
                    return false;
                });
            });
        });
        return false;
    },

    /**
     * Deletes record from table
     * We should send request to server via AJAX and
     * hide and remove row from table
     * @param obj - link object
     * @returns false for preventing link action
     */
    del: function(obj){
        var self = this;
        if(confirm(this.config.delete_confirm)){
            var url = jQuery(obj).attr('href');
            var row = jQuery(obj).parents('tr');

            jQuery.when(jQuery.ajax({type: 'DELETE', url: url})).then(
            function(data, status, xhr){
                if(xhr.status === 200){
                    row.hide(400, function(){row.remove()});
                }else{
                    row.addClass('error-row');
                    setTimeout(function(){
                        row.removeClass('error-row');
                        alert(self.config.errors.transaction_delete)
                    }, 1000);
                }
            });
        }
        return false;
    }
};

