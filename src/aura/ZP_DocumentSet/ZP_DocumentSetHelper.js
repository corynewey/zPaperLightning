({
    displayError: function(component, errorMsg) {
        var errBox = component.find("errorBox").getElement();
        errBox.innerHTML = "Error: " + errorMsg;
        var errPanel = component.find("errorPanel").getElement();
        errPanel.style.display = "block";
    },
    setNamespace : function(component) {

        var component_to_string = component.toString();

        var markupTagLoc = component_to_string.indexOf('markup://');
        var endOfNamespaceLoc = component_to_string.indexOf(':',markupTagLoc+9);
        var ns = component_to_string.substring(markupTagLoc+9,endOfNamespaceLoc);

        var namespacePrefix = ns === "c" ?  namespacePrefix = "" :  namespacePrefix = ns + "__";

        component.set("v.namespace", ns);
        component.set("v.namespacePrefix", namespacePrefix);
    }
})