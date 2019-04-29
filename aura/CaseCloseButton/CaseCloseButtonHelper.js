({
    callApexControllerMethod : function(component, methodName, params, callback) {
		var action = component.get("c." + methodName);
        if(params) {
            action.setParams(params);
        }
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    showToast: function (title,type,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    }
})