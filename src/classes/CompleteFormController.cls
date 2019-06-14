/**
* @Author      : Prathyusha Vasireddy
* @Date        : 5/1/2017
* @Description : The CompleteFormController is using for zPaper API calls to get the Complete Form list for the associated record and this class will be used CompleteForm component.
* @Refered Lighting Component: CompleteForm
*
* Modification Log    :
* ------------------------------------------------------------------------------------------------
* Developer                			 Date                    Description
* ---------------           		-----------             ----------------------------------------------
* Prathyusha Vasireddy	             06/10/2017              Original Version
*/
public class CompleteFormController {
    /* Method : getzCompleteForms
	 * Parameters : CaseId (Current record Id)
	 * Return Type : zFormsResponse(Inner class)
     * Description : Doing zPaper server HTTP callous and constructing the response in Apex objects.
     */	
    @AuraEnabled
    public static zFormsResponse getzCompleteForms(Id caseid) {
	
	    // getting zPaper Server insatnce URL from Custom Setting
        ZPAPER__zpaper__c zpar = ZPAPER__zpaper__c.getInstance();
        //String apiURL = [select PartnerUrl__c from User where id=:userinfo.getUserId()].PartnerUrl__c;
        //String sId = [select SessionId__c from User where id=:userinfo.getUserId()].SessionId__c;
		
		// getting PartnerUrl__c, SessionId__c from User object
		User usr = [SELECT PartnerUrl__c, SessionId__c FROM User WHERE id=:userinfo.getUserId()];
		String apiURL = usr.PartnerUrl__c;
		String sId = usr.SessionId__c;
        
        zFormsResponse zFormres = new zFormsResponse();
        zFormres.LoggedInUser = UserInfo.getUserName(); 
        zFormres.zPaperBaseURL = 'https://'+zpar.ZPAPER__server__c;
        zFormres.recordId = caseid;
        zFormres.OrdId = UserInfo.getOrganizationId();
        zFormres.SFserver = apiUrl;
        zFormres.SFsession = sid;      
        
        String zURL = 'https://'+zpar.ZPAPER__server__c+'/kb/jsp/SF_formList.jsp?formType=_Form&rtnFormat=jsonp';
        zURL+= '&SFuser='+userinfo.getUserName()+'&';
        zURL+= '&SFserver='+apiUrl+'&SFsession='+sid;			
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(zURL);           
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);     
        zFormres.zforms = response.getBody();
        System.debug('......zFormres.....'+zFormres);
        return zFormRes;
    }
    
    /*
    @AuraEnabled
    public static List<CompleteForm__c> getPropertiesFromCustomSetting() {
        return [Select Id, Produce_Form__c, Send_Form__c, Print_Form__c, Section_1__c, Section_1_Filter__c,
                Section_2__c, Section_2_Filter__c, Section_3__c, Section_3_Filter__c From CompleteForm__c limit 1];
    }
	*/
	
	/* Inner Class : zFormsResponse
     * Description : To store the zFormsResponse (including radio button images and button forms  )
     */    
    public class zFormsResponse{
        @AuraEnabled
        public String LoggedInUser {get; set;}        
        @AuraEnabled
        public String zforms {get; set;}
        @AuraEnabled
        public String zPaperBaseURL {get; set;}
        @AuraEnabled
        public String recordId {get; set;}
        @AuraEnabled
        public String OrdId {get; set;}
        @AuraEnabled
        public String sfServer {get; set;}
        @AuraEnabled
        public String sfSession {get; set;}
    }  
}