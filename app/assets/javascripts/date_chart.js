function date_chart(type, date_from_selector, date_to_selector){

    var _chart = null;
    var chart_data = null;

    var load_data = function(){
        var params = {date_from: date_from_selector.val(),
                      date_to: date_to_selector.val(),
                      type: type};

        return  jQuery.getJSON('/statistics/load_by_date', params);
    };

    var category_axis = function(){
        var categoryAxis = _chart.categoryAxis;
        categoryAxis.parseDates = true; // as our data is date-based, we set parseDates to true
        categoryAxis.minPeriod = "DD"; // our data is daily, so we set minPeriod to DD
        categoryAxis.dashLength = 1;
        categoryAxis.gridAlpha = 0.15;
        categoryAxis.position = "top";
        categoryAxis.axisColor = "#DADADA";
    };

    var value_axis = function(){
        var valueAxis = new AmCharts.ValueAxis();
        valueAxis.axisAlpha = 0;
        valueAxis.dashLength = 1;
        _chart.addValueAxis(valueAxis);
    };

    var graph = function(){
        var graph = new AmCharts.AmGraph();
        graph.title = "red line";
        graph.valueField = "value";
        //graph.type = "smoothedLine";
        graph.bullet = "round";
        graph.bulletBorderColor = "#FFFFFF";
        graph.bulletBorderThickness = 2;
        graph.lineThickness = 2;
        graph.lineColor = "#003366";
        graph.negativeLineColor = "#efcc26";
        graph.hideBulletsCount = 50; // this makes the chart to hide bullets when there are more than 50 series in selection
        _chart.addGraph(graph);
    };

    var cursor = function(){
        var chartCursor = new AmCharts.ChartCursor();
        chartCursor.cursorPosition = "mouse";
        chartCursor.pan = true; // set it to fals if you want the cursor to work in "select" mode
        _chart.addChartCursor(chartCursor);
    };

    var scrollbar = function(){
        var chartScrollbar = new AmCharts.ChartScrollbar();
        _chart.addChartScrollbar(chartScrollbar);
    };

    var zoom = function(){
        _chart.zoomToIndexes(chart_data.length - 40, chart_data.length - 1);
    };

    var chart = function(){
        _chart = new AmCharts.AmSerialChart();
        _chart.autoMarginOffset = 5;
        _chart.marginBottom = 0;
        _chart.pathToImages = "http://www.amcharts.com/lib/images/";
        _chart.zoomOutButton = {
            backgroundColor: '#000000',
            backgroundAlpha: 0.15
        };
        _chart.dataProvider = chart_data;
        _chart.categoryField = "date";
        _chart.balloon.bulletSize = 5;

        _chart.addListener("dataUpdated", zoom);
    };

    var fill_data = function(data){
        var cd = [];
        var l = data.length;
        var g = jQuery('#chart_container_date_' + type).parents('.accordion-group');
        if(l > 0){
            g.removeClass('no-disp');
        }else{
            g.addClass('no-disp');
        }
        for(var i = 0; i < l; i++){
            cd[i] = {
                date: new Date(data[i].date),
                value: data[i].value
            }
        }
        return cd;
    };

    function ch(){}

    ch.create = function(){
        load_data().then(function(data){
            chart_data = fill_data(data);
            chart();
            category_axis();
            value_axis();
            graph();
            cursor();
            scrollbar();
            _chart.write("chart_container_date_" + type);
        });
    };

    ch.reload =  function(){
        load_data().then(function(data){
            chart_data = fill_data(data);
            _chart.dataProvider = chart_data;
            _chart.validateData();
        });
    };

    return ch;
}