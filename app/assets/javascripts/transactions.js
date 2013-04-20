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

      jQuery('.nav-pills > li > a').click(function(){
          jQuery('.nav-pills > li > a').removeClass('btn-primary').addClass('btn-info');
          jQuery(this).removeClass('btn-info').addClass('btn-primary');
          self.switch_transaction_type(this);
          return false;
      });

      jQuery('.nav-pills > li:first > a').triggerHandler('click');
  },

  switch_transaction_type: function(obj){
     var self = this;
     var url = jQuery(obj).attr('href');
     jQuery.get(url).done(function(data){
         jQuery('.table-container').html(data);
         self.after_switch();
     });
  },

  after_switch: function(){
      this.type = jQuery('.table-container > table').attr('data-type');

      jQuery('.link-add').unbind('click').on('click', function(){
          self.show_form(this);
          return false;
      });

      var self = this;
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

      this.load_data();
  },

  load_data: function(){
    var self = this;
    jQuery.ajax({
        url: "/transactions/load",
        data: {field: this.sort_field, direction: this.sort_direction, type: +this.type},
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
            var modal_form = jQuery('.modal');
            modal_form.modal({
                keyboard: true,
                show: true
            });
            modal_form.on('shown', function(){
                  jQuery('#account_from_id, #account_to_id, #category_id').chosen();
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
                }else if(data.type = 'error'){
                    jQuery('.alert-error > .message').empty().append(msg);
                    jQuery('.alert-error').append(msg).show().fadeOut(2000);
                }

                var row = jQuery(obj).parents('tr');
                row.hide(400, function(){
                    row.remove();
                });
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

