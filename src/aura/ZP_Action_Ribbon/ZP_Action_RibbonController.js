({
    doInit : function(component, event, helper) {
        helper.setNamespace(component);
        helper.setupActionIcons(component, helper);
    },

    callActionComponent : function(component, event, helper) {
        var targetValueAttr = event.currentTarget.value;
        var parts = targetValueAttr.split("::");
        var iconActionComponent = parts[0];
        var iconAction = parts[1];
        component.set("v.iconActionComponent", iconActionComponent);
        component.set("v.iconAction", iconAction);
        if(iconActionComponent.length === 0){
            return;
        } else{
            var componentName = component.get("v.namespace") + ':' + iconActionComponent;
            $A.createComponent(
                componentName,
                {
                    "recordId" : component.get("v.recordId"),
                    "action" : iconAction
                },
                function(newComponent) {
                    var content = component.get("v.body");
                    component.set("v.body", newComponent);
                }
            );
        }
    }
})