// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap/bootstrap
//= require arcticmodal/arcticmodal
//= require colorpicker/colorpicker
//= require colorpicker/eye
//= require colorpicker/layout
//= require colorpicker/utils
//= require datepicker/jqueryui
//= require hightcharts/highcharts
//= require hightcharts/iexporting


var transactionsJS = new TransactionJS();
var accountsJS = new AccountsJS();
var categoriesJS = new CategoriesJS();

function resizeDataWrapper(v){
    if(v == null){
        v = 180;
    }
    var h = document.body.offsetHeight - v;
    jQuery("#dataWrapperID").css("height", h+"px");
};

function resizeChartWrapper(){
    var h = document.body.offsetHeight - 170;
    jQuery(".statistic-graph-wrapper").css("height", h+"px");
};

jQuery.fn.ForceNumericOnly =function(){
    return this.each(function(){
        jQuery(this).keydown(function(e){
            var key = e.charCode || e.keyCode || 0;
            return (
                key == 8 ||
                    key == 9 ||
                        key == 46 ||
                            key == 190 ||
                                (key >= 37 && key <= 40) ||
                                    (key >= 48 && key <= 57) ||
                                        (key >= 96 && key <= 105)
            );
        });
    });
};
