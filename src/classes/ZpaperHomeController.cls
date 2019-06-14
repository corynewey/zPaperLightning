/**
*	Description		:	Home page component having zPaper API calls this class will be used ZpaperLightnigHome component.
*	Created Date 	:	04/19/2017
*	Created By		:	A.T.
*	Version			:	V1.0
**/
public class ZpaperHomeController {
    
     @AuraEnabled
    public static Map<String, String> sendADocController(String accountId) {
     	
        Map<String, String> data = new Map<String, String>();
		User usr = [Select Id, Username, PartnerUrl__c, SessionId__c From User where id=:userinfo.getUserId()];
        ZpaperConfig__c config = [Select Id, PartnerUrl__c, SessionId__c From ZpaperConfig__c];
        
        data.put('PartnerUrl', config.PartnerUrl__c);
        data.put('sessionId', config.SessionId__c);        
        data.put('userName', usr.Username);
        data.put('orgId', UserInfo.getOrganizationId());
        data.put('accountId', accountId);
        return data;
    }
    
    //*************** for API CALLS 
    @AuraEnabled
    public static zData service() {
     	
        zData zDataResponse;
        Contact cont = [Select Id From Contact Limit 1];         
        
        //get partner url
        String PartnerUrl = [select PartnerUrl__c from User where id=:userinfo.getUserId()].PartnerUrl__c;
		String sessionId = [select SessionId__c from User where id=:userinfo.getUserId()].SessionId__c;
        ZPAPER__zpaper__c zpaper = ZPAPER__zpaper__c.getInstance();
        String zServer = zpaper.ZPAPER__server__c;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
      
        request.setEndpoint('https://zp20.zpaper.com/kb/jsp/homeData.jsp?SFuser='+ userinfo.getUserName() 
                            +'&sfIds='+cont.Id+',00Q1a000001woiE&mode=JSON&'
        		            +'SFserver='+PartnerUrl+'&SFsession='+ sessionId);
        
        System.debug('URL:::: ' + 'https://zp20.zpaper.com/kb/jsp/homeData.jsp?SFuser='+ userinfo.getUserName() 
                            +'&sfIds='+cont.Id+',00Q1a000001woiE&mode=JSON&'
        		            +'SFserver='+PartnerUrl+'&SFsession='+ sessionId);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);

        string jsResponse = response.getBody().replace('zData =','');  
        System.debug('jsResponse:::::::::' + jsResponse);
        
        zDataResponse = (zData) JSON.deserialize(jsResponse, zData.class);
        System.debug('zData:::::::::' + zDataResponse);
        
       	return zDataResponse;
    }
    
    public class zData {

       // @AuraEnabled
      //  public String znew { get; set; 
      	@AuraEnabled
        public Integer Received { get; set; } //ERS170520
        
        @AuraEnabled
        public Integer NewFaxPage { get; set; }
        
        @AuraEnabled
        public Integer Sent { get; set; }
        
        @AuraEnabled
        public String SentFaxPage { get; set; }
        
        @AuraEnabled
        public String zStatus { get; set; }
        
        @AuraEnabled
        public String zFax { get; set; }
        
        @AuraEnabled
        public String zClock { get; set; }
        
        @AuraEnabled
        public zUserDataList zUserData { get; set; }
    }
    
    public class zUserDataList {
        @AuraEnabled
        public String Admin { get; set; }
        
        @AuraEnabled
        public String Triage { get; set; }
        
        @AuraEnabled
        public String Sign { get; set; }   
    }
}