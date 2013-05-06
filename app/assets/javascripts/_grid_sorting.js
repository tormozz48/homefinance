/**
 * Grid sorting module
 * @param field - default sorting field
 * @param obj - external screen model object
 * @param load_function - load data function
 * @returns {Function} -returns internal closure
 */
function sort(field, obj, load_function){
    var SORT_ASC = 'asc';
    var SORT_DESC = 'desc';

    var sort_field = field;
    var sort_direction = SORT_ASC;

    /**
     * Shows and hides sorting arrow indicators
     * on every column header click
     */
    var toggle_arrows = function(){
        jQuery('th > i').addClass('no-disp');

        var sorted_header = jQuery('[data_field = "' + sort_field + '"]');
        if(sort_direction == SORT_ASC){
            sorted_header.parent().children('.icon-arrow-up').removeClass('no-disp');
        }else{
            sorted_header.parent().children('.icon-arrow-down').removeClass('no-disp');
        }
    };

    function f(){

    }

    /**
     * Public sorting function for grid sorting
     * @param o - header sorting link
     */
    f.sort = function(o){
        var sf = jQuery(o).attr('data_field');

        if(sort_field == sf){
            sort_direction =
                sort_direction == SORT_ASC ? SORT_DESC : SORT_ASC;
        }else{
            sort_direction = SORT_ASC;
        }

        sort_field = sf;
        toggle_arrows();
        load_function.apply(obj, [sort_field, sort_direction]);
    };

    /**
     * Returns current sorting field for grid
     * @returns {string}
     */
    f.get_field = function(){
        return sort_field;
    };

    /**
     * Returns current sorting direction for grid
     * @returns {string}
     */
    f.get_direction = function(){
        return sort_direction;
    };

    return f;
}