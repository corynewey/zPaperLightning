public with sharing class ZP_DocumentGroupPermissionController {
    @AuraEnabled
    public static GroupListWrapper setupGroupList() {
        GroupListWrapper wrapper = null;
        List<ZPAPER5__ZP_Groups__mdt> zpGroupsMetaList = [SELECT ZPAPER5__Group_List__c FROM ZPAPER5__ZP_Groups__mdt];
        System.debug(zpGroupsMetaList.get(0));
        if (zpGroupsMetaList.size() > 0) {
            Schema.DescribeFieldResult result = ZPAPER5__ZP_Groups__mdt.ZPAPER5__Group_List__c.getDescribe();
            List<Schema.PicklistEntry> values = result.getPicklistValues();
            Map<String, String> groupMap = new Map<String, String>();
            for (Schema.PicklistEntry entry : values) {
                System.debug('Label = ' + entry.getLabel());
                System.debug('Value = ' + entry.getValue());
                groupMap.put(entry.getValue(), entry.getLabel());
            }
            wrapper = new GroupListWrapper();
            wrapper.groups = groupMap;
        }
        return wrapper;
    }

    @AuraEnabled
    public static void invokeModifyGroups(String dbID, String groups) {
        System.debug('@@@ dbID = ' + dbID + ', groups = ' + groups);
        String msgBuffer = '';
        ZP_RulesEngineEvent zpEvent = new ZP_RulesEngineEvent(dbID, ZP_Constants.RULES_ENGINE_BUTTON_ACTION, 'GROUPS_PERMISSION', null, null);
        zpEvent.addParameter('X_modifyGroupsPermission', groups);
        Type t = Type.forName('ZPAPER5', 'ZP_Utilities');
        System.debug('### ZP_Utilities Type = ' + t);
        msgBuffer += '### ZP_Utilities Type = ' + t + ' -- ';
        Object o = t.newInstance();
        System.debug('### zPaper Partner Object = ' + o);
        msgBuffer += '### zPaper Partner Object = ' + o + ' -- ';
        ((ZPAPER5.ZP_PartnerInterface.Partner) o).invoke(zpEvent);
    }

    /**
	* Wrapper for the action icons setup. Includes all information needed to initialize the
	* action icons.
	*/
    public class GroupListWrapper {
        @AuraEnabled
        public Map<String, String> groups { get; set; }
    }
}