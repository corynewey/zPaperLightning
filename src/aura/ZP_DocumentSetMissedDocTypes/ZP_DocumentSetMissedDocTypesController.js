({
    doInit : function(component, event, helper) {
        window.console.log("####### INSIDE ZP_DocumentSetMissedDocTypes CONTROLLER #########");
        var zpDocsJson = component.get("v.zPDocumentsObj");

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
        var missedDocs = "";
        // now iterate over the types and files
        zDocTypes.forEach(function (dType) {
            var docList = zpDocsJson.docTypeToFileMap[dType];  //CRN170625 Get the list of files that apply to this docType, if any.
            if (!docList) {
                missedDocs += "," + dType.trim();
            }
        });
        var missedTypesBuffer = "";
        missedDocs.split(',').forEach(function (mDocType) {
            if (mDocType.length > 0) {
                missedTypesBuffer += "<span class='slds-badge' style='color:red'>" + mDocType + "</span>";
            }
        });
        if (missedTypesBuffer.length > 0 && component.find("missedDocTypeSpan")) {
            var missedDocTypesDiv = component.find("missedDocTypeSpan") ? component.find("missedDocTypeSpan").getElement() : null;
            var count = 10;
            while (!missedDocTypesDiv && --count > 0) {
                window.console.log("@@@@@@ missedDocyTypesDiv = " + missedDocTypesDiv);
                // wait for the div to be rendered if necessary
                setTimeout(function () {
                    missedDocTypesDiv = component.find("missedDocTypeSpan") ? component.find("missedDocTypeSpan").getElement() : null;
                    if (missedDocTypesDiv) {
                        missedDocTypesDiv.innerHTML = "<span>Missed Doc Types: &nbsp;&nbsp;" + missedTypesBuffer + "</span>";
                    }
                }, 750);
            }
        }
    }
})