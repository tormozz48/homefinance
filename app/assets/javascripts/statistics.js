Statistics = function(config){
    this.init(config);
};

Statistics.prototype = {
    config: null,

    date_charts: null,
    category_chart: null,

    date_from_selector: null,
    date_to_selector: null,

    init: function(config){
        this.config = config;
        this.init_filter();
        this.category_chart = category_chart(this.date_from_selector, this.date_to_selector);
        this.category_chart.create();

        this.date_charts = [];
        for(var i = 0; i < 8; i++){
            this.date_charts[i] = date_chart(i, this.date_from_selector, this.date_to_selector);
            this.date_charts[i].create();
        }
    },

    init_filter: function(){
        var self = this;

        this.date_from_selector = jQuery('#date_from');
        this.date_to_selector = jQuery('#date_to');

        //bind date picker for date from field
        this.date_from_selector.datepicker({
            dateFormat: 'yy-mm-dd',
            maxDate: new Date(),
            changeMonth: true,
            changeYear: true,
            onSelect: function(dateText, inst) {
                self.date_to_selector.datepicker('option', 'minDate', self.date_from_selector.datepicker('getDate'));
                self.date_from_selector.datepicker('hide');
            }
        });

        //bind date picker for date to field
        self.date_to_selector.datepicker({
            dateFormat: 'yy-mm-dd',
            maxDate: new Date(),
            changeMonth: true,
            changeYear: true,
            onSelect: function(dateText, inst) {
                self.date_from_selector.datepicker('option', 'maxDate', self.date_to_selector.datepicker('getDate'));
                self.date_to_selector.datepicker('hide');
            }
        });

        jQuery('#filter_submit').click(function(){
            self.reload();
            return false;
        })
    },

    reload: function(){
        this.category_chart.reload();
        for(var i = 0; i < 8; i++){
            this.date_charts[i].reload();
        }
    }
};

