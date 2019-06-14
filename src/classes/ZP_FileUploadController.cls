global class ZP_FileUploadController {
    private static final String BOUNDARY = '----sfdc-multi-form';
    private static final String FOOTER_TEMPLATE = '\r\n------sfdc-multi-form--';
    private static final String HEADER_FORM_TEMPLATE = '------sfdc-multi-form\r\nContent-Disposition: form-data; name="{0}"\r\n';
    private static final String HEADER_FILE_TEMPLATE = '------sfdc-multi-form\r\nContent-Disposition: form-data; name="{0}"; filename="{1}";\r\nContent-Type: {2}\r\n';
    global transient Attachment objAttachment;

    //Use getter so we can make attachment transient
    global Attachment getObjAttachment() {
        objAttachment = new Attachment();
        return objAttachment;
    }
    global String propSelected { get; set; }
    global String template { get; set; }

    global Boolean fileUploadProcessed { get; set; }
    global String message { get; set; }
    global String messageType { get; set; }

    global void uploadFile() {
        try {
/*
            <form method="post" id="issueForm2017" name="issueForm2017" target="zReport"
                    enctype="multipart/form-data" action="/kb/jsp/upload.jsp">
              <input type=hidden name=JS value="w.location=(^/kb/jsp/markup.jsp?dbID=$ID$^)">
              <INPUT TYPE=hidden NAME=zPaper VALUE="1220">
              <INPUT TYPE=hidden NAME=dbAction VALUE="insert">
              <input type=hidden name=dbTablename value="Snippet">
              <input type=hidden name=dbID value="NEW" value0="=dbID" id=dbID>
              <input type=hidden name=dbAfterInsertOrDelete id=dbAfterInsertOrDelete value="">
              <input type=hidden name=mode value="JS">
              <input type=hidden name="db-type" id="db-type" value=File>
              <input type=hidden name="db-readers" id="db-readers" value=":-10:<%=kbData.groupID%>:">
              <input type=hidden name="db-users" id="db-users" value=":-10:<%=kbData.groupID%>:">
              <input type=hidden name="db-type" id="db-type" value=File>

*/
//            objAttachment.ParentId = (Id) ApexPages.currentPage().getParameters().get('id');
//
//            insert objAttachment;
            System.debug('@@ name of uploaded file: ' + objAttachment.Name);
            System.debug('@@ uploaded file: ' + objAttachment.Body);
            System.debug('@@ size of uploaded file: ' + objAttachment.BodyLength);
            System.debug('@@ content type of uploaded file: ' + objAttachment.ContentType);
            System.debug('@@ propSelected: ' + propSelected);

//            String uploadFileName = 'community_communityUpload_PROP[' + propSelected + '] ' + objAttachment.Name.replace('_', ' ').replace('-', ' ');
            String uploadFileName = template + objAttachment.Name.replace('_', ' ').replace('-', ' ');
            System.debug('@@ uploadFileName: ' + uploadFileName);
            String userName = UserInfo.getUserName();
            String orgId = UserInfo.getOrganizationId();
            String sfServer = Url.getSalesforceBaseUrl().getHost();

            // Call upload.jsp (ToDo: do we need to worry about authentication?
            String form64 = HttpMultipartFormBuilder.writeBoundary();
//            form64 += HttpMultipartFormBuilder.writeBodyParameter('uploadDir' , 'communityUpload');
            form64 += HttpMultipartFormBuilder.writeBodyParameter('uploadDir' , 'lightningUpload');
            form64 += HttpMultipartFormBuilder.writeBoundary();
            HttpMultipartFormBuilder.WriteFileResult result =
                    HttpMultipartFormBuilder.writeFile('file',
                            uploadFileName,
                            objAttachment.ContentType,
                            objAttachment.Body);
            form64 += result.Content;
            form64 += HttpMultipartFormBuilder.writeBoundary(result.EndingType);
            Blob formBlob = EncodingUtil.base64Decode(form64);
            String contentLength = formBlob.size() + '';

            System.debug('Form body length = ' + contentLength);
            LIST<ZPAPER5__ZP_Partner_Setting__mdt> partnerSettings =
            [SELECT ZPAPER5__Partner_API_Host__c,DeveloperName,MasterLabel FROM ZPAPER5__ZP_Partner_Setting__mdt WHERE DeveloperName = 'ZP_General_Settings' ];
            System.debug('@@@ Partner Settings List = ' + partnerSettings);
            String zpServer = '';
            if (partnerSettings.size() > 0) {
                System.debug('### Settings[0]: Api Host = ' + partnerSettings[0].ZPAPER5__Partner_API_Host__c);
                System.debug('### Settings[0]: Name = ' + partnerSettings[0].DeveloperName);
                System.debug('### Settings[0]: Label = ' + partnerSettings[0].MasterLabel);
                System.debug('@@@ Setting api host from General Settings: ' + partnerSettings[0].ZPAPER5__Partner_API_Host__c);
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
            req.setHeader('Content-Length', contentLength);
            req.setHeader('Content-Type', HttpMultipartFormBuilder.getContentType());
            Http h = new Http();
            HttpResponse response = h.send(req);

            if (200 == response.getStatusCode()) {
                message = 'File was uploaded successfully';
                messageType = 'confirm';
            }
            else {
                message = 'Error uploading file: ' + response.getStatus();
                messageType = 'error';
            }
        } catch (Exception e) {
            message = e.getMessage();
            messageType = 'error';
        }
        fileUploadProcessed = true;
    }
}