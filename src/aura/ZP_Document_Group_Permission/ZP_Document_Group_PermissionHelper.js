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

    initGroupList : function(component, helper){
        debugger;
        var groupsMap = component.get("v.groupsMap");
        var opts = [];
        if (groupsMap) {
            if (typeof groupsMap === "string") {
                groupsMap = JSON.parse(groupsMap);
            }
            for (var key in groupsMap) {
                if (groupsMap.hasOwnProperty(key)) {
                    opts.push({label: key, value: groupsMap[key]});
                }
            }
            component.set("v.options", opts);
        }
        var modal = component.find("setPermissionPrompt");
        $A.util.removeClass(modal, 'slds-fade-in-hide');
        $A.util.addClass(modal, 'slds-fade-in-open');
        // var action = component.get("c.setupGroupList");
        //
        // action.setCallback(this, function(response) {
        //     var state = response.getState();
        //     if (component.isValid() && state === "SUCCESS") {
        //         var returnValue = response.getReturnValue();
        //         var groups = returnValue.groups;
        //         component.set("v.groupsWrapper", returnValue);
        //         component.set("v.showForm", true);
        //         var modal = component.find("setPermissionPrompt");
        //         // var groupsSel = component.find("selectGroups");
        //         $A.util.removeClass(modal, 'slds-fade-in-hide');
        //         $A.util.addClass(modal, 'slds-fade-in-open');
        //         var opts = [];
        //         for (var key in groups) {
        //             var val = groups[key];
        //             opts.push({value: val, label: key});
        //         }
        //         component.set("v.options", opts);
        //     }
        //     else {
        //         console.log("initGroupList: Failed with state: " + state);
        //     }
        // });
        // $A.enqueueAction(action);
    }
})