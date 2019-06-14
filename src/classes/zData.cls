public class zData {

       // @AuraEnabled
      //  public String news { get; set; }
        
        @AuraEnabled
        public String NewFaxPage { get; set; }
        
        @AuraEnabled
        public String Sent { get; set; }
        
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
    
    
    public class zUserDataList {
        @AuraEnabled
        public String Admin { get; set; }
        
        @AuraEnabled
        public String Triage { get; set; }
        
        @AuraEnabled
        public String Sign { get; set; }
        
    }
}