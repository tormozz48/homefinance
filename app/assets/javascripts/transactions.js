Transactions = function(config){
   this.init(config)
};

Transactions.prototype = {
  config: null,

  SORT_ASC: 'asc',
  SORT_DESC: 'desc',

  $data_wrapper: null,
  sort_field: null,
  sort_direction: null,

  init: function(config){
      this.config = config;

      this.$data_wrapper = jQuery('#data_wrapper');

      mark_menu("menuTransactionID");

      this.sort_field = 'date';
      this.sort_direction = this.SORT_DESC;


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

      jQuery('.transaction_delete').click(function(){
          self.delete(this);
          return false;
      });

      this.load_data();
  },

  delete: function(obj){
      if(confirm(this.config.delete_confirm)){
          var self = this;
          jQuery.ajax({
              type: 'DELETE',
              url: jQuery(obj).attr('href')
          });
          return true
      }else{
          return false;
      }
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
        url: "/transactions/load",
        data: {field: this.sort_field, direction: this.sort_direction, type: this.config.transaction_type},
        success: function(data){
            self.handleResponse(data);
        }
    });
  },

  handleResponse: function(data){
    this.$data_wrapper.empty();
    this.$data_wrapper.html(data);

    jQuery(".badge-black-font").popover({
      animation: true,
      html: true,
      placement: 'right',
      trigger: 'hover',
      title: this.config.color_popup_title,
      content: jQuery("#day_popup").html()
    });
  }
};

//var TransactionJS = function(){
//
//   this.init = function(type){
//
//      //mark category menu item as active
//      markMenuItemById("menuTransactionID");
//
//      if(jQuery('#direction')[0].selectedIndex == -1){
//        jQuery('#direction')[0].selectedIndex = 1;
//      }
//
//      jQuery('#filterButtonId').click(function(){
//          jQuery('#date_from_button, #date_to_button, #category').toggleClass("no-disp");
//      });
//
//      jQuery.datepicker.setDefaults(jQuery.extend(jQuery.datepicker.regional["ru"]));
//      jQuery('#date_from').datepicker({
//          dateFormat: 'yy-mm-dd',
//          maxDate: new Date(),
//          changeMonth: true,
//          changeYear: true,
//          onSelect: function(dateText, inst) {
//              jQuery('#date_to').datepicker('option', 'minDate', jQuery('#date_from').datepicker('getDate'));
//              jQuery('#date_from').datepicker('hide');
//              jQuery('#date_from_button').html("<i class=\"icon-calendar\"></i> " + dateText);
//              jQuery('#transactionFilterSortFormId').submit();
//          }
//      });
//
//      jQuery('#date_to').datepicker({
//          dateFormat: 'yy-mm-dd',
//          maxDate: new Date(),
//          changeMonth: true,
//          changeYear: true,
//          onSelect: function(dateText, inst) {
//              jQuery('#date_from').datepicker('option', 'maxDate', jQuery('#date_to').datepicker('getDate'));
//              jQuery('#date_to').datepicker('hide');
//              jQuery('#date_to_button').html("<i class=\"icon-calendar\"></i> " + dateText);
//              jQuery('#transactionFilterSortFormId').submit();
//          }
//      });
//
//       jQuery('#date_from_button').click(function(){
//           jQuery('#date_from').datepicker( "show" )
//       });
//
//       jQuery('#date_to_button').click(function(){
//           jQuery('#date_to').datepicker( "show" )
//       });
//
//      jQuery('#category, #field, #direction').change(function(){
//          jQuery('#pageID').val(1);
//          jQuery('#transactionFilterSortFormId').submit();
//      });
//
//      jQuery('#transactionFilterSortFormId').ajaxSuccess(function(evt, request, settings){
//          transactionsJS.handleResponse(request);
//      });
//
//       jQuery('#transactionFilterSortFormId').submit();
//   };
//
//   this.handleResponse = function(response){
//
//      jQuery('#dataWrapperID').empty();
//      jQuery('#dataWrapperID').append(response.responseText);
//
//      jQuery(".badge-black-font").popover({
//          animation: true,
//          html: true,
//          placement: 'right',
//          trigger: 'hover',
//          title: dayColorPopupTitle,
//          content: jQuery("#dayOfWeekPopupID").html()
//      });
//
//      jQuery('.btn, #field, #direction, #category, td > span, td > div').tooltip();
//
//      jQuery(".alert-success, .alert-error").fadeOut(5000);
//   };
//
//   this.formInit = function(){
//      //mark category menu item as active
//      markMenuItemById("menuTransactionID");
//
//      jQuery('.controls > .input-append > input, .controls > button, .controls > textarea, .controls > select').tooltip({placement: 'right'});
//      jQuery('.btn').tooltip();
//
//      jQuery('#button-date').click(function(){
//          jQuery('#date').datepicker( "show" )
//      });
//
//      jQuery('#date').datepicker({
//          dateFormat: 'yy-mm-dd',
//          maxDate: new Date(),
//          changeMonth: true,
//          changeYear: true,
//          onSelect: function(dateText, inst) {
//              jQuery('#button-date').html("<i class=\"icon-calendar\"></i> " + dateText);
//              jQuery('#date').datepicker('hide');
//          }
//      });
//
//      jQuery('#amount').ForceNumericOnly();
//   };
//};
