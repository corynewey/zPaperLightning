({
    createRow: function (zpDocuments, file, controllingComponent, dType, recordId) {
        var namespace = controllingComponent.get("v.namespace");
        debugger;
        window.console.log("Creating component: " + namespace + ":ZP_DocumentSetBodyRow");
        $A.createComponent(
            namespace + ":ZP_DocumentSetBodyRow",
            {
                "zPDocumentsObj" : zpDocuments,
                "zpFile" : file,
                "docType" : dType,
                "recordId" : recordId
            },
            function(newComponent, status, errorMessage) {
                window.console.log("## ZP_DocumentSetBody Row Component Create Status = " + status);
                window.console.log("## ZP_DocumentSetBody Row Component errorMessage = " + errorMessage);
                var content = controllingComponent.get("v.body");
                content.push(newComponent);
                controllingComponent.set("v.body", content);
            }
        );
    },
    isDefined: function (ele) {
        return undefined !== ele && null !== ele;
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