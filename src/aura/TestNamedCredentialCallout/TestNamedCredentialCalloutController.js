/**
 * Created by User on 8/28/2018.
 */
({
    doCallout : function(component, event, helper) {
        var action = component.get('c.doTestCallout');
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === 'SUCCESS') {
                alert("Successful callout: " + response.getReturnValue());
                window.console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})