/**
 * Created by JetBrains RubyMine.
 * User: Andrey
 * Date: 5/19/12
 * Time: 9:23 AM
 * To change this template use File | Settings | File Templates.
 */

var chart = null;
var lineChartOptions = null;

function statisticInit(){
    jQuery.datepicker.setDefaults($.extend($.datepicker.regional["ru"]));
    jQuery('#date_from_id').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#date_to_id').datepicker('option', 'minDate', jQuery('#date_from_id').datepicker('getDate'));
            jQuery('#date_from_id').datepicker('hide')
        }
    });
    jQuery('#date_to_id').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#date_from_id').datepicker('option', 'maxDate', jQuery('#date_to_id').datepicker('getDate'));
            jQuery('#date_to_id').datepicker('hide')
        }
    });

    jQuery('#statisticDateFormId').ajaxSuccess(function(evt, request, settings){
        var data = jQuery.parseJSON(request.responseText);
        var xValues = new Array();
        var yValues = new Array();
        var series = {data: []};
        if(data.length > 0  && data[0].length > 0){
            for(var i = 0; i < data[0].length ; i++){
                xValues.push(data[0][i]['transaction_date']);
                yValues.push(parseFloat(data[0][i]['transaction_amount']));
            }
        }
        series.data = yValues;
        lineChartOptions.xAxis.categories = xValues;
        lineChartOptions.series = new Array();
        lineChartOptions.series.push(series);
        if(chart != null){
           chart.destroy();
        }
        chart = new Highcharts.Chart(lineChartOptions);
    });
};