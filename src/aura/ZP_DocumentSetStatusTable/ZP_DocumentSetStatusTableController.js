({
    doInit : function(component, event, helper) {
        helper.setNamespace(component);
        window.console.log("$$$$$$$ IN ZP_DocumentSetStatusTableController $$$$$$$");
        var zPDocuments = component.get("v.zPDocumentsObj");
        var namespace = component.get("v.namespace");
        window.console.log("Creating component: " + namespace + ":ZP_DocumentSetHeader");
        $A.createComponent(
            namespace + ":ZP_DocumentSetHeader",
            {
                "zPDocumentsObj": zPDocuments
            },
            function (newComponent, status, errorMessage) {
                window.console.log("## ZP_DocumentSetHeader Component Create Status = " + status);
                if ("SUCCESS" === status) {
                    var content = component.get("v.body");
                    content.push(newComponent);
                    component.set("v.body", content);
                    window.console.log("Creating component: " + namespace + ":ZP_DocumentSetBody");
                    $A.createComponent(
                        namespace + ":ZP_DocumentSetBody",
                        {
                            "zPDocumentsObj": zPDocuments,
                            "recordId": component.get("v.recordId")
                        },
                        function (newComponent, status, errorMessage) {
                            window.console.log("## ZP_DocumentSetBody Component Create Status = " + status);
                            var content = component.get("v.body");
                            content.push(newComponent);
                            component.set("v.body", content);
                        }
                    );
                }
                else {
                    // CRN180404 ToDo: send component event to parent component to set the error message
                    // helper.displayError(component, errorMessage);
                    window.console.log("Error creating component: " + errorMessage);
                }
            }
        );
    }
})