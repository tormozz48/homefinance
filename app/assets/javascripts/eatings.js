function initEatingForm(){
    jQuery("#overweightId").change(function(){
        if(jQuery("#violationId").attr("checked") != false &&
            jQuery("#overweightId").attr("checked") != false){
            jQuery("#violationId").attr("checked", false);
        }
    });
    jQuery("#violationId").change(function(){
        if(jQuery("#overweightId").attr("checked") != false &&
            jQuery("#violationId").attr("checked") != false){
            jQuery("#overweightId").attr("checked", false);
        }
    });
}
