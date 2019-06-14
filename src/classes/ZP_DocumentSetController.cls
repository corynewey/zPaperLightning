/**
* @Author      : Prathyusha Vasireddy
* @Date        : 04/21/2017
* @Description : The ZP_DocumentSetController is cloned from zDocumentSetCaseController and is used
* for zPaper API calls to get the Documents list for the associated record and this class will be
* used ZP_DocumentSet component.
* @Lighting Component: ZP_DocumentSet
*
* Modification Logs    :
* -------------------------------------------------------------------------------------
* Developer                			 Date                    Description
* ---------------           		-----------             ---------------------------
* Prathyusha Vasireddy	            04/03/2018              Original Version
*/

public class ZP_DocumentSetController {

    /* Method : getZPaperDocs
	 * Parameters : CaseId, designLayoutId
	 * Return Type : zPaperFilesResponse(Inner class)
     * Description : Doing zPaper server HTTP callous and constructing the response in Apex objects.
     */

    @AuraEnabled
    public static zPaperFilesResponse getZPaperDocs(Id recordId, String designLayoutName, String zSearchURL) {
        zPaperFilesResponse zPaper = null;
        String designLayoutId;
        String rawResponse = 'EMPTY';
        string jsResponse = 'EMPTY';
        String endPoint = 'EMPTY';

        String debugString = '';
        debugString += '*** in zDocumentSetCaseController ***\n';
        debugString += '.....RecordId......'+recordId + '\n';
        debugString += '.....designLayoutName......'+designLayoutName + '\n';
        
        try {
            if(designLayoutName != null){
                for(ZDocument_DesignLayout__c designLayout : [SELECT id FROM ZDocument_DesignLayout__c WHERE Name = :designLayoutName LIMIT 1]){
                    designLayoutId = designLayout.id;
                }
            }
            if(designLayoutId == null || designLayoutId == ''){
                for(ZDocument_DesignLayout__c designLayout : [SELECT id FROM ZDocument_DesignLayout__c WHERE Name LIKE '%Default%' LIMIT 1]){
                    designLayoutId = designLayout.id;
                }
            }
            debugString += '.....designLayoutId......'+designLayoutId + '\n';
            // getting zPaper Server insatnce URL from Custom Setting
            ZPAPER__zpaper__c zpar = ZPAPER__zpaper__c.getInstance();

            // getting PartnerUrl__c, SessionId__c from User object
            User usr = [SELECT PartnerUrl__c, SessionId__c FROM User WHERE id=:userinfo.getUserId()];
            String apiURL = usr.PartnerUrl__c;
            String sId = UserInfo.getSessionId();
//            debugString += '$$$$$$$$$$$$$$$$$$$ Trying to pull API Session $$$$$$$$$$$$$$$$$$$$$$');
//			String sId = ZUtilities.getApiSessionId(usr.SessionId__c);
            debugString += '####> Lightning Session: ' + user.SessionId__c + '\n';
//            debugString += '####> API Session: ' + sId);

            // Making a HTTP callout
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            endPoint = zpar.ZPAPER__server__c + '/kb/jsp/tableXMLSearch.jsp?SFuser=' +
                    EncodingUtil.urlEncode(userinfo.getUserName(), 'UTF-8') +
                    '&sfIds=' + recordId +
                    '&mode=' + EncodingUtil.urlEncode('JSON&fields=label,ID,BATES,View,created,modified,modifiedBy,X_reviewedStatus,X_docType,X_reviews&BATESq=X_attachedTo%20like%20^*SFID*^','UTF-8') +
                    '&SFserver=' + EncodingUtil.urlEncode(apiUrl, 'UTF-8') + '&SFsession=' + EncodingUtil.urlEncode(sId, 'UTF-8');
            if (null != zSearchURL && zSearchURL.length() > 0) {
                // https://{ZP_SERVER}/kb/jsp/tableXMLSearch.jsp?SFuser={SF_USERNAME}&sfIds={SF_IDLIST}&mode=JSON&fields=label,ID,BATES,View,created,modified,modifiedBy,X_reviewedStatus,X_docType,X_reviews&BATESq=X_attachedTo%20like%20^*SFID*^&SFserver={SF_SERVER}&SFsession={SF_SESSION}
                endPoint = zSearchURL.replace('{ZP_SERVER}', zpar.ZPAPER__server__c)
//                endPoint = zSearchURL.replace('{ZP_SERVER}', 'api.zpaper.com')
                        .replace('{SF_USERNAME}', EncodingUtil.urlEncode(userinfo.getUserName(), 'UTF-8'))
                        .replace('{SF_IDLIST}', EncodingUtil.urlEncode(recordId, 'UTF-8'))
                        .replace('{SF_SERVER}', EncodingUtil.urlEncode(apiUrl, 'UTF-8'))
                        .replace('{SF_SESSION}', EncodingUtil.urlEncode(sId, 'UTF-8'));
            }
            debugString += '@@@@ zPaper server call: ' + endPoint;
            debugString += '@@@@ zSearchURL = ' + zSearchURL + '\n';
            endPoint += '&zPaper=1220';
            request.setEndpoint(endPoint);
//            request.setEndpoint('callout:zPaper_tableXMLSearch');

            request.setMethod('GET');
            debugString += '****zDocSet request****'+request + '\n';
            HttpResponse response = http.send(request);

            debugString += 'Response Status Code: ' + response.getStatusCode() + '\n';
            if (response.getStatusCode() > 300 && response.getStatusCode() <= 308) {
                //CRN180109 OAuth2 redirect.
                String location = response.getHeader('Location');
                debugString += '@@@ Redirect location: ' + location + '\n';
                request = new HttpRequest();
                request.setEndpoint(location);
                request.setMethod('GET');
                response = http.send(request);
                debugString += '@@@ After redirect, status code: ' + response.getStatusCode() + '\n';
                debugString += '@@@ After redirect, response body: ' + response.getBody() + '\n';
                if (response.getStatusCode() > 300 && response.getStatusCode() <= 308) {
                    location = response.getHeader('Location');
                    debugString += '@@@ Final Redirect location: ' + location + '\n';
                    request = new HttpRequest();
                    request.setEndpoint(location);
                    request.setMethod('GET');
                    response = http.send(request);
                    debugString += '@@@ After redirect, status code: ' + response.getStatusCode() + '\n';
                }
            }

            rawResponse = response.getBody();
            jsResponse = response.getBody().replace('var zFiles=','');
            jsResponse = jsResponse.replace('&nbsp;',' ');		//CRN170622 - &nbsp; isn't valid when parsing json
            jsResponse = jsResponse.replace('\n',' ');		//CRN170622 - &nbsp; isn't valid when parsing json
            jsResponse = jsResponse.replace('\r',' ');		//CRN170622 - &nbsp; isn't valid when parsing json
//            jsResponse = jsResponse.replace('<','&lt;');		//CRN170622 - < isn't valid when parsing json in Salesforce
//            jsResponse = jsResponse.replace('>','&gt;');		//CRN170622 - < isn't valid when parsing json in Salesforce

            debugString += '***zDocumentSetCaseController***jsResponse*****'+jsResponse  + '\n';

            zPaper = (zPaperFilesResponse) JSON.deserialize(jsResponse, zPaperFilesResponse.class);
            zPaper.rawResponse = rawResponse;
            zPaper.jsonResponse = jsResponse;
            zPaper.zPaperRequest = endPoint;

            String thisType = 'Case:500';
            String[] crmTypesLst = zPaper.crmTypes.split(',');


            // Collecting CRM Types and Doc Types
            for (Integer k=0; k<crmTypesLst.size(); k++) {
                if (crmTypesLst[k].indexOf(':'+zPaper.sfId.substring(0,3))!=-1)
                    thisType=crmTypesLst[k].replace('ZPAPER3','').replace('__c','').replace('__','');
            }
            thisType = thisType.substring(0,thisType.indexOf(':'));

            String[] allTypes = zPaper.docTypes.split(',');
            String DocTypes='';
            for (Integer j=0; j<allTypes.size(); j++) {
                String[] parts= allTypes[j].split(':');
                if (parts[0]==thisType || parts[0]==(thisType+'__c')) {
                    string req='';
                    if(parts[2].indexOf('*')>-1)
                        req='*';
                    DocTypes+=parts[1]+req+',';
                }
            }

            zPaper.lstCrmTypes = new List<String>();
            // Modified by Pra.V after Beta 1 release. List --> Set
            zPaper.lstDocTypesNew = new Set<String>();
            zPaper.lstDocTypesOld = new Set<String>();
            zPaper.zDocStatusOld = new Set<String>();
            zPaper.zDocStatusNew = new Set<String>();

            zPaper.lstCrmTypes = crmTypesLst;

            // Collecting Custom View links from designLayout
            for(ZDocument_DesignLayout__c designLayout : [SELECT ZPAPER5__Documents_ViewLink_Name__c,
                                                                 ZPAPER5__Documents_ViewLink_URL__c,
                                                                 ZPAPER5__Suppress_Blank_Entries__c
                FROM ZDocument_DesignLayout__c WHERE id =: designLayoutId]){
                zPaper.customViewLinkName = designLayout.ZPAPER5__Documents_ViewLink_Name__c;
                zPaper.customViewLinkURL = designLayout.ZPAPER5__Documents_ViewLink_URL__c;
                zPaper.suppressBlankEntries = designLayout.ZPAPER5__Suppress_Blank_Entries__c;
            }
            //CRN180409 Case #46137 Pull any action buttons
            List<ZPAPER5__zPaper_Document_Set_Action__c> actions =
                [SELECT ZPAPER5__Button_Event_Name__c, ZPAPER5__Column_Location__c, ZPAPER5__Label__c, ZPAPER5__Component__c, ZPAPER5__Visible_In_Stages__c
                FROM ZPAPER5__zPaper_Document_Set_Action__c WHERE ZPAPER5__zDocument_Design_Layout__c = :designLayoutId];
            Set<zActionButton> actionButtons = new Set<zActionButton>();
            debugString += '@@@ Number of action buttons found = ' + actions.size() + '\n';
            zPaper.zActionButtons = actionButtons;
            for (zPaper_Document_Set_Action__c action : actions) {
                actionButtons.add(new zActionButton(
                        action.ZPAPER5__Label__c,
                        action.ZPAPER5__Button_Event_Name__c,
                        action.ZPAPER5__Column_Location__c,
                        action.ZPAPER5__Component__c,
                        action.ZPAPER5__Visible_In_Stages__c));
            }
            debugString += '### Number of action buttons added to return obj: ' + zPaper.zActionButtons.size() + '\n';
            zPaper.orgId = UserInfo.getOrganizationId();

            // Collecting User defined Document statues from zDocumentSetup /designLayout
            for(ZDocument_Setup__c zSetup : [Select Id, Name,ActualColumn_Name__c, IsRequired__c From ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Columns' AND ZDocument_DesignLayout__c =: designLayoutId ORDER BY Sort_Order__c]){
                if(zSetup.IsRequired__c){
                    zPaper.zDocStatusOld.add(zSetup.ActualColumn_Name__c);
                    zPaper.zDocStatusNew.add(zSetup.Name);
                }
            }
            /* Commnted by Pra.V after 8/8/17 Meeting with Eric, to get below columns as dynamic from Properties Page

             // Added by Pra.V after Beta 1 release. To adding default Columns
              if(!zPaper.zDocStatusOld.contains('Type')){
                 zPaper.zDocStatusOld.add('Type');
                 zPaper.zDocStatusNew.add('Type');
              }
             if(!zPaper.zDocStatusOld.contains('Updated Date')){
                 zPaper.zDocStatusOld.add('Updated Date');
                 zPaper.zDocStatusNew.add('Updated Date');
              }
             if(!zPaper.zDocStatusOld.contains('Form')){
                 zPaper.zDocStatusOld.add('Form');
                 zPaper.zDocStatusNew.add('Form');
              }
             */

            // Collecting User defined Document Types from zDocumentSetup /designLayout
            zPaper.lstDocTypesOld.addAll(DocTypes.split(','));  //new String[]{'HDOT','3500','DATA','DOSE','ENRLC','PIRM*','REFR'};

            for(ZDocument_Setup__c zSetup : [Select Id, Name, Referred_DocType__c, IsRequired__c From ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Types' AND ZDocument_DesignLayout__c =: designLayoutId ORDER BY Sort_Order__c]){
                if(zSetup.IsRequired__c){
                    //CRN190122 Case #53000 - Make sure we only work with the acronym since that is what will be stored in the wddata for the file.
                    String name = zSetup.Name;
                    Integer idxColon = name.indexOf(':');
                    if (idxColon >= 0) {
                        name = name.substring(0, idxColon);
                    }
                    zPaper.lstDocTypesNew.add(name);
                }
            }
            Set<String> tempDocTypes = new Set<String>();
            tempDocTypes.addAll(zPaper.lstDocTypesNew);
            // Added by Pra.V after Beta 1 release. For adding additional DocTypes from Files
            // Collecting Documents and storing in zFile
            debugString += '@@@ Number of files pulled down: ' + zPaper.files.size() + '\n';
            for(zFile file: zPaper.files){
                debugString += '@@@@ We have a file: label=' + file.label + ', X_docType=*' + file.X_docType + '*\n';
                file.X_ReviewsMap = new Map<String, String>();
                file.X_Reviews = file.X_Reviews.replace('<br/>', '<br>');
                if (file.X_Reviews.contains('<br>')) {		//CRN170622 Handle case when reviews doesn't contain <br>
                    for(String str: file.X_Reviews.split('<br>')){
                        String val = str.replace('<br>','').trim();
                        debugString += '@@@ X_reviews str = ' + str + '\n';
                        Integer idxEnd = str.indexOf(' by ');
                        if (idxEnd < 0) { idxEnd = str.indexOf(' at '); }      //CRN190122 Case #53000 - handle X_reviews that don't contain 'by'
                        if (idxEnd < 0) { idxEnd = str.indexOf(' '); }          //CRN190122 Case #53000 - handle X_reviews that don't contain 'at'
                        debugString += '@@@ idxEnd = ' + idxEnd + '\n';
                        if (idxEnd >= 0) {
                            String key = str.substring(0, idxEnd).trim();
                            if (key.length() > 0 && key != 'ed') {     //CRN180103 Don't let crappy data break the display
                                file.X_ReviewsMap.put(key, val);
                            }
                        }
                    }
                }
                debugString += '@@@@ Does tempDocTypes contain X_docType (' + file.X_docType.replace('*','') + ') ? ' +
                        (tempDocTypes.contains(file.X_docType.replace('*',''))) + '\n';
                debugString += '@@@ Before adding file doctype, Size of lstDocTypesNew = ' + zPaper.lstDocTypesNew.size() + '\n';
                // Added by Pra.V after Beta 1 release. For adding additional DocTypes from Files
                if(file.X_docType != '' && !tempDocTypes.contains(file.X_docType.replace('*',''))){
                    zPaper.lstDocTypesNew.add(file.X_docType);
                    zPaper.lstDocTypesOld.add(file.X_docType);
                }
                debugString += '@@@ AFTER adding file doctype, Size of lstDocTypesNew = ' + zPaper.lstDocTypesNew.size() + '\n';

                String view  = file.View;
                file.View = view.substring((view.indexOf('https')>0?view.indexOf('https'):0),
                        (view.indexOf('\'>View</a>')>0?view.indexOf('\'>View</a>'):view.length())).trim();
            }
            debugString += '***zDocumentSetCaseController****getZPaperDocs***Result**'+zPaper + '\n';
        } catch(Exception e){
            debugString += '******Exception**in**zDocumentSetCaseController***Message***'+e.getMessage() + '\n';
            debugString += '******Exception**in**zDocumentSetCaseController***LineNumber***'+e.getLineNumber() + '\n';
            if (null == zPaper) {
                zPaper = new zPaperFilesResponse();
            }
            zPaper.rawResponse = rawResponse;
            zPaper.jsonResponse = jsResponse;
            zPaper.zPaperRequest = endPoint;

        }
        zPaper.debugString = debugString;
        return zPaper;
    }

    /* Inner Class : zPaperFilesResponse
     * Description : To store all the response data. Like: CRM Types, Doc Types, Doc Statues and Custom links etc..
     */
    public class zPaperFilesResponse{
        public String sfId {get; set;}
        public String crmTypes {get; set;}
        public String docTypes {get; set;}
        public String docStates {get; set;}
        @AuraEnabled
        public String zPaperRequest {get; set;}
        @AuraEnabled
        public String rawResponse {get; set;}
        @AuraEnabled
        public String jsonResponse {get; set;}
        @AuraEnabled
        public String orgId {get; set;}
        @AuraEnabled
        public String customViewLinkName {get; set;}
        @AuraEnabled
        public String customViewLinkURL {get; set;}
        @AuraEnabled
        public Boolean suppressBlankEntries {get; set;}
        @AuraEnabled
        public List<zFile> files {get; set;}
        @AuraEnabled
        public List<String> lstCrmTypes {get; set;}
        @AuraEnabled
        public Set<String> lstDocTypesNew {get; set;}
        @AuraEnabled
        public Set<String> lstDocTypesOld {get; set;}
        @AuraEnabled
        public Set<String> zDocStatusOld {get; set;}
        @AuraEnabled
        public Set<String> zDocStatusNew {get; set;}
        @AuraEnabled
        public Set<zActionButton> zActionButtons {set; get;}
        @AuraEnabled
        public String debugString {get; set;}
    }

    /**
     * CRN180409 Encapsulate the Action buttons data
     */
    public class zActionButton {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String component {get; set;}
        @AuraEnabled
        public String eventName {get; set;}
        @AuraEnabled
        public String colLocation {get; set;}
        @AuraEnabled
        public String visibleInStages {get; set;}
        public zActionButton(String label, String eventName, String colLocation, String component, String visibleInStages) {
            this.label = label;
            this.component = component;
            this.eventName = eventName;
            this.colLocation = colLocation;
            this.visibleInStages = visibleInStages;
        }
    }

    /* Inner Class : zFile
     * Description : To store the each DocType Files
     */
    public class zFile{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String ID {get; set;}
        @AuraEnabled
        public String BATES {get; set;}
        @AuraEnabled
        public String View {get; set;}
        @AuraEnabled
        public String created {get; set;}
        @AuraEnabled
        public String modified {get; set;}
        @AuraEnabled
        public String modifiedBy {get; set;}
        @AuraEnabled
        public String X_reviewedStatus {get; set;}
        @AuraEnabled
        public String X_docType {get; set;}
        @AuraEnabled
        public String X_Reviews {get; set;}
        @AuraEnabled
        public Map<String, String> X_ReviewsMap {get; set;}
    }
}