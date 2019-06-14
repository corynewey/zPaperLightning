({
    doInit : function(component, event, helper) {
        var zpDocsJson = component.get("v.zPDocumentsObj");
        // parse the argument into a JSON object
        window.console.log("@@@ zPDocumentsObj Parameter = " + zpDocsJson);
        if (zpDocsJson) {
            window.console.log("@@@ zPDocumentsObj.zDocStatusNew Parameter = " + zpDocsJson.zDocStatusNew);
            window.console.log("@@@ TYPEOF zPDocumentsObj.zDocStatusNew Parameter = " + (typeof zpDocsJson.zDocStatusNew));
            try {
                if (zpDocsJson.zActionButtons) {
                    for (var i in zpDocsJson.zActionButtons) {
                        if (zpDocsJson.zActionButtons.hasOwnProperty(i)) {
                            var actionBtn = zpDocsJson.zActionButtons[0];
                            if ("Last" === actionBtn.colLocation) {
                                component.set("v.actionIsLast", true);
                            }
                            else {
                                component.set("v.actionIsFirst", true);
                            }
                            break;  // don't allow buttons in both first and last columns
                        }
                    }
                }
            }
            catch (err) {
                window.console.log("################# Exception Caught ##################################");
                window.console.log(err);
                window.console.log("################# Exception Caught ##################################");
            }
        }
    }
})