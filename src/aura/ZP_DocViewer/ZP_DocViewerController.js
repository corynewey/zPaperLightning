({
    doInit : function(component, event, helper) {
        helper.getFaxDetails(component);
    },
    handleClick: function (cmp, event) {
        var faxDetails = cmp.get("v.faxDetails");
        var url = 'https://' + faxDetails.zpServer +
            '/kb/jsp/SF_find.lightning.jsp?SFuser=' + faxDetails.sfUser +
            // '&hide=label&dbID=' + faxDetails.zpDBId +        //CRN190327 Don't hide tools when opening doc in new tab/window
            '&dbID=' + faxDetails.zpDBId +
            '&SFserver=' + faxDetails.sfServer +
            'SFsession=' + faxDetails.sfSession + '&zPaper=1220';
        window.open(url, "zPaperMaxWindow");
    },
    handleApplicationEvent : function(cmp, event) {
        var myId = cmp.get("v.docViewerId");        //CRN180618 Support multiple doc viewers on that screen at the same time
        var targetId = event.getParam("targetDocViewer");
        window.console.log("@@@ This viewer Id: " + myId + ", targeted viewer in event: " + targetId);
        if (!myId && !targetId || myId === targetId) {  // if no Id is assigned to neither the viewer or event of if the id's are equal, do below
            var operation = event.getParam("operation");
            var recId = event.getParam("recId");
            var extraInfo = event.getParam("additionalInfo");
            var faxDetails = cmp.get("v.faxDetails");
            var zPDFiFrame = document.getElementById("zPDF_" + myId);
            if (!zPDFiFrame) {  //CRN180710 make sure we didn't have the iFrame that shows initial document
                zPDFiFrame = document.getElementById("zPDF");
            }
            window.console.log("@@@ WE RECEIVED AN APPLICATION EVENT @@@ operation = " + operation + ", recId = " + recId + ", faxDetails = " + faxDetails);
            if (zPDFiFrame && faxDetails) {
                if ("View" === operation || "ViewDocument" === operation) {
                    if (extraInfo) {
                        var src = 'https://' + faxDetails.zpServer + '/kb/jsp/SF_find.lightning.jsp?SFuser=' +
                            faxDetails.sfUser + '&hide=label&dbID=' + extraInfo.dbID +
                            '&SFserver=' + faxDetails.sfServer + '&SFsession=' + faxDetails.sfSession;
                        window.console.log("### Viewing document with Service Call: " + src);
                        //CRN180725 Case #48879 Save the dbID into faxDetails in case it is needed for forward or markup
                        faxDetails.zpDBId = extraInfo.dbID;
                        cmp.set("v.faxDetails", faxDetails);
                        zPDFiFrame.src = src;
                    }
                }
                else if ("ViewBundle" === operation) {
                    if (extraInfo) {
                        // var src = 'https://' + faxDetails.zpServer + '/zpaper-dev/users/bundle/' + recId + '?SFuser=' +
                        //     faxDetails.sfUser + '&SForg=' + faxDetails.sfOrg + '&' + extraInfo.bundleParams +
                        //     '&SFserver=' + faxDetails.sfServer + '&SFsession=' + faxDetails.sfSession;
                        var src = 'https://' + faxDetails.zpServer + '/kb/z/pdfjs/zPDF.jsp?f=' + encodeURIComponent('https://' + faxDetails.zpServer + '/zpaper-dev/users/bundle/' + recId + '?SFuser=' +
                            faxDetails.sfUser + '&SForg=' + faxDetails.sfOrg + '&' + extraInfo.bundleParams +
                            '&SFserver=' + faxDetails.sfServer + '&SFsession=' + faxDetails.sfSession);
                        window.console.log("### Viewing bundle with Service Call: " + src);
                        zPDFiFrame.src = src;
                    }
                }
                else if ("PopToNewWindow" === operation) {
                    debugger;
                    window.console.log("### Popping document out to new window/tab");
                    var action = cmp.get("c.handleClick");      // just call the click handler that was created to handle pop-out putton on viewer component
                    $A.enqueueAction(action);
                }
                else {
                    //CRN180724 Case #48879 Don't allow any non-view event to be processed if we aren't currently viewing a document.
                    if (!zPDFiFrame.src) {
                        alert("Select a document to view from the document set before clicking the ribbon button.");
                        return;
                    }
                    window.console.log("@@@ zpServer = " + faxDetails.zpServer);
                    if (0 === operation.indexOf('click-')) {
                        zPDFiFrame.contentWindow.postMessage(operation, "*");
                    }
                    else if ("Markup" === operation) {
                        zPDFiFrame.src = 'https://' + faxDetails.zpServer + '/kb/jsp/markup.jsp?SFuser=' +
                            faxDetails.sfUser + '&hide=label&dbID=' + faxDetails.zpDBId +
                            '&SFserver=' + faxDetails.sfServer + '&SFsession=' + faxDetails.sfSession;
                    }
                    else if ("Forward" === operation) {
                        zPDFiFrame.src = 'https://' + faxDetails.zpServer + '/kb/jsp/massFaxBin.jsp?SFuser=' +
                            faxDetails.sfUser + '&hide=label&dbID=' + faxDetails.zpDBId + '&forwardID=' + faxDetails.zpDBId +
                            '&sfIDs=' + recId +
                            '&SFserver=' + faxDetails.sfServer + '&SFsession=' + faxDetails.sfSession;
                    }
                }
            }
        }
    }
})