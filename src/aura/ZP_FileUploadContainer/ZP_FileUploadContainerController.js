/**
 * Created by User on 8/29/2018.
 */
({
    doInit : function(component, event, helper) {
        // Pull the picklist items if necessary.
        helper.getPicklistEntries(component, event, helper);

        //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        component.set('v.lcHost', window.location.hostname);

        //CRN180904 We can't just use relative URLs to pull the VF Page because if we are embedded into
        // a Communities page, the host will be all wrong. Get the host from our controller.
        var action = component.get("c.getForceDotComHost");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var host = response.getReturnValue();
                // var frameSrc = '/apex/UploadFilePage?id=' + component.get('v.recordId') + '&lcHost=' + component.get('v.lcHost');
                var frameSrc = host + '/apex/ZPAPER5__ZP_FileUpload?id=' + component.get('v.recordId') +
                    '&lcHost=' + component.get('v.lcHost') + '&template=' + component.get('v.uploadFileTemplate');
                console.log('frameSrc:', frameSrc);
                component.set('v.frameSrc', frameSrc);
            }
            else {
                alert("Error calling Apex Controller: " + response.getError());
            }
        });
        $A.enqueueAction(action);
        action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var username = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.username", username);
            }
        });
        $A.enqueueAction(action);

        //Add message listener
        window.addEventListener("message", function(event) {

            console.log('event.data:', event.data);

            // Handle the message
            if(event.data.state === 'LOADED'){
                //Set vfHost which will be used later to send message
                component.set('v.vfHost', event.data.vfHost);
            }

            if(event.data.state === 'uploadFileSelected'){
                component.find('uploadFileButton').set('v.disabled', false);
            }

            if(event.data.state === 'fileUploadprocessed') {
                //CRN180910 Since this event was captured by javascript that wasn't inside of the normal
                //Lightning component flow, it doesn't reliably display the uiMessage area, especially
                //when on the Community page. Because of that, I'm going to use the Toast message
                //to display the upload file results.
                var eleContainer = document.getElementById("uiMessageContainer");
                if (eleContainer) { eleContainer.style.display = "none"; }
                var severity = 'confirm' === event.data.messageType ? 'success' : event.data.messageType;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'dismissible',
                    message: event.data.message,
                    type: severity,
                    duration: 7500
                });
                toastEvent.fire();
            }
        }, false);
    },
    sendMessage: function(component, event, helper) {
        component.find("uiMessage").set("v.body", []);      // clear the message area
        // First make sure the user has selected a value from the picklist, if it has been specified
        var sfPicklist = component.get("v.sfPicklist");
        var selectedValue = "";
        if (sfPicklist) {
            selectedValue = component.find("uploadPicklist").get("v.value");
            if (!selectedValue) {
                helper.showMessage(component, "You must select a value before uploading the file", "error");
                return;
            }
        }
        var template = component.get("v.uploadFileTemplate");
        var username = component.get("v.username");
        // {pickValue}, {recId}
        template = template.replace("{pickValue}", selectedValue)
                           .replace("{recId}", component.get("v.recordId"))
                           .replace("{username}", username);
        //Please wait...
        helper.showMessage(component, "Please wait - uploading file...", "info");

        //Prepare message in the format required in VF page
        var message = {
            "uploadFile" : true,
            "propValue" : selectedValue,
            "template" : template
        } ;
        //Send message to VF
        helper.sendMessage(component, helper, message);
    }
})