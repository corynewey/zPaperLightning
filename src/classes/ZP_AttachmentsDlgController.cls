global with sharing class ZP_AttachmentsDlgController {
    @RemoteAction
    global static List<Folder> getFolderList() {
        return [select Id,Name from Folder where Name like '%' order by Name];    // pull all folders
    }

    @RemoteAction
    global static List<Document> getFilesInFolder(String Id) {
        return [select Id,Name,Type from Document where FolderId = :Id];
    }

    @RemoteAction
    global static List<Attachment> getAttachmentList(String Id) {
        return [Select Id,Name,CreatedDate From Attachment WHERE  ParentId = :Id Order By CreatedDate DESC LIMIT 250];
    }

    @RemoteAction
    global static String getZPaperAttachmentList(String recordId) {
        String srchURL = 'https://{ZP_SERVER}/kb/jsp/tableXMLSearch.jsp?SFuser={SF_USERNAME}' +
                '&sfIds={SF_IDLIST}&mode=JSON&fields=label,ID,BATES' +
                '&BATESq=X_attachedTo%20like%20^*SFID*^&SFserver={SF_SERVER}&SFsession={SF_SESSION}';
        // getting zPaper Server insatnce URL from Custom Setting
        ZPAPER__zpaper__c zpar = ZPAPER__zpaper__c.getInstance();
        // getting PartnerUrl__c, SessionId__c from User object
        User usr = [SELECT PartnerUrl__c, SessionId__c FROM User WHERE id=:userinfo.getUserId()];
        String apiURL = usr.PartnerUrl__c;
        String sId = UserInfo.getSessionId();

        String endPoint = srchURL.replace('{ZP_SERVER}', zpar.ZPAPER__server__c)
                .replace('{SF_USERNAME}', UserInfo.getUserName())
                .replace('{SF_IDLIST}', recordId)
                .replace('{SF_SERVER}', apiUrl)
                .replace('{SF_SESSION}', sId);
        endPoint += '&zPaper=1220';
        // Making an HTTP callout
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
//            request.setEndpoint('callout:zPaper_tableXMLSearch');

        request.setMethod('GET');
        system.debug('****zDocSet request****'+request);
        HttpResponse response = http.send(request);

        System.debug('Response Status Code: ' + response.getStatusCode());
        if (response.getStatusCode() > 300 && response.getStatusCode() <= 308) {
            //CRN180109 OAuth2 redirect.
            String location = response.getHeader('Location');
            System.debug('@@@ Redirect location: ' + location);
            request = new HttpRequest();
            request.setEndpoint(location);
            request.setMethod('GET');
            response = http.send(request);
            System.debug('@@@ After redirect, status code: ' + response.getStatusCode());
            System.debug('@@@ After redirect, response body: ' + response.getBody());
            if (response.getStatusCode() > 300 && response.getStatusCode() <= 308) {
                location = response.getHeader('Location');
                System.debug('@@@ Final Redirect location: ' + location);
                request = new HttpRequest();
                request.setEndpoint(location);
                request.setMethod('GET');
                response = http.send(request);
                System.debug('@@@ After redirect, status code: ' + response.getStatusCode());
            }
        }

        String rawResponse = response.getBody();
        String jsResponse = response.getBody().replace('var zFiles=','');
        jsResponse = jsResponse.replace('&nbsp;',' ');		//CRN170622 - &nbsp; isn't valid when parsing json
        jsResponse = jsResponse.replace('&quot;','"');		//CRN170622 - &nbsp; isn't valid when parsing json
        jsResponse = jsResponse.replace('\n',' ');		//CRN170622 - &nbsp; isn't valid when parsing json
        jsResponse = jsResponse.replace('\r',' ');		//CRN170622 - &nbsp; isn't valid when parsing json
        System.debug('zPaper response = ' + jsResponse);
        return EncodingUtil.urlDecode(jsResponse, 'UTF-8');
//        return '{}';
    }
}