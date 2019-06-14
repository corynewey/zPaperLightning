/**
 * Created by User on 5/24/2019.
 */

global class MultiFileUploaderController {
//    public transient Attachment objAttachment;

    // Use getter so we can make attachment transient

    @AuraEnabled(Cacheable=true)
    global static List<Map<String,String>> getPicklistEntries(String picklistName) {
        List<Map<String,String>> items = new List<Map<String,String>>();

// If the user is an unauthenticated Guest user, we won't even get called but the lwc javascript controller will get an error.
// This component should be hidden from Communities Guest users by setting the Audience but I'll refactor the javascript controller
// to be in an inactive state if we can't pull the picklist entries.
//        // make sure the user is logged in (in Communities, the user could be unauthenticated)
//        if (null == UserInfo.getUserName()) {
//            return items;
//        }

        System.debug('@@@ Pulling picklist items for picklist: ' + picklistName);
        // The picklist Name must include the SObject name separated with a dot.
        if (null != picklistName && picklistName.indexOf('.') > 0) {
            try {
                List<String> parts = picklistName.split('\\.');
                String sObjectName = parts[0];
                String fldName = parts[1];
                Schema.SObjectField picklist = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fldName);
                System.debug('picklist field = ' + picklist);
                //            List<PicklistEntry> picklistValues = picklist.getDescribe().picklistValues;
                for (PicklistEntry entry : picklist.getDescribe().picklistValues) {
                    System.debug('Picklist Entry => label = ' + entry.label + ', value = ' + entry.value);
                    items.add(new Map<String, String>{
                            'value' => entry.value, 'label' => entry.label
                    });
                }
            } catch (Exception e) {
                //ToDo: we need a logging object that we can log errors in.
                System.debug('ERROR: exception while pulling picklist values: ' + e.getMessage());
            }
        }
        return items;
    }

    @AuraEnabled
    global static String uploadFile(
            String fileName,
            String fileType,
            Integer fileSize,
            String base64Data,
            String template,
            String pickValue,
            String recordId) {
        System.debug('@@@@ UPLOAD: fileName = ' + fileName);
        System.debug('@@@@ UPLOAD: fileType = ' + fileType);
        System.debug('@@@@ UPLOAD: fileSize = ' + fileSize);
        System.debug('@@@@ UPLOAD: fileData = ' + base64Data.substring(0, 250));
        System.debug('@@@@ UPLOAD: template = ' + template);
        System.debug('@@@@ UPLOAD: pickValue = ' + pickValue);
        System.debug('@@@@ UPLOAD: recordId = ' + recordId);
        return 'SUCCESS: file uploaded: name = ' + fileName + ', type = ' + fileType + ', size = ' + fileSize + ', data = ' + base64Data.substring(0, 200);
    }

    private static final String BASE64_URL_START = 'data:application/pdf;base64,';

    @AuraEnabled
    global static String uploadChunk(
            String attachId,
            String fileName,
            String fileType,
            Integer fileSize,
            String base64Data,
            String template,
            String pickValue,
            String recordId,
            Boolean isComplete) {
        System.debug('@@@@ UPLOAD: fileName = ' + fileName);
        System.debug('@@@@ UPLOAD: fileType = ' + fileType);
        System.debug('@@@@ UPLOAD: fileSize = ' + fileSize);
        System.debug('@@@@ UPLOAD: fileData = ' + base64Data.substring(0, 40));
        System.debug('@@@@ UPLOAD: template = ' + template);
        System.debug('@@@@ UPLOAD: pickValue = ' + pickValue);
        System.debug('@@@@ UPLOAD: attachId = ' + attachId);
        System.debug('@@@@ UPLOAD: recordId = ' + recordId);

        try {
            // Is this the first chunk?
            if (!isComplete && (null == attachId || 0 == attachId.length())) {
                return initSave(fileName, base64Data, buildCallingInfoJSON(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete));
            }
            // Either the upload is done or we are receiving the next chunk.
            return continueSave(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete);
        } catch (Exception e) {
            return buildStatusJSON('"ERROR', 'Exception while uploading file: ' + e.getMessage(), null,
                    buildCallingInfoJSON(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete), null);
        }
    }

    private static String initSave(String filename, String base64Data, String callingParms) {
        String debugBuffer = '';
        debugBuffer += '<br/>@@@ START: base64Data length = ' + base64Data.length();
        //base64Data starts with: data:application/pdf;base64,
        if (base64Data.startsWith(BASE64_URL_START)) {
            base64Data = base64Data.substring(BASE64_URL_START.length());
        }
        debugBuffer += '<br/>@@@ AFTER REMOVING URL START: base64Data length = ' + base64Data.length();
        debugBuffer += '<br/>@@@ First 80 chars of initial chunk = ' + base64Data.substring(0, 80);
        // Get the zStore record that will be the parent of the attachments
        ZPAPER__zStore__c store;
        List<ZPAPER__zStore__c> stores = [SELECT Id,Name FROM ZPAPER__zStore__c];
        if (0 == stores.size()) {
            debugBuffer += '<br/>@@@ Creating new zStore object';
            // we need to create the zStore record
            store = new ZPAPER__zStore__c();
            insert store;
        }
        else {
            store = stores[0];
        }
        debugBuffer += '<br/>@@@ zStore Id = ' + store.Id;
        // Now create the Attachment that will hold our content
        Attachment attachment = new Attachment();
        attachment.ParentId = store.Id;
        attachment.Name = filename;
//        attachment.Body = Blob.valueOf(base64Data);
        attachment.Body = EncodingUtil.base64Decode(base64Data);
        insert attachment;
        debugBuffer += '<br/>@@@ Initial Attachment Body Size = ' + attachment.Body.size() + ', Unencoded Body Size = ' + EncodingUtil.base64Encode(attachment.Body).length() + ', Initial Chunk Size = ' + base64Data.length();
        debugBuffer += '<br/>@@@ New Attachment: Id = ' + attachment.Id;
        return buildStatusJSON('PENDING', 'Buffering file content to prepare upload to zPaper server.', attachment.Id, callingParms, debugBuffer);
    }

    private static String continueSave(
            String attachId,
            String fileName,
            String fileType,
            Integer fileSize,
            String base64Data,
            String template,
            String pickValue,
            String recordId,
            Boolean isComplete) {

        String existingBody = base64Data;
        Attachment attachment = null;
        String debugBuffer = '';
        if (null != attachId && attachId.length() > 0) {
            List<Attachment> attachments = [SELECT Body FROM Attachment WHERE Id = :attachId];
            if (0 == attachments.size()) {
                return buildStatusJSON('ERROR', 'Upload failed: no buffer Attachment found for Id: ' + attachId + '.', null,
                        buildCallingInfoJSON(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete), null);
            }
            attachment = attachments[0];
            debugBuffer += '<br/>@@@ New base64Data length = ' + base64Data.length();
            debugBuffer += '<br/>@@@ Size of current Attachment Body = ' + EncodingUtil.base64Encode(attachments[0].Body).length();
            existingBody = EncodingUtil.base64Encode(attachments[0].Body) + existingBody;
            debugBuffer += '<br/>@@@ existingBody: length = ' + existingBody.length() + ', first 80 chars = ' + existingBody.substring(0, 80);
            // If this isn't the last chunk, just update the attachment and return.
            if (!isComplete) {
                debugBuffer += '<br/>@@@ Adding chunk to Attachment, fileName = ' + fileName + ', attachId = ' + attachId;
                attachment.Body = EncodingUtil.base64Decode(existingBody);
                update attachment;
                debugBuffer += '<br/>@@@ Current Attachment Body Size = ' + attachment.Body.size() + ', Current Chunk Size = ' + base64Data.length();
                return buildStatusJSON('PENDING', 'Buffering file content to prepare upload to zPaper server.', attachment.Id,
                        buildCallingInfoJSON(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete), debugBuffer);
            }
        }
        // This is the last chunk to save, do the upload to zPaper.
        Blob fileBlob  = EncodingUtil.base64Decode(existingBody);
        debugBuffer += '<br/>@@@ Full base64-encode size: ' + fileBlob.size();

        String userName = UserInfo.getUserName();

        // {username}, {pickValue}, {recId}, {timestamp}
        Long currentTimeMillis = Datetime.now().getTime();
        template = template
                .replace('{username}', userName)
                .replace('{pickValue}',(null != pickValue ? pickValue : ''))
                .replace('{orgId}', UserInfo.getOrganizationId())
                .replace('{recId}', null != recordId ? recordId : 'UNKNOWN')
                .replace('{timestamp}', currentTimeMillis + '');
        String uploadFileName = template + fileName.replace('_', ' ').replace('-', ' ');
        debugBuffer += '<br/>@@ uploadFileName: ' + uploadFileName;

        // Call upload.jsp (ToDo: do we need to worry about authentication?
        String form64 = HttpMultipartFormBuilder.writeBoundary();
        form64 += HttpMultipartFormBuilder.writeBodyParameter('uploadDir' , 'lightningUpload');
        form64 += HttpMultipartFormBuilder.writeBoundary();
        HttpMultipartFormBuilder.WriteFileResult result =
                HttpMultipartFormBuilder.writeFile('file',
                        uploadFileName,
                        fileType,
                        fileBlob);
        form64 += result.Content;
        form64 += HttpMultipartFormBuilder.writeBoundary(result.EndingType);
//        Blob formBlob = Blob.valueOf(form64);
        Blob formBlob = EncodingUtil.base64Decode(form64);
        debugBuffer += '<br/>@@@@ MultiPart Form Body *********************\n' + formBlob + '\n**********************************************';
        String contentLength = formBlob.size() + '';

        debugBuffer += '<br/>Form body length = ' + contentLength + ', pass-ed in content length = ' + fileSize + ', CONVERTED SIZE EQUAL? ' + (fileBlob.size() == fileSize);
        List<ZPAPER5__ZP_Partner_Setting__mdt> partnerSettings =
        [SELECT ZPAPER5__Partner_API_Host__c,DeveloperName,MasterLabel FROM ZPAPER5__ZP_Partner_Setting__mdt WHERE DeveloperName = 'ZP_General_Settings' ];
        debugBuffer += '<br/>@@@ Partner Settings List = ' + partnerSettings;
        String zpServer = '';
        if (partnerSettings.size() > 0) {
            debugBuffer += '<br/>### Settings[0]: Api Host = ' + partnerSettings[0].ZPAPER5__Partner_API_Host__c;
            debugBuffer += '<br/>### Settings[0]: Name = ' + partnerSettings[0].DeveloperName;
            debugBuffer += '<br/>### Settings[0]: Label = ' + partnerSettings[0].MasterLabel;
            debugBuffer += '<br/>@@@ Setting api host from General Settings: ' + partnerSettings[0].ZPAPER5__Partner_API_Host__c;
            zpServer = partnerSettings[0].ZPAPER5__Partner_API_Host__c;
        }
        if (!zpServer.startsWith('https://')) { zpServer = 'https://' + zpServer; }
        if (!zpServer.endsWith('/')) { zpServer += '/'; }

        // Now send the Http request
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setBodyAsBlob(formBlob);
        //            req.setEndpoint('https://zp20.zpaper.com/kb/jsp/newUpload.jsp');
        req.setEndpoint(zpServer + 'kb/jsp/newUpload.jsp');
        debugBuffer += '<br/>#### Calling URL on zPaper server: ' + zpServer + 'kb/jsp/newUpload.jsp';
        req.setHeader('Content-Length', contentLength);
        req.setHeader('Content-Type', HttpMultipartFormBuilder.getContentType());
        Http h = new Http();
        HttpResponse response = h.send(req);
        debugBuffer += '<br/>#### HTTP Response from zPaper server: ' + response.getStatusCode() + ' -- ' + response.getStatus();

        if (null != attachment) {
            // clean up the Attachment, it is no longer needed
            debugBuffer += '<br/>@@@ Deleting attachment with Id: ' + attachment.Id;
            delete attachment;
        }

        if (200 != response.getStatusCode()) {
            return buildStatusJSON('ERROR', 'Failed to upload file: Error status received from zPaper server = ' + response.getStatus(), null,
                    buildCallingInfoJSON(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete), debugBuffer);
        }
        return buildStatusJSON('COMPLETE', 'File ' + fileName + ' successfully upload to zPaper.', null,
                buildCallingInfoJSON(attachId, fileName, fileType, fileSize, base64Data, template, pickValue, recordId, isComplete), debugBuffer);
    }

    private static String buildStatusJSON(String status, String message, String attachId, String parms, String extraInfo) {
        return '{"status":"' + status + '", "message":"' + message +
                (null != attachId && attachId.length() > 0 ? '", "attachId": "' + attachId : '') +
                (null != parms && parms.length() > 0 ? '", "receivedParams": ' + parms : '""') +
                (null != extraInfo && extraInfo.length() > 0 ? ', "extraInfo": "' + extraInfo.replace('\n', '<br/>') : '') + '"}';
    }

    private static String buildCallingInfoJSON(
            String attachId,
            String fileName,
            String fileType,
            Integer fileSize,
            String base64Data,
            String template,
            String pickValue,
            String recordId,
            Boolean isComplete) {
        return '{"attachId":"' + attachId + '"' +
                ',"fileName":"' + fileName + '"' +
                ',"fileType":"' + fileType + '"' +
                ',"fileSize":"' + fileSize + '"' +
                ',"base64Data":"' + (null != base64Data && base64Data.length() > 200 ? base64Data.substring(0, 200) : base64Data) + '"' +
                ',"template":"' + template + '"' +
                ',"pickValue":"' + pickValue + '"' +
                ',"recordId":"' + recordId + '"' +
                ',"isComplete":"' + isComplete + '"' +
                +'}';
    }

        // If we ever refactor this code to support chunked file upload, we'll need a couple of helper methods
    // that will create the temporary file content-holding Attachment (or other record type) that will buffer
    // up the file content until all of it has been uploaded to us. Then we'll need a method to actually
    // upload the file to zPaper once we have received it all.

}