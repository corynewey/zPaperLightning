({
    getzPAttachements: function (component, helper, zPDocuments) {
        debugger;
        window.console.log(zPDocuments.rawResponse);
        window.console.log(zPDocuments.jsonResponse);
        window.console.log(zPDocuments.zPaperRequest);
        try {
            // var PendoApp = component.find("PendoApp").getElement();
            // window.console.log("@@@@ PendoApp div => " + PendoApp);
            // helper.setAttrs(PendoApp, {"style": "display:none"});

            component.set('v.zDocStatusNew', zPDocuments.zDocStatusNew);
            var zDocTypes = zPDocuments.lstDocTypesNew;
            //  document.getElementsByClassName("debugText")[0].innerHTML = JSON.stringify(zPDocuments);
            zPDocuments.lstDocTypesOld.forEach(function (DType) {
                //CRN170623 Not sure what this is doing? It looks like it is replacing lstDocTypesNew elements that have wildcards in their name?
                for (var i = 0; i < zDocTypes.length; i++) {
                    if (helper.isDefined(DType) && helper.isDefined(zDocTypes[i]) && DType.indexOf("*") > -1 && DType.includes(zDocTypes[i])) {
                        zDocTypes[i] = DType;
                    }
                }
            });

            //CRN170623 Place the file entries into a DocType -> File List map
            zPDocuments.docTypeToFileMap = {};
            if (zPDocuments.files.length > 0) {
                zPDocuments.files.forEach(function (file) {
                    var list = zPDocuments.docTypeToFileMap[file.X_docType];
                    if (!list) {
                        list = [];
                        zPDocuments.docTypeToFileMap[file.X_docType] = list;
                    }
                    list.push(file);
                });
            }

            // Table Start

            var table = document.createElement('table');
            helper.setAttrs(table, {
                "class": "slds-table slds-table--bordered slds-max-medium-table--stacked",
                "height": "100%",
                "style": "position: relative;"
            });
            var tHead = document.createElement('thead');
            var tr = document.createElement('tr');
            //CRN180226 I don't know who decided that Form fields should display the view link but
            // that is how the code is written and for some reason, sometimes the Form and Type fields
            // are left off of the zDocStatusNew and zDocStatusOld (what???) lists. Add them if they
            // are not found.
            // debugger;
            // if (zPDocuments.zDocStatusNew && zPDocuments.zDocStatusNew.indexOf("Type") < 0) {
            //     // put the type at the front
            //     zPDocuments.zDocStatusNew.splice(0, 0, "Type");
            // }
            // if (zPDocuments.zDocStatusNew && zPDocuments.zDocStatusNew.indexOf("Form") < 0) {
            //     // put the view link at the front
            //     zPDocuments.zDocStatusNew.splice(0, 0, "Form");
            // }
            // if (zPDocuments.zDocStatusOld && zPDocuments.zDocStatusOld.indexOf("Type") < 0) {
            //     // put the type at the front
            //     zPDocuments.zDocStatusOld.splice(0, 0, "Type");
            // }
            // if (zPDocuments.zDocStatusOld && zPDocuments.zDocStatusOld.indexOf("Form") < 0) {
            //     // put the view link at the front
            //     zPDocuments.zDocStatusOld.splice(0, 0, "Form");
            // }
            zPDocuments.zDocStatusNew.forEach(function (field) {
                var th = document.createElement('th');
                helper.setAttrs(th, {"class": "slds-text"});
                var thName = document.createTextNode(field);
                helper.appendChildToParent(th, thName);
                helper.appendChildToParent(tr, th);
            });
            helper.appendChildToParent(tHead, tr);
            helper.appendChildToParent(table, tHead);
            var tBody = document.createElement('tbody');
            helper.appendChildToParent(table, tBody);

            var docTable = component.find("docTableCont").getElement();
            window.console.log("@@@@ docTableCont div => " + docTable);
            if (docTable) {
                //CRN180108 make sure that we don't get multiple tables in this div
                while (docTable.hasChildNodes()) {
                    window.console.log("##### Removing child from docTable: " + docTable.lastChild);
                    docTable.removeChild(docTable.lastChild);
                }
            }
            helper.appendChildToParent(docTable, table);

            var missedDocDiv = component.find("missedDocs").getElement();
            if (missedDocDiv) {
                //CRN180105 make sure that we don't get multiple buttons in this div
                while (missedDocDiv.hasChildNodes()) {
                    window.console.log("##### Removing child from missedDocDiv: " + missedDocDiv.lastChild);
                    missedDocDiv.removeChild(missedDocDiv.lastChild);
                }
            }
            var missDocNameSpan = document.createElement('div');
            helper.appendChildToParent(missDocNameSpan, document.createElement('span').appendChild(document.createTextNode('Missed Doc Types :')));
            helper.appendChildToParent(missedDocDiv, missDocNameSpan);
            helper.appendChildToParent(missedDocDiv, document.createElement('br'));
            // Table Stop

            var mDataTypes = '';
            zDocTypes.forEach(function (DType) {
                var docList = zPDocuments.docTypeToFileMap[DType];  //CRN170625 Get the list of files that apply to this docType, if any.
                if (!docList) {
                    mDataTypes += "," + DType.trim();
                    helper.createEmptyRow(helper, zPDocuments, DType, tBody);
                }
                else {
                    docList.forEach(function (file) {
                        helper.createRow(helper, zPDocuments, file, DType, component, tBody);
                    });
                }
            });

            // Commented by Pra.V after Beta 1 release 7/7/17. Not functioning.

            /*  var mDocs = document.getElementById("mDocs");
              for (var i = zPDocuments.lstDocTypesNew.length - 1; i >= 0; i--) { //CRN170622 this for loop was missing the terminating condition test
                  var mDataTypesArr = mDataTypes.split(",");
                  for (var j = 0; j < mDataTypesArr.length; j++) {	//CRN170622 got rid of forEach() so that we can break when we find a match
                      var str = mDataTypesArr[j];
                      if (zPDocuments.lstDocTypesNew[i].trim() === str.trim()) {
                          zPDocuments.lstDocTypesNew.splice(i, 1);
                          //CRN170622 The splice() call above just removed an element from the array, so we need to decrement our index,
                          // otherwise, we'll just re-process the current entry the next time through the for loop.
                          // NOTE: not doing this and not breaking was causing an error dialog to be displayed because after the splice()
                          // call, i is pointing past the end of the array.
                          i--;
                          break;	//CRN170622 We already found one so no need to look further.
                      }
                  }
              }
              for (var i = 0; i < zPDocuments.lstDocTypesNew.length; i++) {
                  var mDoc = document.createElement('span');
                  helper.setAttrs(mDoc, {"class": "slds-badge", "style": "color:red"});
                  var mData = document.createTextNode(zPDocuments.lstDocTypesNew[i]);
                  mDoc.appendChild(mData);
                  mDocs.appendChild(mDoc);
              } */

            // Added by Pra.V after Beta 1 release 7/7/17. Calling MissedDocs function

            helper.missedDocTypes(mDataTypes, helper, missDocNameSpan);
        } catch (err) {
            console.log('**ERROR**' + err);
        }
    },

    // Modified by Pra.V after Beta 1 release 7/7/17. Replaced all docType --> DType, zObj --> zfile
    createRow: function (helper, zPDocuments, zfile, DType, component, tBody) {
        try {
            var tRow = document.createElement('tr');
            zPDocuments.zDocStatusOld.forEach(function (field) {
                var tDCol = document.createElement('td');
                var dv = document.createElement('div');
                helper.setAttrs(dv, {"scope": "col"});
                helper.appendChildToParent(tDCol, dv);
                if (field == 'Type') {
                    var dataFl = document.createTextNode(DType);
                    helper.appendChildToParent(dv, dataFl);
                } else if (field == 'Updated Date') {
                    if (helper.isDefined(zfile)) {
                        var dataFl2 = document.createTextNode(zfile.modified);
                        if (dataFl2) {
                            helper.appendChildToParent(dv, dataFl2);
                        }
                    }
                } else if (field == 'Form') {
                    if (helper.isDefined(zfile)) {
                        var aLink = document.createElement('a');
                        aLink.id = "Document_View_Link";
                        //helper.setAttrs(aLink, {"target": "_blank","href": zfile.View, "title": zfile.View}); // Initial comment

                        /* var onclickHandler = "sforce.console.getEnclosingPrimaryTabId(function(result){" +
                           " sforce.console.openSubtab(result.id, " + zfile.View + ", true);" +
                           "} );";
                           helper.setAttrs(aLink, {"onclick": onclickHandler,"href": zfile.View, "title": zfile.View}); */

                        var customViewLinkURL;
                        var customViewLinkName;

                        debugger;
                        if (zPDocuments.customViewLinkURL != undefined && zPDocuments.customViewLinkURL != '') {
                            customViewLinkURL = zPDocuments.customViewLinkURL;
                            customViewLinkURL = customViewLinkURL.replace("Record Id", "recId=" + component.get("v.recordId"));
                            customViewLinkURL = customViewLinkURL.replace("Org Id", "orgId=" + zPDocuments.orgId);

                            if (zfile.View != undefined && zfile.View != '') {
                                var url = new URL(zfile.View);
                                customViewLinkURL = customViewLinkURL.replace("dbId", "dbId=" + url.searchParams.get("dbId"));
                            }
                        }
                        else
                            customViewLinkURL = zfile.View;

                        if (zPDocuments.customViewLinkName != undefined && zPDocuments.customViewLinkName != '')
                            customViewLinkName = zPDocuments.customViewLinkName;
                        else
                            customViewLinkName = 'View';

                        // var onclickHandler = "alert('hello'); try{sforce.console.getEnclosingPrimaryTabId(function(result){" +
                        //     " sforce.console.openSubtab(result.id, " + customViewLinkURL + ", true);" +
                        //     "} ); } catch(err) { alert(err); } return false;";
                        var onclickHandler = "event.preventDefault(); try{ alert('in handler'); _appEvent('HelloWorld'); " +
                            "} catch(err) { alert(err); } return false;";
                        // helper.setAttrs(aLink, {"onclick": onclickHandler,"href":customViewLinkURL, "title": customViewLinkURL});
                        // helper.setAttrs(aLink, {"onclick": onclickHandler,"href":"#", "title": customViewLinkURL});
                        helper.setAttrs(aLink, {
                            "target": "new",
                            "href": customViewLinkURL,
                            "title": customViewLinkURL
                            // "onclick": onclickHandler
                        });

                        var dataFl2 = document.createTextNode(customViewLinkName);
                        helper.appendChildToParent(aLink, dataFl2);
                        helper.appendChildToParent(dv, aLink);
                    } else if (DType.indexOf("*") != -1) {
                        dataFl2 = document.createTextNode('This is required.');
                        helper.appendChildToParent(dv, dataFl2);
                    } else {
                        var dataFl2 = document.createTextNode('This is not required.');
                        helper.appendChildToParent(dv, dataFl2);
                    }
                }
                else {
                    var spn1 = document.createElement('span');
                    helper.setAttrs(spn1, {"class": "slds-checkbox"});
                    helper.appendChildToParent(dv, spn1);

                    var ip = document.createElement('input');
                    // Modified by Pra.V after Beta 1 release 7/7/17. Replaced zObj --> zfile
                    var isChecked = (zfile.X_ReviewsMap != '' && helper.isDefined(zfile.X_ReviewsMap[field])) ? true : false;
                    if (isChecked)
                        helper.setAttrs(ip, {"type": "checkbox", "checked": isChecked});
                    else
                        helper.setAttrs(ip, {"type": "checkbox"});
                    helper.appendChildToParent(spn1, ip);

                    var lbl = document.createElement('label');
                    helper.setAttrs(lbl, {"class": "slds-checkbox__label"});
                    helper.appendChildToParent(spn1, lbl);

                    var spn2 = document.createElement('span');
                    // Modified by Pra.V after Beta 1 release 7/7/17. Replaced zObj --> zfile
                    var title = (zfile.X_ReviewsMap != '' && helper.isDefined(zfile.X_ReviewsMap[field])) ? zfile.X_ReviewsMap [field] : '';
                    helper.setAttrs(spn2, {"class": "slds-checkbox--faux", "title": title});
                    helper.appendChildToParent(lbl, spn2);
                }
                helper.appendChildToParent(tRow, tDCol);
            });
            helper.appendChildToParent(tBody, tRow);
            //document.getElementById("data").appendChild(tRow);
        } catch (err) {
            console.log('**ERROR**' + err);
        }
    },

    createEmptyRow: function (helper, zpDocuments, DType, tBody) {
        try {
            var tRow = document.createElement('tr');
            zpDocuments.zDocStatusOld.forEach(function (field) {
                var tDCol = document.createElement('td');
                var dv = document.createElement('div');
                helper.setAttrs(dv, {"scope": "col"});
                helper.appendChildToParent(tDCol, dv);

                if (field === 'Type') {
                    var dataFl = document.createTextNode(DType);
                    helper.appendChildToParent(dv, dataFl);
                } else if (field === 'Updated Date') {

                } else if (field === 'Form') {
                    if (DType.indexOf("*") !== -1) {
                        dataFl2 = document.createTextNode('This is required.');
                        helper.appendChildToParent(dv, dataFl2);
                    } else {
                        var dataFl2 = document.createTextNode('This is not required.');
                        helper.appendChildToParent(dv, dataFl2);
                    }
                }
                else {
                    var spn1 = document.createElement('span');
                    helper.setAttrs(spn1, {"class": "slds-checkbox"});
                    helper.appendChildToParent(dv, spn1);

                    var ip = document.createElement('input');
                    helper.setAttrs(ip, {"type": "checkbox"});
                    helper.appendChildToParent(spn1, ip);

                    var lbl = document.createElement('label');
                    helper.setAttrs(lbl, {"class": "slds-checkbox__label"});
                    helper.appendChildToParent(spn1, lbl);

                    var spn2 = document.createElement('span');
                    helper.setAttrs(spn2, {"class": "slds-checkbox--faux"});
                    helper.appendChildToParent(lbl, spn2);
                }
                helper.appendChildToParent(tRow, tDCol);
            });
            helper.appendChildToParent(tBody, tRow);
            //document.getElementById("data").appendChild(tRow);
        } catch (err) {
            console.log('**ERROR**' + err);
        }
    },

    //Added by Pra.V after Beta 1 release 7/7/17. New Missed DocTypes function.
    missedDocTypes: function (missedDocs, helper, mDocsSpan) {
        try {
            missedDocs.split(',').forEach(function (mDocType) {
                var mDoc = document.createElement('span');
                if (typeof mDoc !== 'undefined' && mDoc) {
                    helper.setAttrs(mDoc, {"class": "slds-badge", "style": "color:red"});
                    var mData = document.createTextNode(mDocType);
                    if (typeof mData !== 'undefined' && mDocsSpan) {
                        mDoc.appendChild(mData);
                    }
                }
                if (typeof mDocsSpan !== 'undefined' && mDocsSpan) {
                    mDocsSpan.appendChild(mDoc);
                }
            });
        } catch (err) {
            console.log('**ERROR**' + err);
        }
    },

    //CRN171212 - Avoid null errors
    appendChildToParent: function(parent, child) {
        if (typeof parent != 'undefined' && parent && typeof child != 'undefined' && child) {
            parent.appendChild(child);
        }
    },

    isDefined: function (ele) {
        return undefined !== ele && null !== ele;
    },

    isBlank: function (ele) {
        return undefined === ele || null === ele || 0 === ele.length;
    },

    setAttrs: function (el, attrs) {
        if (typeof el !== 'undefined' && el) {
            try {
                for (var key in attrs) {
                    if (attrs.hasOwnProperty(key)) {
                        el.setAttribute(key, attrs[key]);
                    }
                }
            } catch (err) {
                console.log('**ERROR**' + err);
            }
        }
    },

    handleClick: function (cmp, event) {
        alert("view click");
    }
})