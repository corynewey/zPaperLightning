({
    setNamespace : function(component) {

        var component_to_string = component.toString();

        var markupTagLoc = component_to_string.indexOf('markup://');
        var endOfNamespaceLoc = component_to_string.indexOf(':',markupTagLoc+9);
        var ns = component_to_string.substring(markupTagLoc+9,endOfNamespaceLoc);

        var namespacePrefix = ns === "c" ?  "" :  ns + "__";

        component.set("v.namespace", ns);
        component.set("v.namespacePrefix", namespacePrefix);
    },
    fireApplicationEvent : function(component, event, helper) {
        debugger;
        var ns = component.get("v.namespace");
        var appEvent = $A.get("e." + ns + ":" + "ZP_Event_DocViewer");

        appEvent.setParams({
            "operation" : component.get("v.action"),
            "recId" : component.get("v.recordId")});
        appEvent.fire();
    }
})