/**
 * Created by User on 8/29/2018.
 */
({
    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, component.get("v.vfHost"));
    },
    getPicklistEntries: function(component, event, helper) {
        var picklistName = component.get("v.sfPicklist");
        if (picklistName) {
            var action = component.get("c.getPicklistEntries");
            action.setParams({
                "picklistName": picklistName
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    debugger;
                    var items = response.getReturnValue();
                    window.console.log('Picklist items = ' + items);
                    component.set('v.picklistEntries', items);
                }
                else {
                    alert("Error calling Apex Controller: " + response.getError()[0].message);
                }
            });
            $A.enqueueAction(action);
        }
    },
    showMessage: function(component, message, severity) {
        $A.createComponents([
                ["markup://ui:message",{
                    "body" : message,
                    "severity" : severity
                }]
            ],
            function(components, status, errorMessage) {
                if (status === "SUCCESS") {
                    var newComponent = components[0];
                    component.find('uiMessage').set("v.body", newComponent);
                    var eleContainer = document.getElementById("uiMessageContainer");
                    if (eleContainer) { eleContainer.style.display = ""; }
                }
                else if (status === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Error displaying status: ' + errorMessage,
                        type: 'error'
                    });
                    toastEvent.fire();
                }
            }
        );
    }
})