/**
 * Created by User on 5/24/2019.
 */
import {LightningElement, api, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPickListEntries from '@salesforce/apex/MultiFileUploaderController.getPicklistEntries';
import uploadFile from '@salesforce/apex/MultiFileUploaderController.uploadFile';
import uploadChunk from '@salesforce/apex/MultiFileUploaderController.uploadChunk';

export default class MultiFileUploader extends LightningElement {

    @api filenamePicklist;
    @api filenamePicklistLabel;
    @api filenameTemplate;
    @api filenameExtensionList;
    @api recordId;
    @track picklistPromptLabel;
    @track acceptedFormats = ['*.*'];
    @track picklistEntries = [];
    @track filenamesToUpload = '';
    selectedFiles = [];
    picklistValue = 'NONE';
    couldNotPullPicklist = false;

    @wire(getPickListEntries, { picklistName: '$filenamePicklist' })
    wiredResult({error, data}) {
        if (error) {
// If the user is an unauthenticated Guest user, the wired controller won't get called but we will get an error here.
// This component should be hidden from Communities Guest users by setting the Audience but we'll also attempt to notify
// the user that they need to log in to make up for a Salesforce administrator that hasn't correctly hidden this component
// from Guest users.
            this.showNotification("Error", "Error calling APEX: " +
                error.message ? error.message :
                "Are you a Communities user that hasn't logged in yet? If so, log in before using this upload component.", "error");
            this.couldNotPullPicklist = true;
            return;
        }
        console.log("@@@ error from APEX: " + error ? JSON.stringify(error) : "null");
        console.log("@@@ data from APEX: " + data ? JSON.stringify(data) : "null");
        if (data) {
            for (let key in data) {
                if (data.hasOwnProperty(key)) {
                    let entry = data[key];
                    this.picklistEntries.push({label:entry.label, value:entry.value});
                }
            }
        }
        // break up the supported extension list into array
        if (this.filenameExtensionList) {
            this.acceptedFormats = [];
            let parts = this.filenameExtensionList.split(',');
            for (let i in parts) {
                let ext = parts[i].trim();
                let idx = ext.indexOf('.');
                if (idx >= 0) {
                    ext = ext.substring(idx + 1);
                }
                this.acceptedFormats.push('.' + ext);
            }
        }
        // Initialize the picklist prompt
        if (this.filenamePicklistLabel) { this.picklistPromptLabel = this.filenamePicklistLabel; }
    }

    picklistChange(event) {
        this.picklistValue = event.target.value;
    }

    handleFileChange(event) {
        let fileList = event.target.files;
        for (let i in fileList) {
            if (fileList.hasOwnProperty(i)) {
                let file = fileList[i];
                if (this.validateFileExtension(file.name)) {
                    this.selectedFiles.push(file);
                    this.filenamesToUpload += (this.filenamesToUpload.length > 0 ? ", " : "") + file.name;
                } else {
                    this.showNotification("Warning",
                        file.name + " will not be uploaded. It is not a supported file format.",
                        "warning");
                }
            }
        }
    }

    // Assure that the filename has a supported file extension.
    validateFileExtension(filename) {
        for (let i in this.acceptedFormats) {
            let extension = this.acceptedFormats[i];
            if ("*.*" === extension || ".*" === extension ||
                (filename.length > extension.length &&
                    filename.indexOf(extension, filename.length - extension.length) >= 0)) {
                return true;
            }
        }
        return false;
    }

    MAX_FILE_SIZE       = 5999990;      //Max file size ~4.5 MB (base64-encode size ~6 M)
    CHUNK_SIZE          = 750000;      //Chunk Max size 750Kb
    BASE64_URL_PREFIX   = "data:application/pdf;base64,";

    // Work with APEX Controller to upload the selected file(s).
    handleUpload() {
        if (this.couldNotPullPicklist) {
            this.showNotification("Error",
                "Are you a Communities user that hasn't logged in yet? If so, log in before using this upload component.", "error");
            return;
        }
        if (0 === this.selectedFiles.length) {
            this.showNotification("Error", "You must choose at least one file to upload.", "error");
            return;
        }
        if (this.filenamePicklist && 'NONE' === this.picklistValue) {
            this.showNotification("Error", "You must choose a value from the picklist.", "error");
            return;
        }
        this.showWait();
        let filesLeftToUpload = this.selectedFiles ? this.selectedFiles.length - 1 : 0;
        for (let i in this.selectedFiles) {
            let file = this.selectedFiles[i];
            let reader = new FileReader();
            let self = this;
            reader.onload = function(e) {
                let fileData = e.target.result;
                self.uploadProcess(file, fileData, filesLeftToUpload--);
            };
            reader.onerror = function(event) {
                reader.abort();
                console.log("### Error reading uploaded file: " + event);
                self.showNotification("Error", error.message, "error");
            };
            reader.readAsDataURL(file);
            console.log("@@@ Reading in the upload file")
        }
        this.filenamesToUpload = '';
        this.selectedFiles = [];
        let selList = this.template.querySelectorAll('select');
        console.log("#### Number of picklist <select> tags found: " + selList.length);
        if (selList) {
            selList.forEach(function(ele) {
                console.log("#### this: " + this + ", ele: " + ele);
                if (ele.id && 0 === ele.id.indexOf('select-upload')) { ele.value = ''; }
            });
        }
    }

    uploadProcess(file, fileContents, filesLeftToUpload) {
        if (0 === fileContents.indexOf(this.BASE64_URL_PREFIX)) {
            // Get rid of the URL prefix that should come before the base64-encoded file data.
            fileContents = fileContents.substring(this.BASE64_URL_PREFIX.length);
        }
        if (fileContents.length > this.MAX_FILE_SIZE) {
            this.showNotification("ERROR", "File is too big. Files larger than 4.5 MB cannot be uploaded.", "error");
            if (0 === filesLeftToUpload) {
                this.hideWait();
            }
            return;
        }

        // set a default size or startpostiton as 0
        let startPosition = 0;
        // calculate the end size or endPostion using Math.min() function
        let endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // start with the initial chunk
        this.uploadInChunk(file, fileContents, startPosition, endPosition, '', filesLeftToUpload);
    }

    uploadInChunk(file, fileContents, startPosition, endPosition, attachId, filesLeftToUpload) {
        let template = this.filenameTemplate;
        let recordId = this.recordId;
        let pickValue = this.picklistValue;
        let self = this;
        // no need to worry about endPosition going past the end of the string. If that happens, the
        // substring call will just go until the end of the string just like it were instead called
        // like this: fileContents.substring(startPosition)
        let chunk = fileContents.substring(startPosition, endPosition);
        debugger;
        uploadChunk({
            attachId: attachId,
            fileName: file.name,
            fileType: file.type,
            fileSize: file.size,
            base64Data: chunk,
            template: template,
            pickValue: pickValue,
            recordId: recordId,
            isComplete: endPosition === fileContents.length
        }).then(result => {
            console.log("@@@ APEX Upload Response: " + result);
            debugger;
            result = JSON.parse(result);
            // The APEX Controller will return a status of either PENDING, COMPLETE, or ERROR:...
            if ("PENDING" === result.status) {
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + self.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    // sanity check...
                    self.uploadInChunk(file, fileContents, startPosition, endPosition, result.attachId, filesLeftToUpload);
                }
                else {
                    self.showNotification("Error", "APEX code lost track of file size and didn't upload the file to zPaper.", "error");
                    if (0 === filesLeftToUpload) {
                        self.hideWait();
                    }
                }
            }
            else if ("ERROR" === result.status) {
                self.showNotification("Error", "Failed to upload file: " + file.name + " to zPaper: " + result.message, "error");
                if (0 === filesLeftToUpload) {
                    self.hideWait();
                }
            }
            else {
                debugger;
                console.log("@@@ upload succeeded. Result: " + result);
                // self.showNotification("Success", "File: " + file.name + " was successfully uploaded to zPaper", "success");
                self.showNotification("Success", result.message, "success");
                if (0 === filesLeftToUpload) {
                    self.hideWait();
                }
            }
        }).catch(error => {
            debugger;
            console.log("@@@ upload failed. Error: " + JSON.stringify(error));
            self.showNotification("Error", "Failed to upload file: " + file.name + ": " +
                (typeof error === 'string' ? error : error.statusText ? error.statusText : JSON.stringify(error)), "error");
            if (0 === filesLeftToUpload) {
                self.hideWait();
            }
        });
    }

    showWait() {
        let msgPanel = this.template.querySelector('[data-id="msgPanel"]');
        msgPanel.innerHTML = "Uploading file(s). Please Wait...";
        msgPanel.style.display = 'block';
        // let bodyPanel = this.template.querySelector('[data-id="bodyPanel"]');
        // bodyPanel.style.display = 'none';
    }

    hideWait() {
        let msgPanel = this.template.querySelector('[data-id="msgPanel"]');
        msgPanel.style.display = 'none';
        // let bodyPanel = this.template.querySelector('[data-id="bodyPanel"]');
        // bodyPanel.style.display = 'block';
    }

    showNotification(titleTxt, msg, variant) {
        const evt = new ShowToastEvent({
            title: titleTxt,
            message: msg,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    //CRN190522 I was trying to increase the size of the drop area but it appears to be impossible
    //
    // renderedCallback() {
    //     debugger;
    //     let container = this.template.querySelector('lightning-input');
    //     let divs = this.template.querySelectorAll('div');
    //     let divFiles = this.template.querySelectorAll('.slds-file-selector_files');
    //     let dropZone = this.template.querySelectorAll('lightning-primitive-file-droppable-zone');
    //     let dropZoneByClass = this.template.querySelectorAll('.slds-file-selector__dropzone');
    //     console.log("@@@ container = " + container.innerHTML);
    //     container.style.width = '100%';
    //     divs.forEach(function(item, index) {
    //         item.style.width = '100%';
    //     });
    //     dropZone.forEach(function(item, index) {
    //         item.style.width = '100%';
    //     });
    //     dropZoneByClass.forEach(function(item, index) {
    //         item.style.width = '100%';
    //     });
    //     divFiles.forEach(function(item, index) {
    //         item.style.width = '100%';
    //     });
    //     // dropZone.style.width = '100%';
    //     // this.setChildrenWidth(container.getRootNode(), '100%');
    // }
    //
    // setChildrenWidth(parentNode, width) {
    //     console.log("@@@ parentNode HTML = " + parentNode.innerHTML);
    //     for (let i=0; i<parentNode.children.length; i++) {
    //         let node = parentNode.children[i];
    //         console.log("@@@ node tagName: " + node.tagName + ", style = " + node.style);
    //         if (node.tagName && node.style) {
    //             node.style.width = width;
    //             this.setChildrenWidth(node, width);
    //         }
    //     }
    // }
}