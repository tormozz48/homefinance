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

    FORM_ERRORS_SELECTOR: '.form-errors',
    CONTROL_GROUP_SELECTOR: '.control-group',
    CLASS_SUCCESS: 'success',
    CLASS_ERROR: 'error',


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

        jQuery.datepicker.initialized = false;
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
                             alert(data);
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

        jQuery('#data_wrapper').html(data);

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

        var sum = 0;
        jQuery('.td-amount').each(function(){
            sum += +jQuery(this).html();
        });
        jQuery('.total-amount > span').html(sum)
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
                .on("ajax:beforeSend", function(){
                    return self.validate();
                })
                .on("ajax:success", function(evt, data, status, xhr) {
                    if(xhr.status == 200){
                        self.load_data();
                        jQuery('.form-container > .modal').modal('hide');
                    }else{
                        jQuery(this.FORM_ERRORS_SELECTOR).children('ul').empty();
                        for(var field in data){
                            jQuery('#'+field).parents(self.CONTROL_GROUP_SELECTOR)
                                .removeClass(self.CLASS_SUCCESS).addClass(self.CLASS_ERROR);
                            self.append_error_message(data[field]);
                        }
                        jQuery(self.FORM_ERRORS_SELECTOR).removeClass('no-disp');

                    }
                })
                .on("ajax:error", function(xhr, data, status) {
                    alert(data);
                });

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
    },

    /**
     * JS validation for transaction form before submitting it to server
     * @returns {boolean} - status of form validation
     */
    validate: function(){
        jQuery(this.FORM_ERRORS_SELECTOR).children('ul').empty();

        var v1 = this.validate_amount();
        var v2 = this.validate_account_from();
        var v3 = this.validate_account_to();
        var v4 = this.validate_category();

        var result =  v1 && v2 && v3 && v4;

        if(!result){
            jQuery(this.FORM_ERRORS_SELECTOR).removeClass('no-disp');
        }else{
            jQuery(this.FORM_ERRORS_SELECTOR).addClass('no-disp');
        }
        return result;
    },

    /**
     * Validates value of amount form field
     * @returns {boolean} - status of form validation
     */
    validate_amount: function(){
        var valid = true;
        var amount_field = jQuery('#amount');
        var amount_group = amount_field.parents(this.CONTROL_GROUP_SELECTOR);
        var amount = jQuery.trim(amount_field.val());
        var form_errors = jQuery(this.FORM_ERRORS_SELECTOR);

        amount_group.removeClass(this.CLASS_SUCCESS).removeClass(this.CLASS_ERROR);
        if(amount.length == 0 || !jQuery.isNumeric(amount) || !(amount > 0)){
            valid = false;
            amount_group.addClass(this.CLASS_ERROR);
            if(amount.length == 0){
                this.append_error_message(this.config.errors.transaction.amount.blank);
            }
            if(!jQuery.isNumeric(amount)){
                this.append_error_message(this.config.errors.transaction.amount.format);
            }
            if(!(amount > 0)){
                this.append_error_message(this.config.errors.transaction.amount.negative);
            }
        }else{
            amount_group.addClass(this.CLASS_SUCCESS);
        }
        return valid;
    },

    /**
     * Validates value of account from select form field
     * @returns {boolean} - status of form validation
     */
    validate_account_from: function(){
        var valid = true;
        if([this.config.TR_FROM_ACCOUNT_TO_ACCOUNT,
            this.config.TR_FROM_ACCOUNT_TO_CASH,
            this.config.TR_FROM_ACCOUNT_TO_CATEGORY,
            this.config.TR_FROM_CASH_TO_ACCOUNT,
            this.config.TR_FROM_CASH_TO_CASH,
            this.config.TR_FROM_CASH_TO_CATEGORY].indexOf(this.type) > -1){

            var account_from_field = jQuery('#account_from');
            var account_from_group = account_from_field.parents(this.CONTROL_GROUP_SELECTOR);
            var account_from = account_from_field.val();

            account_from_group.removeClass(this.CLASS_SUCCESS).removeClass(this.CLASS_ERROR);
            if(account_from == null || account_from.length == 0){
                valid = false;
                account_from_group.addClass(this.CLASS_ERROR);
                this.append_error_message(this.config.errors.transaction.account.blank);
            }else{
                account_from_group.addClass(this.CLASS_SUCCESS);
            }
        }
        return valid;
    },

    /**
     * Validates value of account to select form field
     * @returns {boolean} - status of form validation
     */
    validate_account_to: function(){
        var valid = true;
        if([this.config.TR_FROM_ACCOUNT_TO_ACCOUNT,
            this.config.TR_FROM_ACCOUNT_TO_CASH,
            this.config.TR_FROM_CASH_TO_ACCOUNT,
            this.config.TR_FROM_CASH_TO_CASH].indexOf(this.type) > -1){

            var account_to_field = jQuery('#account_to');
            var account_to_group = account_to_field.parents(this.CONTROL_GROUP_SELECTOR);
            var account_to = account_to_field.val();

            account_to_group.removeClass(this.CLASS_SUCCESS).removeClass(this.CLASS_ERROR);
            if(account_to == null || account_to.length == 0){
                valid = false;
                account_to_group.addClass(this.CLASS_ERROR);
                this.append_error_message(this.config.errors.transaction.account.blank);
            }else{
                account_to_group.addClass(this.CLASS_SUCCESS);
            }
        }
        return valid;
    },

    /**
     * Validates value of category select form field
     * @returns {boolean} - status of form validation
     */
    validate_category: function(){
        var valid = true;
        if([this.config.TR_FROM_ACCOUNT_TO_CATEGORY,
            this.config.TR_FROM_CASH_TO_CATEGORY].indexOf(this.type) > -1){

            var category_field = jQuery('#category');
            var category_group = category_field.parents(this.CONTROL_GROUP_SELECTOR);
            var category = category_field.val();

            category_group.removeClass(this.CLASS_SUCCESS).removeClass(this.CLASS_ERROR);
            if(category == null || category.length == 0){
                valid = false;
                category_group.addClass(this.CLASS_ERROR);
                this.append_error_message(this.config.errors.transaction.category.blank);
            }else{
                category_group.addClass(this.CLASS_SUCCESS);
            }
        }
        return valid;
    },

    append_error_message: function(message){
        jQuery(this.FORM_ERRORS_SELECTOR).children('ul').append(
            '<li>' + message + '</li>'
        );
    }
};

