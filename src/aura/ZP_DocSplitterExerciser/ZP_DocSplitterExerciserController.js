/**
 * Created by User on 3/8/2018.
 */
({
    handleApplicationEvent : function(cmp, event) {
        debugger;
        var operation = event.getParam("operation");
        var recId = event.getParam("recId");
        var extraInfo = event.getParam("additionalInfo");
        if ("View" === operation || "ViewDocument" === operation) {
            if (extraInfo) {
                component.set("v.dbID", extraInfo.dbID);
            }
        }
    },
    invokeSplitter : function(component, event, helper) {
        debugger;
        var dbID = component.get("v.dbID");
        if (!dbID) {
            alert("Select a document to view from the document set before clicking the ribbon button.");
            return;
        }
        var modal = component.find("splitPrompt");
        $A.util.removeClass(modal, 'slds-fade-in-hide');
        $A.util.addClass(modal, 'slds-fade-in-open');
    },
    cancelPopup : function(component, event, helper) {
        var modal = component.find("splitPrompt");
        var backdrop = component.find("splitModalBackdrop");
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.addClass(modal, 'slds-fade-in-hide');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
        $A.util.addClass(backdrop, 'slds-backdrop_open_hide');
    },
    okPopup: function(component, event, helper) {
        var action = component.get("c.splitDocument");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            for (var prop in a) {
                window.console.log("Apex Return prop = " + prop);
            }
            window.console.log(a.getReturnValue());
            // alert(a.getReturnValue());
            debugger;
            var modal = component.find("splitPrompt");
            var backdrop = component.find("splitModalBackdrop");
            $A.util.removeClass(modal, 'slds-fade-in-open');
            $A.util.addClass(modal, 'slds-fade-in-hide');
            $A.util.removeClass(backdrop, 'slds-backdrop_open');
            $A.util.addClass(backdrop, 'slds-backdrop_open_hide');
            var state = a.getState();
            if (state === "SUCCESS") {
                alert("Successfully invoked split");
            }else if (state ==="ERROR"){
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("ERROR: " + errText);
                    }
                } else {
                    alert("ERROR: Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})