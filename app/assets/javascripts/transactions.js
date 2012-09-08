var TransactionJS = function(){

   this.init = function(type){

      //mark category menu item as active
      markMenuItemById("menuTransactionID");

      jQuery('#direction')[0].selectedIndex = 1;

      jQuery('#filterButtonId').click(function(){
          jQuery('#filterFormID').toggleClass("no-disp");
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
              jQuery('#pageID').val(1);
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
              jQuery('#pageID').val(1);
              jQuery('#transactionFilterSortFormId').submit();
          }
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

      jQuery('.btn, #field, #direction, td > span, td > div').tooltip();
  };

  this.formInit = function(){
      jQuery('#date').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#date').datepicker('hide')
          }
      });

      jQuery('#amount').ForceNumericOnly();
  };
};
