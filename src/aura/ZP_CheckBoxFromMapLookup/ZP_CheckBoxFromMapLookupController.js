({
    doInit : function(component, event, helper) {
        var map = component.get("v.zMap");
        var prop = component.get("v.zProperty");
        window.console.log("$$$$$ Looking up property: " + prop + " in Map: " + JSON.stringify(map));
        if (map && prop && map[prop]) {
            component.set("v.zResult", map[prop]);
        }
        else {
            component.set("v.zResult", "Status not set");
        }
    }
})