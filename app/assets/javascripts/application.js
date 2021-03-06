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
//= require jquery-ui
//= require twitter/bootstrap
//= require twitter/bootstrap/bootstrap-affix
//= require twitter/bootstrap/bootstrap-alert
//= require twitter/bootstrap/bootstrap-button
//= require twitter/bootstrap/bootstrap-carousel
//= require twitter/bootstrap/bootstrap-collapse
//= require twitter/bootstrap/bootstrap-dropdown
//= require twitter/bootstrap/bootstrap-modal
//= require twitter/bootstrap/bootstrap-popover
//= require twitter/bootstrap/bootstrap-scrollspy
//= require twitter/bootstrap/bootstrap-tab
//= require twitter/bootstrap/bootstrap-tooltip
//= require twitter/bootstrap/bootstrap-transition
//= require twitter/bootstrap/bootstrap-typeahead
//= require colorpicker/colorpicker
//= require colorpicker/eye
//= require colorpicker/layout
//= require colorpicker/utils
//= require chosen-jquery
//= require amcharts
//= require_tree .
//= require turbolinks


function mark_menu(menu_id){
    jQuery('ul.nav > li').removeClass("active");
    jQuery('ul.nav > li#' + menu_id).addClass("active");
}

jQuery.fn.ForceNumericOnly =function(){
    return this.each(function(){
        jQuery(this).keydown(function(e){
            var key = e.charCode || e.keyCode || 0;
            return (
                key == 8 || key == 9 ||
                key == 46 || key == 190 ||
                (key >= 37 && key <= 40) ||
                (key >= 48 && key <= 57) ||
                (key >= 96 && key <= 105)
            );
        });
    });
};