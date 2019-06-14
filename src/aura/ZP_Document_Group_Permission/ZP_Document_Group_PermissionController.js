({
	doInit : function(component, event, helper) {
	    window.console.log("@@@ inside of group permission component @@@");
	    debugger;
        helper.setNamespace(component);
        helper.initGroupList(component, helper);
	},
    cancelPopup : function(component, event, helper) {
        var modal = component.find("setPermissionPrompt");
        var backdrop = component.find("splitModalBackdrop");
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.addClass(modal, 'slds-fade-in-hide');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
        $A.util.addClass(backdrop, 'slds-backdrop_open_hide');
    },
    okPopup: function(component, event, helper) {
        debugger;
        var dbID = component.get("v.dbID");
        var action = component.get("c.invokeModifyGroups");
        var groupsSel = component.find("selectGroups");
        var strGroups = groupsSel.get("v.value");
        action.setParams({
            dbID : dbID,
            groups : strGroups
        });
        action.setCallback(this, function(a) {
            var modal = component.find("setPermissionPrompt");
            var backdrop = component.find("splitModalBackdrop");
            $A.util.removeClass(modal, 'slds-fade-in-open');
            $A.util.addClass(modal, 'slds-fade-in-hide');
            $A.util.removeClass(backdrop, 'slds-backdrop_open');
            $A.util.addClass(backdrop, 'slds-backdrop_open_hide');
            var state = a.getState();
            window.console.log(a.getReturnValue());
            // alert(a.getReturnValue());
            if (state === "SUCCESS") {
                alert("Successfully invoked group permission changes");
            }
            else if (state ==="ERROR"){
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("ERROR: " + errors[0].message);
                    }
                } else {
                    alert("ERROR: Unknown error");
                }
            }
        });
        $A.enqueueAction(action);

/*
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
*/
    }
    // handleApplicationEvent : function(cmp, event) {
    //     debugger;
    //     var operation = event.getParam("operation");
    //     var recId = event.getParam("recId");
    //     var extraInfo = event.getParam("additionalInfo");
    //     var faxDetails = cmp.get("v.faxDetails");
    //     var dbId = faxDetails.dbID;
    //     var zPDFiFrame = document.getElementById("zPDF");
    //     window.console.log("@@@ WE RECEIVED AN APPLICATION EVENT @@@ operation = " + operation + ", recId = " + recId + ", zpServer = " + faxDetails.zpServer);
    //     if (zPDFiFrame) {
		// 	if ("MODIFY_GROUPS" === operation) {
    //             // ZP_RulesEngineEvent zpEvent = new ZP_RulesEngineEvent(dbId, ZP_Constants.RULES_ENGINE_BUTTON_ACTION, operation, null, null);
	 //            // Type t = Type.forName('ZPAPER5', 'ZP_Utilities');
    // 	        // System.debug('### ZP_Utilities Type = ' + t);
    //     	    // msgBuffer += '### ZP_Utilities Type = ' + t + ' -- ';
    //         	// Object o = t.newInstance();
    //         	// System.debug('### zPaper Partner Object = ' + o);
    //         	// msgBuffer += '### zPaper Partner Object = ' + o + ' -- ';
    //         	// ((ZPAPER5.ZP_PartnerInterface.Partner) o).invoke(zpEvent);
    //             var action = component.get("c.invokeModifyGroups");
    //             action.setParams({
    //                 eventValue : operation,
    //                 dbId : component.get(faxDetails.dbID)
    //             });
    //             action.setCallback(this, function(a) {
    //                 window.console.log(a.getReturnValue());
    //                 // alert(a.getReturnValue());
    //                 if (state === "SUCCESS") {
    //                     alert("Successfully invoked split");
    //                 }
    //                 else if (state ==="ERROR"){
    //                     var errors = a.getError();
    //                     if (errors) {
    //                         if (errors[0] && errors[0].message) {
    //                             alert("ERROR: " + errText);
    //                         }
    //                     } else {
    //                         alert("ERROR: Unknown error");
    //                     }
    //                 }
    //             });
    //             $A.enqueueAction(action);
    //         }
    //     }
    // }
})