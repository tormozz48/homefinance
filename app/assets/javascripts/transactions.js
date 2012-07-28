var TransactionJS = function(){

   this.DATA_WRAPPER_HEIGHT = 180;
   this.DATA_WRAPPER_HEIGHT_WITH_FILTER = 212;

   this.init = function(type){

      resizeDataWrapper(this.DATA_WRAPPER_HEIGHT);
      jQuery(window).resize(function(){
          resizeDataWrapper(this.DATA_WRAPPER_HEIGHT);
          transactionsJS.resizeColumns();
      });

      jQuery.datepicker.setDefaults(jQuery.extend(jQuery.datepicker.regional["ru"]));
      jQuery('#date_from_id').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#date_to_id').datepicker('option', 'minDate', jQuery('#date_from_id').datepicker('getDate'));
              jQuery('#date_from_id').datepicker('hide');
              jQuery('#transactionFilterFormId').submit();
          }
      });

      jQuery('#date_to_id').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#date_from_id').datepicker('option', 'maxDate', jQuery('#date_to_id').datepicker('getDate'));
              jQuery('#date_to_id').datepicker('hide');
              jQuery('#transactionFilterFormId').submit();
          }
      });

      jQuery('#category_id, #field_id, #direction_id').change(function(){
          jQuery('#transactionFilterFormId').submit();
      });

      jQuery('#transactionFilterFormId').ajaxSuccess(function(evt, request, settings){
          transactionsJS.handleResponse(request);
      });

      //load transactions after page loading
      jQuery.ajax({
          url: '/transactions/load?type='+type
      }).done(function (doc, status, jqXHR ) {
          transactionsJS.handleResponse(jqXHR);
      });
  };

  this.handleResponse = function(response){
      jQuery('#dataWrapperID').empty();
      jQuery('#dataWrapperID').html(response.responseText);
      this.resizeColumns();
  };

  this.resizeColumns = function(){
      var dataItemWidth = jQuery('#dataTableID')[0].clientWidth;
      var buttonsColumnWidth = jQuery('#editButtonsHeaderID')[0].clientWidth;
      var dateColumnWidth = jQuery('#transactionDateHeaderID')[0].clientWidth;
      var sumColumnWidth = jQuery('#transactionSumHeaderID')[0].clientWidth;
      var transactionColumnWidth =
          (dataItemWidth - buttonsColumnWidth - dateColumnWidth - sumColumnWidth - 45)/2;

      jQuery('#transactionAccountHeaderID1').css("width", transactionColumnWidth+"px");
      jQuery('#transactionAccountHeaderID2').css("width", transactionColumnWidth+"px");
      jQuery('.body-transaction-account').css("width", transactionColumnWidth+"px");
  };

  this.formInit = function(){
      jQuery('#transactionDateId').datepicker({
          dateFormat: 'yy-mm-dd',
          maxDate: new Date(),
          changeMonth: true,
          changeYear: true,
          onSelect: function(dateText, inst) {
              jQuery('#transactionDateId').datepicker('hide')
          }
      });

      jQuery('#transactionAmountId').ForceNumericOnly();
  };

  this.toggleFilter = function(){
      if(jQuery('#transactionFilterFormId').css("display") == "none"){
          jQuery('#transactionFilterFormId').show();
          resizeDataWrapper(this.DATA_WRAPPER_HEIGHT_WITH_FILTER);
          jQuery(window).resize(function(){
              resizeDataWrapper(this.DATA_WRAPPER_HEIGHT_WITH_FILTER);
          });
      }else{
          jQuery('#transactionFilterFormId').hide();
          resizeDataWrapper(this.DATA_WRAPPER_HEIGHT);
          jQuery(window).resize(function(){
              resizeDataWrapper(this.DATA_WRAPPER_HEIGHT);
          });
      }
  };
};
