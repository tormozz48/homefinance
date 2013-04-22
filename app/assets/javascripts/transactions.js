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
      var self = this;

      mark_menu("menuTransactionID");

      this.sort_field = this.SORT_FIELD_DATE;
      this.sort_direction = this.SORT_DESC;

      jQuery('li.navigation-item > a').click(function(){
          jQuery('li.navigation-item > a').removeClass('btn-primary').addClass('btn-info');
          jQuery(this).removeClass('btn-info').addClass('btn-primary');
          self.switch_transaction_type(this);
          return false;
      });

      jQuery('.nav-pills > li:first > a').triggerHandler('click');

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
                 self.after_filter_shown();
              });
          });
          return false;
      });
  },

  after_filter_shown: function(){
      var self = this;

      jQuery('#summa_min').ForceNumericOnly();
      jQuery('#summa_max').ForceNumericOnly();

      var date_from_selector = jQuery('#date_from');
      var date_to_selector = jQuery('#date_to');

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

      //jQuery('#account_from, #account_to, #cash_from, #cash_to, #category').chosen();

      jQuery('#filter_form')
      .on("ajax:beforeSend", function(){

      })
      .on("ajax:loading",  function(){

      })
      .on("ajax:complete", function(){

      })
      .on("ajax:success", function(evt, data, status, xhr) {
          if(xhr.status == 200){
            self.handle_response(data);
          }else{

          }
      })
      .on("ajax:error", function(xhr, data, status) {
        //console.log('error');
      });

      jQuery('#filter_submit').unbind('click').click(function(){
          jQuery('#filter_form').submit();
          jQuery('.filter-container > .modal').modal('hide');
          return false;
      });

  },

  switch_transaction_type: function(obj){
     var self = this;
     var url = jQuery(obj).attr('href');
     jQuery.get(url).done(function(data){
         jQuery('.table-container').html(data);

         self.type = jQuery('.table-container > table').attr('data-type');

         jQuery('.link-add').unbind('click').on('click', function(){
             self.show_form(this);
             return false;
         });

         jQuery('.sorting-header').unbind('click').click(function(){
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

         self.load_data();
     });
  },

  load_data: function(params){
    var self = this;
    var default_params = {field: this.sort_field, direction: this.sort_direction, type: +this.type};
    var ajax_params = null;
    if(params != undefined){
        ajax_params = jQuery.extend({}, default_params, params);
    }else{
        ajax_params = default_params;
    }
    jQuery.ajax({
        url: "/transactions/load",
        data: ajax_params,
        success: function(data){
            self.handle_response(data);
        }
    });
  },

  handle_response: function(data){
    jQuery('#data_wrapper').empty().html(data);

    var self = this;

    jQuery(".badge-black-font").popover({
      animation: true,
      html: true,
      placement: 'right',
      trigger: 'hover',
      title: this.config.color_popup_title,
      content: jQuery("#day_popup").html()
    });

    jQuery('.link-edit').unbind('click').on('click', function(){
        self.show_form(this);
        return false;
    });

    jQuery('.link-delete').unbind('click').on('click', function(){
        self.del(this);
        return false;
    });
  },

  show_form: function(obj){
    jQuery.get(jQuery(obj).attr('href')).done(function(data){
        jQuery('.form-container').empty().html(data);
        var modal_form = jQuery('.form-container > .modal');
        modal_form.modal({
            keyboard: true,
            show: true
        });
        modal_form.on('shown', function(){
              //jQuery('#account_from_id, #account_to_id, #category_id').chosen();
              jQuery('#amount').ForceNumericOnly();
        });
    });
  },

  del: function(obj){
    if(confirm(this.config.delete_confirm)){
        jQuery.ajax({
            type: 'DELETE',
            url: jQuery(obj).attr('href')
        }).done(function(data){
            var msg = data.message;
            if(data.type == 'success'){
                jQuery('.alert-success > .message').empty().append(msg);
                jQuery('.alert-success').show().fadeOut(2000);

                var row = jQuery(obj).parents('tr');
                row.hide(400, function(){row.remove();});
            }else if(data.type = 'error'){
                jQuery('.alert-error > .message').empty().append(msg);
                jQuery('.alert-error').append(msg).show().fadeOut(2000);
            }
        });
    }
    return false;
  },

  toggle_arrows: function(){
    jQuery('th > i').addClass('no-disp');

    var $sorted_header = jQuery('[data_field = "' + this.sort_field + '"]');
    if(this.sort_direction == this.SORT_ASC){
        $sorted_header.parent().children('.icon-arrow-up').removeClass('no-disp');
    }else{
        $sorted_header.parent().children('.icon-arrow-down').removeClass('no-disp');
    }
  }

};

