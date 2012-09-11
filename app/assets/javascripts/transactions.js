var TransactionJS = function(){

   this.init = function(type){

      //mark category menu item as active
      markMenuItemById("menuTransactionID");

      if(jQuery('#direction')[0].selectedIndex == -1){
        jQuery('#direction')[0].selectedIndex = 1;
      }

      jQuery('#filterButtonId').click(function(){
          jQuery('#date_from_button, #date_to_button, #category').toggleClass("no-disp");
      });

      jQuery.datepicker.setDefaults(jQuery.extend(jQuery.datepicker.regional["ru"]));
      jQuery('#date_from').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#date_to').datepicker('option', 'minDate', jQuery('#date_from').datepicker('getDate'));
              jQuery('#date_from').datepicker('hide');
              jQuery('#date_from_button').html("<i class=\"icon-calendar\"></i> " + dateText);
              jQuery('#transactionFilterSortFormId').submit();
          }
      });

      jQuery('#date_to').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#date_from').datepicker('option', 'maxDate', jQuery('#date_to').datepicker('getDate'));
              jQuery('#date_to').datepicker('hide');
              jQuery('#date_to_button').html("<i class=\"icon-calendar\"></i> " + dateText);
              jQuery('#transactionFilterSortFormId').submit();
          }
      });

       jQuery('#date_from_button').click(function(){
           jQuery('#date_from').datepicker( "show" )
       });

       jQuery('#date_to_button').click(function(){
           jQuery('#date_to').datepicker( "show" )
       });

      jQuery('#category, #field, #direction').change(function(){
          jQuery('#pageID').val(1);
          jQuery('#transactionFilterSortFormId').submit();
      });

      jQuery('#transactionFilterSortFormId').ajaxSuccess(function(evt, request, settings){
          transactionsJS.handleResponse(request);
      });

       jQuery('#transactionFilterSortFormId').submit();
   };

   this.handleResponse = function(response){

      jQuery('#dataWrapperID').empty();
      jQuery('#dataWrapperID').append(response.responseText);

      jQuery(".badge-black-font").popover({
          animation: true,
          html: true,
          placement: 'right',
          trigger: 'hover',
          title: dayColorPopupTitle,
          content: jQuery("#dayOfWeekPopupID").html()
      });

      jQuery('.btn, #field, #direction, #category, td > span, td > div').tooltip();

      jQuery(".alert-success, .alert-error").fadeOut(5000);
   };

   this.formInit = function(){
      //mark category menu item as active
      markMenuItemById("menuTransactionID");

      jQuery('.controls > .input-append > input, .controls > button, .controls > textarea, .controls > select').tooltip({placement: 'right'});
      jQuery('.btn').tooltip();

      jQuery('#button-date').click(function(){
          jQuery('#date').datepicker( "show" )
      });

      jQuery('#date').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#button-date').html("<i class=\"icon-calendar\"></i> " + dateText);
              jQuery('#date').datepicker('hide');
          }
      });

      jQuery('#amount').ForceNumericOnly();
   };
};
