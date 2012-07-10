/**
 * Created by JetBrains RubyMine.
 * User: Andrey
 * Date: 5/19/12
 * Time: 9:23 AM
 * To change this template use File | Settings | File Templates.
 */

var chart = null;
var lineChartOptions = null;
var pieChartOptions = null;

function initStatisticByDateChartOptions(title, x_title, y_title){
    lineChartOptions = {
        chart: {
            renderTo: 'chartContainer',
            type: 'spline',
            borderRadius: 10
        },
        colors:[],
        title: {text: title},
        subtitle: {text: ''},
        xAxis: {
            title: {text: x_title},
            type: 'line',
            gridLineWidth: 1,
            labels: {
                rotation: -90,
                align: 'right',
                style: {
                    font: 'normal 11px Verdana, sans-serif'
                }
            },
            categories: []
        },
        legend: {enabled: false},
        yAxis: {
            title: {text: y_title},
            gridLineWidth: 1,
            min: 0
        },
        tooltip: {
            enabled: true,
            formatter: function() {
                return '<b></b>'+
                    this.x +': '+ this.y;
            }
        },
        plotOptions: {
            line: {
                dataLabels: {enabled: true},
                enableMouseTracking: true
            }
        },
        series: []
    };
};

function initCategoryChartOptions(title, other){
    pieChartOptions = {
        categoryOtherTitle: other,
        chart: {
            renderTo: 'chartContainer',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: title
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage*100)/100 +' %';
            }
        },
        legend:{
            align: "left",
            layout: "vertical",
            verticalAlign: 'top',
            x: 0,
            y: 50
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    formatter: function() {
                        return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage*100)/100 +' %';
                    }
                },
                showInLegend: true
            }
        },
        series: []
    };
};

function statisticInit(){
    resizeChartWrapper();
    jQuery(window).resize(function(){resizeChartWrapper();});

    jQuery.datepicker.setDefaults($.extend($.datepicker.regional["ru"]));
    jQuery('#date_from_id').datepicker({
        dateFormat: 'yy-mm-dd',
        maxDate: new Date(),
        changeMonth: true,
        changeYear: true,
        onSelect: function(dateText, inst) {
            jQuery('#date_to_id').datepicker('option', 'minDate', jQuery('#date_from_id').datepicker('getDate'));
            jQuery('#date_from_id').datepicker('hide');
            jQuery('.statisticForm').submit();
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
            jQuery('.statisticForm').submit();
        }
    });

    jQuery('#statisticDateFormId').ajaxSuccess(function(evt, request, settings){
        var data = jQuery.parseJSON(request.responseText);
        var cat_ser = null;
        lineChartOptions.xAxis.categories = new Array();
        lineChartOptions.series = new Array();
        if(data.length > 0  && data[0].length > 0){
            cat_ser = {data: []};
            for(var i = 0; i < data[0].length ; i++){
                lineChartOptions.xAxis.categories.push(data[0][i]['transaction_date'])
                cat_ser.data.push(parseFloat(data[0][i]['transaction_amount']));
            }
            lineChartOptions.series.push(cat_ser);
        }
        if(chart != null){
           chart.destroy();
        }
        chart = new Highcharts.Chart(lineChartOptions);
    });

    jQuery('#statisticCategoryFormId').ajaxSuccess(function(evt, request, settings){
        var data = jQuery.parseJSON(request.responseText);
        var items = new Array();
        var series = {type: 'pie', name: '',data: []};
        if(data.length > 0  && data[0].length > 0){
            var count = jQuery('#categories_count_id').val();
            var sum = 0;
            for(var i = 0; i < data[0].length ; i++){
                if(i<count){
                    items.push({name: data[0][i]['category_name'], color: '#'+data[0][i]['category_color'], y: parseFloat(data[0][i]['transaction_amount'])});
                }else{
                    sum += parseFloat(data[0][i]['transaction_amount']);
                }
            }
            if(sum > 0){
                items.push({name: pieChartOptions.categoryOtherTitle, color: '#999', y: sum});
            }
        }
        series.data = items;
        pieChartOptions.series = new Array();
        pieChartOptions.series.push(series);
        if(chart != null){
            chart.destroy();
        }
        chart = new Highcharts.Chart(pieChartOptions);
    });

    jQuery('.statisticForm').submit();
};
