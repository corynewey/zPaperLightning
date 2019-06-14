({
    getFaxDetails : function(component) {
        var action = component.get("c.getAttachmentId");
        action.setParams({
            strDocId : component.get("v.recordId"),
            zpSnippetIdFld : component.get("v.zpSnippetIDFldName")

        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if(component.isValid()) {
                    var faxDetails = a.getReturnValue();
                    if (faxDetails.sfServer && faxDetails.sfServer.indexOf("https://") < 0) {
                        faxDetails.sfServer = "https://" + faxDetails.sfServer;
                    }
                    component.set("v.faxDetails", faxDetails);
                }
            }else if (state ==="ERROR"){
                var errors = a.getError();
                console.log(JSON.stringify(errors));
                var errText = component.get("v.ErrorText");
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errText);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})