({
    setNamespace : function(component) {

        var component_to_string = component.toString();

        var markupTagLoc = component_to_string.indexOf('markup://');
        var endOfNamespaceLoc = component_to_string.indexOf(':',markupTagLoc+9);
        var ns = component_to_string.substring(markupTagLoc+9,endOfNamespaceLoc);

        var namespacePrefix = ns === "c" ?  namespacePrefix = "" :  namespacePrefix = ns + "__";

        component.set("v.namespace", ns);
        component.set("v.namespacePrefix", namespacePrefix);
    },

    setupTemplateList : function(component, helper) {
        var recId = component.get("v.recordId");
        var action = component.get("c.getTemplateList");

        action.setParams({
            "recId": recId
        });

        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if (typeof returnValue === "string") {
                    returnValue = JSON.parse(returnValue);
                }
                component.set("v.formsList", returnValue);

            } else {
                console.log("setupTemplateList: Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    expandModal: function(cmp, helper) {
        debugger;
        window.console.log("@@@@ Inside expandModal @@@@");
        var cmpFrame = document.getElementsByClassName('ZPAPER5ZP_DocumentBundler');
        var expanded = false;
        if (cmpFrame && cmpFrame.length > 0) {
            var curEle = cmpFrame[0];
            while (curEle) {
                var classes = curEle.className;
                // modal-container slds-modal__container
                if (classes.indexOf('modal-container') >= 0 && classes.indexOf('slds-modal__container') >= 0) {
                    curEle.style.maxWidth = '90%';
                    curEle.style.width = '90%';
                    expanded = true;
                    break;
                }
                curEle = curEle.parentElement;  // move further up the DOM tree and continue looking
            }
        }
        // if (!expanded) {
        //     // The dialog must not have been totally built, try again after a delay
        //     setTimeout(function() {
        //         helper.expandModal(cmp, helper);
        //     }, 1500);
        // }
    }

})