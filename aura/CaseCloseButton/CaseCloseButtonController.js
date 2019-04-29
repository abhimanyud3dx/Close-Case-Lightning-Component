({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCloseCaseStatus");           
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var closeStatusList = [];
                var returnedMap = response.getReturnValue();  console.log(returnedMap);
                for (var key in returnedMap){
                    var item = {};
                    item.label = key;
                    item.value = returnedMap[key];
                    closeStatusList.push(item);
                }
                component.set("v.closeStatusList",closeStatusList);
            }
            component.set("v.showSpinner", false); 
        });
        $A.enqueueAction(action);   
    },
    closeCaseAction : function(component, event, helper) {       
        var action = component.get("c.closeCaseRecord");  
        action.setParams({ 
            recordId : component.get("v.recordId"),
            caseStatus : component.get("v.selectedStatusValue"),
            caseCommentBody : component.get("v.caseComment")
        });      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isModalOpen", false);
                $A.get('e.force:refreshView').fire();
                helper.showToast('Success','success','Case Closed','dismissible');
            }
            else{
                var errors = response.getError();
                if (errors) { console.log(JSON.stringify(errors));
                    if (errors[0] && errors[0].message) {
                        helper.showToast('Error','error',errors[0].message,'sticky');
                        console.log(errors);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.showSpinner", false); 
        });
        $A.enqueueAction(action);  

    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
     },
     closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.caseComment",'');
     }
})