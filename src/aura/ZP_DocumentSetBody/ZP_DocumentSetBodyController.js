({
    doInit : function(component, event, helper) {
        debugger;
        helper.setNamespace(component);
        var zpDocsJson = component.get("v.zPDocumentsObj");
        // parse the argument into a JSON object
        window.console.log("@@@ zPDocumentsObj Parameter = " + zpDocsJson);
        if (zpDocsJson) {
            window.console.log("@@@ zPDocumentsObj.zDocStatusNew Parameter = " + zpDocsJson.zDocStatusNew);
            window.console.log("@@@ TYPEOF zPDocumentsObj.zDocStatusNew Parameter = " + (typeof zpDocsJson.zDocStatusNew));
            try {
                debugger;
                var zDocTypes = zpDocsJson.lstDocTypesNew;
                //  document.getElementsByClassName("debugText")[0].innerHTML = JSON.stringify(zpDocsJson);
                zpDocsJson.lstDocTypesOld.forEach(function (DType) {
                    //CRN170623 Not sure what this is doing? It looks like it is replacing lstDocTypesNew elements that have wildcards in their name?
                    for (var i = 0; i < zDocTypes.length; i++) {
                        if (helper.isDefined(DType) && helper.isDefined(zDocTypes[i]) && DType.indexOf("*") > -1 && DType.includes(zDocTypes[i])) {
                            zDocTypes[i] = DType;
                        }
                    }
                });
                //CRN170623 Place the file entries into a DocType -> File List map
                zpDocsJson.docTypeToFileMap = {};
                if (zpDocsJson.files.length > 0) {
                    zpDocsJson.files.forEach(function (file) {
                        var list = zpDocsJson.docTypeToFileMap[file.X_docType];
                        if (!list) {
                            list = [];
                            zpDocsJson.docTypeToFileMap[file.X_docType] = list;
                        }
                        list.push(file);
                    });
                }
                var recordId = component.get("v.recordId");
                var mDataTypes = "";
                // now iterate over the types and files
                zDocTypes.forEach(function (dType) {
                    var docList = zpDocsJson.docTypeToFileMap[dType];  //CRN170625 Get the list of files that apply to this docType, if any.
                    if (!docList) {
                        mDataTypes += "," + dType.trim();
                        helper.createRow(zpDocsJson, null, component, dType, recordId);
                    }
                    else {
                        docList.forEach(function (file) {
                            helper.createRow(zpDocsJson, file, component, dType, recordId);
                        });
                    }
                });
                // if (zpDocsJson.zDocStatusNew) {
                //     var tArray = [];
                //     zpDocsJson.zDocStatusNew.forEach(function (field) {
                //         tArray.push(field);
                //     });
                //     zpDocsJson.zDocStatusNew = tArray;
                //     debugger;
                // }
                // else {
                //     zpDocsJson.zDocStatusNew = [];
                //     zpDocsJson.zDocStatusNew.push("@@ No Status Categories Found @@");
                // }
            }
            catch (err) {
                window.console.log("################# Exception Caught ##################################");
                window.console.log(err);
                window.console.log("################# Exception Caught ##################################");
            }
        }
    }
})