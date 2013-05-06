function category_chart(date_from_selector, date_to_selector){
    var _chart = null;

    var load_data = function(){
        var params = {date_from: date_from_selector.val(),
                      date_to: date_to_selector.val()};

        return  jQuery.getJSON('/statistics/load_by_category', params);
    };

    var category_axis = function(){
        var categoryAxis = _chart.categoryAxis;
        categoryAxis.labelRotation = 90;
        categoryAxis.dashLength = 5;
        categoryAxis.gridPosition = "start";

    };

    var value_axis = function(){
        var valueAxis = new AmCharts.ValueAxis();
        valueAxis.title = "Visitors";
        valueAxis.dashLength = 5;
        _chart.addValueAxis(valueAxis);
    };

    var graph = function(){
        var graph = new AmCharts.AmGraph();
        graph.valueField = "value";
        graph.colorField = "color";
        graph.balloonText = "[[category]]: [[value]]";
        graph.type = "column";
        graph.lineAlpha = 0;
        graph.fillAlphas = 1;
        _chart.addGraph(graph);
    };

    var chart = function(data){
        _chart = new AmCharts.AmSerialChart();
        _chart.dataProvider = data;
        _chart.categoryField = "category";
        _chart.marginRight = 0;
        _chart.marginTop = 0;
        _chart.autoMarginOffset = 0;
        _chart.startDuration = 2;
        _chart.depth3D = 10;
        _chart.angle = 30;
    };

    function ch(){}

    ch.create = function(){
        load_data().then(function(data){
            chart(data);
            category_axis();
            value_axis();
            graph();
            _chart.write("chart_container_cat");
        });

    };

    ch.reload = function(){
        load_data().then(function(data){
           _chart.dataProvider = data;
           _chart.validateData();
        });
    };

    return ch;
}