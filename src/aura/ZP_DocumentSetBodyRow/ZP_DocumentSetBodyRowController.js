({
    doInit : function(component, event, helper) {
        var zpDocsJson = component.get("v.zPDocumentsObj");
        // parse the argument into a JSON object
        window.console.log("@@@ zPDocumentsObj Parameter = " + zpDocsJson);
        if (zpDocsJson) {
            window.console.log("@@@ zPDocumentsObj.zDocStatusNew Parameter = " + zpDocsJson.zDocStatusNew);
            window.console.log("@@@ TYPEOF zPDocumentsObj.zDocStatusNew Parameter = " + (typeof zpDocsJson.zDocStatusNew));
            try {
                var file = component.get("v.zpFile");
                var colLocation = null;
                if (zpDocsJson.zActionButtons) {
                    // var donotShowTheseActions = [];
                    for (var i in zpDocsJson.zActionButtons) {
                        if (zpDocsJson.zActionButtons.hasOwnProperty(i)) {
                            var actionBtn = zpDocsJson.zActionButtons[i];
                            if (!colLocation) { // don't allow buttons in both first and last columns
                                colLocation = actionBtn.colLocation;
                                if ("Last" === colLocation) {
                                    component.set("v.actionIsLast", true);
                                }
                                else {
                                    component.set("v.actionIsFirst", true);
                                }
                            }
                            //CRN180808 Case #50295 Check for "only show in certain Stages actions"
                            //CRN180808 If there is not file, no buttons are shown so we don't need to worry about removing action buttons.
                            if (actionBtn.visibleInStages && !helper.isBlank(file)) {
                                var btnToRemove = actionBtn;
                                var stagesArr = actionBtn.visibleInStages.split(',');
                                var reviewsMap = file.X_ReviewsMap;
                                for (var i in zpDocsJson.zDocStatusNew) {
                                    if (zpDocsJson.zDocStatusNew.hasOwnProperty(i)) {
                                        var stage = zpDocsJson.zDocStatusNew[i];
                                        if (stagesArr.indexOf(stage) >= 0 && reviewsMap[stage]) {
                                            //CRN180808 At least one of the required stages is checked; leave the action button
                                            btnToRemove = null;
                                            break;
                                        }
                                    }
                                }
                                //CRN180808 Add button to remove list if defined
                                if (btnToRemove) {
                                    // donotShowTheseActions.push(btnToRemove);
                                    btnToRemove['doNotDisplay'] = true;
                                    component.set("v.zPDocumentsObj", zpDocsJson);
                                }
                            }
                        }
                    }
                    //CRN180808 Remove any action buttons that required a checked stage that wasn't checked.
                    // if (donotShowTheseActions.length > 0) {
                    //     debugger;
                    //     for (var i in donotShowTheseActions) {
                    //         if (donotShowTheseActions.hasOwnProperty(i)) {
                    //             helper.removeActionFromList(zpDocsJson.zActionButtons, donotShowTheseActions[i]);
                    //         }
                    //     }
                    // }
                }
                window.console.log("v.actionIsLast = " + component.get("v.actionIsLast"));
                window.console.log("v.actionIsFirst = " + component.get("v.actionIsFirst"));
                if (!helper.isBlank(file)) {
                    if (!helper.isBlank(zpDocsJson.customViewLinkName)) {
                        var linkName = zpDocsJson.customViewLinkName;
                        var idxEnd = 0;
                        while (linkName.indexOf("{!", idxEnd) >= 0) {
                            // parse out all of the strings to be replaced
                            var idxBegin = linkName.indexOf("{!");
                            if (idxBegin >= 0) {
                                idxEnd = linkName.indexOf("}", idxBegin);
                                if (idxEnd > idxBegin) {
                                    var replace = linkName.substring(idxBegin, idxEnd+1);
                                    var replaceWith = linkName.substring(idxBegin+2, idxEnd);
                                    if (0 === replaceWith.indexOf("file")) {
                                        // can't use eval
                                        // linkName = linkName.replace(replace, eval(replaceWith));
                                        linkName = linkName.replace(replace, file[helper.getReplaceProperty(replaceWith, "file")]);
                                    }
                                }
                            }
                        }
                        component.set("v.viewLinkLabel", linkName);
                    }
                    if (!helper.isBlank(zpDocsJson.customViewLinkURL)) {
                        component.set("v.viewLinkURL", zpDocsJson.customViewLinkURL);
                    }
                }
            }
            catch (err) {
                window.console.log("################# Exception Caught ##################################");
                window.console.log(err);
                window.console.log("################# Exception Caught ##################################");
            }
        }
    },
    jsFireEvent : function(component, event, helper) {
        var fireEventLabel = "fireEvent:";
        window.console.log("#### fireEvent label = " + fireEventLabel);
        var event = component.get("v.viewLinkURL");
        window.console.log("FIRING EVENT: " + component.get("v.viewLinkURL"));
        var idxBegin = event.indexOf(fireEventLabel);
        var file = component.get("v.zpFile");
        if (idxBegin >= 0) {
            idxBegin += fireEventLabel.length;
            var idxEnd = event.indexOf('?', idxBegin);
            var eventOp = idxEnd > idxBegin ? event.substring(idxBegin, idxEnd) : event.substring(idxBegin);
            var appEvent = $A.get("e.c:ZP_Event_DocViewer");
            appEvent.setParams({
                "operation" : eventOp,
                "recId" : component.get("v.recordId"),
                "additionalInfo" : JSON.parse('{"dbID":"' + file.ID + '"}')
            });
            appEvent.fire();
        }
    },
    jsFireActionBtnEvent : function(component, event, helper) {
        //NOTE: notice that I have appended "js" to the front of this controller. The reason for this
        // is that if the js client controller function name matches the APEX method name, you get into
        // an endless loop such that this client-side controller is called continuously.
        var zpDocsJson = component.get("v.zPDocumentsObj");
        var actionIdx = event.currentTarget.name;
        var actionBtn = zpDocsJson.zActionButtons[actionIdx];
        var action = component.get("c.callZPaperService");
        var zpFile = component.get("v.zpFile");
        if (zpFile) {
            if (actionBtn.component) {
                var stdParms = {
                    "recordId" : component.get("v.recordId"),
                    "dbID" : zpFile.ID
                };
                var componentName = actionBtn.component;
                var idxParm = componentName.indexOf('?');
                if (idxParm >= 0) {
                    //CRN180530 Allowing the user to specify parameters to send to component
                    var componentParms = componentName.substring(idxParm + 1);
                    componentName = componentName.substring(0, idxParm);
                    var parts = componentParms.split('&');
                    for (var i in parts) {
                        var parm = parts[i];
                        if (parm) {
                            var subParts = parm.split('=');
                            if (2 === subParts.length) {
                                stdParms[subParts[0]] = subParts[1];
                            }
                        }
                    }
                }
                $A.createComponent(
                    componentName,
                    stdParms,
                    function(newComponent) {
                        var content = component.get("v.body");
                        component.set("v.body", newComponent);
                    }
                );
            }
            else {
                action.setParams({
                    recordId: component.get("v.recordId"),
                    dbId: zpFile.ID,
                    eventName: actionBtn.eventName
                });
                action.setCallback(this, function (a) {
                    var returnVal = a.getReturnValue();
                    if (returnVal) {
                        window.console.log(JSON.stringify(returnVal));
                    }
                    var state = a.getState();
                    if (state === "SUCCESS") {
                        alert("Requested operation completed by zPaper.");
                        // fire an event to our parent container to force refresh
                        var compEvent = component.getEvent("ZPEventDocSet");
                        compEvent.setParams({"type": "Refresh"});
                        compEvent.fire();
                    }
                    else if (state === "ERROR") {
                        //CRN180404 ToDo: dispatch a component event that the parent component can catch to display the error
                        var errors = a.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                alert("ERROR: " + errText);
                            }
                        } else {
                            alert("ERROR: Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        }
    }
})