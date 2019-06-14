({  
    // Method: sendADocHelper, it is calling Apex controleer method to make HTTP call and get response
    sendADocHelper : function(component, cbMethod) {        
        var action = component.get("c.sendADocController");
        action.setParams({
            "accountId": component.get("v.recordId")
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var settings = response.getReturnValue();
                component.set("v.settings", settings);

                if(cbMethod){
                    cbMethod();
                }                
            }
        });
        $A.enqueueAction(action);
    }
})