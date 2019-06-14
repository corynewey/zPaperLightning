global class ZP_DocSplitterExerciserController {
    @AuraEnabled
    public static String splitDocument(String recordId) {
        String buffer = '';
        System.debug('@@@ recordId = ' + recordId);
        buffer += '@@@ recordId = ' + recordId + '\n';
        sObject curObj = NULL;
        String prefix = recordId.substring(0, 3);
        String sObjectType;
        Map<String, Schema.SObjectType> describe =  Schema.getGlobalDescribe();
        for (Schema.SObjectType stype : describe.values()) {
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String objPrefix = r.getKeyPrefix();
//            System.debug('Prefix is ' + objPrefix);
            //Check if the prefix matches with requested prefix
            if(NULL != objPrefix && objPrefix.equals(prefix)){
                sObjectType = r.getName();
                System.debug('Object Name! ' + sObjectType);
                buffer += 'Object Name = ' + sObjectType + '\n';
                break;
            }
        }

//        List<Case> cases = [SELECT ZPAPER__receivedId__c FROM Case WHERE Id = :recordId];
        String query = 'SELECT ZPAPER__receivedId__c FROM ' + sObjectType + ' WHERE Id = \'' + recordId + '\'';
        System.debug('@@@ Making SOQL query: ' + query);
        buffer += '@@@ Making SOQL query: ' + query + '\n';
        List<sObject> sobjs = Database.query(query);
        System.debug('@@@ After query, number of results = ' + sobjs.size());
        buffer += '@@@ After query, number of results = ' + sobjs.size() + '\n';
        if (sobjs.size() > 0) {
            curObj = sobjs.get(0);
            System.debug('### Returned sObject: ' + curObj);
            buffer += '### Returned sObject: ' + curObj + '\n';
        }
        try {
//            String dbId = curObj.ZPAPER__receivedId__c;
            String dbId = (String)curObj.get('ZPAPER__receivedId__c');
            System.debug('@@@ dbId = ' + dbId);
            buffer += '@@@ dbId = ' + dbId + '\n';
            Type t = Type.forName('ZPAPER5', 'ZP_Utilities');
            System.debug('### ZP_Utilities Type = ' + t);
            buffer += '### ZP_Utilities Type = ' + t + '\n';
            Object o = t.newInstance();
            System.debug('### zPaper Partner Object = ' + o);
            buffer += '### zPaper Partner Object = ' + o + '\n';
            ((ZPAPER5.ZP_PartnerInterface.Partner) o).split(dbiD, 'Id', recordId);
        }
        catch (Exception e) {
            System.debug(e);
            System.debug('$$$$$ Exception calling split in Partner Interface: ' + e.getMessage());
            buffer += '$$$$$ Exception calling split in Partner Interface: ' + e.getMessage() + '\n';
        }
        return buffer;
    }
}