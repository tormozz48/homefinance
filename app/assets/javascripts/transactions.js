var TransactionJS = function(){

   this.DATA_WRAPPER_HEIGHT = 180;
   this.DATA_WRAPPER_HEIGHT_WITH_FILTER = 212;
   this.editMode = false;

   this.init = function(type){

      jQuery('#direction')[0].selectedIndex = 1;

      resizeDataWrapper(this.DATA_WRAPPER_HEIGHT);
      jQuery(window).resize(function(){
          resizeDataWrapper(this.DATA_WRAPPER_HEIGHT);
          transactionsJS.resizeColumns();
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
              jQuery('#transactionFilterFormId').submit();
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
              jQuery('#transactionFilterFormId').submit();
          }
      });

      jQuery('#category, #field, #direction').change(function(){
          jQuery('#pageID').val(1);
          jQuery('#transactionFilterFormId').submit();
      });

      jQuery('#transactionFilterFormId').ajaxSuccess(function(evt, request, settings){
          transactionsJS.handleResponse(request);
      });

      /*
       jQuery('#addNewTransactionButtonID').click(function(){
           var url = jQuery(this).attr('href');
           jQuery.ajax({
               url: url,
               beforeSend: function ( xhr ) {
                   var c = '<div class="b-modal" id="loadingIndicatorID"></div>';
                   jQuery.arcticmodal({
                       content: c
                   });
               }
           }).done(function (doc, status, jqXHR ) {
               transactionsJS.editMode = true;
               var c =  '<div class="b-modal"><div class="b-modal_close arcticmodal-close">X</div>'+jqXHR.responseText+'</div>';
               jQuery.arcticmodal('close');
               jQuery.arcticmodal({
                   content: c,
                   closeOnEsc: false,
                   closeOnOverlayClick: false
               });
           });
          return false;
       });
       */

      // actions after page loading
      jQuery.ajax({
          url: '/transactions/load?type='+type,
          beforeSend: function ( xhr ) {
              var c = '<div class="b-modal" id="loadingIndicatorID"></div>';
              jQuery.arcticmodal({
                  content: c,
                  closeOnEsc: false,
                  closeOnOverlayClick: false,
                  afterClose: function(data, el) {
                      transactionsJS.editMode = false;
                  }
              });
          }
      }).done(function (doc, status, jqXHR ) {
          transactionsJS.handleResponse(jqXHR);
          jQuery.arcticmodal('close');
      });
  };

  this.lazyLoad = function(){
      var p = jQuery('#pageID').val();
      jQuery('#pageID').val(++p);
      jQuery('#transactionFilterFormId').submit();
  };

  this.handleResponse = function(response){
      if(transactionsJS.editMode == false){
          var p = jQuery('#pageID').val();
          if(p == 1){
            jQuery('#dataWrapperID').empty();
          }
          jQuery('#dataWrapperID').append(response.responseText);
          this.resizeColumns();
      }

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
