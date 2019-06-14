/**
 * Created by User on 9/4/2018.
 */

global class ZP_FileUploadContainerController {
    @AuraEnabled
    global static String getForceDotComHost() {
        //CRN180904 This is really ugly - I'd much rather use URL.getSalesforceBaseUrl().toExternalForm()
        // but that doesn't give us the correct instance host when the component is being used in a
        // Communities page.
        System.debug('@@@@ Pulling ZPAPER5__SFDC_Instance_Host2__c @@@@');
        System.debug('@@@@ Is Base URL host correct? ' + URL.getSalesforceBaseUrl().toExternalForm());
        LIST<ZPAPER5__ZP_FileUploadSettings__mdt> uploadSettings =
        [SELECT ZPAPER5__SFDC_Instance_Host2__c FROM ZPAPER5__ZP_FileUploadSettings__mdt WHERE DeveloperName = 'ZP_Base_Settings' ];
        System.debug('@@@ Upload Settings List = ' + uploadSettings);
        if (uploadSettings.size() > 0) {
            System.debug('@@@@ Pulling ZPAPER5__SFDC_Instance_Host2__c: ' + uploadSettings[0].ZPAPER5__SFDC_Instance_Host2__c);
            return uploadSettings[0].ZPAPER5__SFDC_Instance_Host2__c;
        }
        return 'ERROR_ZP_FileUploadSettings_not_configured';
    }

    @AuraEnabled
    global static String fetchUser(){
        return userInfo.getUserName();
    }

    @AuraEnabled
    global static List<Map<String,String>> getPicklistEntries(String picklistName) {
        List<Map<String,String>> items = new List<Map<String,String>>();

        // The picklist Name must include the SObject name separated with a dot.
        if (picklistName.indexOf('.') > 0) {
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
}