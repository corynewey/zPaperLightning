({
    doInit : function(component, event, helper) {
        helper.setNamespace(component);
        helper.setupTemplateList(component, helper);
    },
    produceDocument: function(component, event, helper) {
        var namespace = component.get("v.namespace");
        var appEvent = $A.get("e." + namespace + ":ZP_Event_DocViewer");
        var bundleTemplateList = component.get("v.bundleTemplateList");
        var templatesBuffer = "";
        for (var idx in bundleTemplateList) {
            if (bundleTemplateList.hasOwnProperty(idx)) {
                if (templatesBuffer.length > 0) { templatesBuffer += ","; }
                templatesBuffer += bundleTemplateList[idx];
            }
        }
        appEvent.setParams({
            "targetDocViewer" : "bundlerViewer",
            "operation" : "ViewBundle",
            "recId" : component.get("v.recordId"),
            "additionalInfo" : JSON.parse('{"bundleParams":"templateIds=' + templatesBuffer + '"}')
        });
        appEvent.fire();
    },
    handleCkBoxClick : function(component, event, helper) {
        debugger;
        var checked = event.getSource().get("v.value");
        var id = event.getSource().get("v.text");
        var bundleTemplateList = component.get("v.bundleTemplateList");
        window.console.log("@@@@ Checkbox Event: checked = " + checked + ", id = " + id);
        if (checked) {
            bundleTemplateList.push(id);
        }
        else {
            var idx = bundleTemplateList.indexOf(id);
            window.console.log("#### index of current Id = " + idx);
            if (idx >= 0) {
                bundleTemplateList.splice(idx, 1);
            }
        }
        window.console.log("@@@@ current bundle template list: " + bundleTemplateList);
        component.set("v.bundleTemplateList", bundleTemplateList);
    }
})