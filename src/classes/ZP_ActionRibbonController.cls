/*********************************************************************************
Class Name      : ZP_ActionRibbonController
Description     : Read the meta data to create action ribbon that contains icons that invoke
                  zPaper document functionality
Modification Log:
----------------------------------------------------------------------------------
Developer                   Date                   Description
-----------------------------------------------------------------------------------
Cory Newey                 02/21/2018              Creation
*********************************************************************************/
global class ZP_ActionRibbonController {
//    @AuraEnabled
//    public static PC_Document__c getDocDetails(Id docId) {
//        PC_Document__c selectedDoc = new PC_Document__c();
//        //FLS Check on PC_Document__c
//        List<String> fields = new List<String>{'Name', 'RecordTypeId'};
//        PC_Database.assertAccess(PC_Constants.getQualifiedAPIName('PC_Document__c'), PC_Database.Operation.Reading, fields);
//
//        selectedDoc = [SELECT Name, RecordType.DeveloperName FROM PC_Document__c WHERE ID =: docId];
//        return selectedDoc;
//    }

    @AuraEnabled
    global static LIST<ActionIconsWrapper> setupActionIcons(Id recId) {
        LIST<ActionIconsWrapper> actionIconsWrapper	= 	NEW LIST<ActionIconsWrapper>();

        try {
            System.debug('@@ recId = ' + recId);
            // Get record type from passed-in Id
            Schema.DescribeSObjectResult dr = recId.getSobjectType().getDescribe();
            LIST<ZPAPER5__Document_Viewer_Action_Ribbon__mdt> actionIconMetaData = NEW LIST<ZPAPER5__Document_Viewer_Action_Ribbon__mdt>();
            System.debug('@@ record type = ' + dr.getName());

            LIST<ZPAPER5__Document_Viewer_Action_Ribbon__mdt> actionIconMetaData_RecordType = [
                    SELECT ZPAPER5__ZP_Active__c, ZPAPER5__ZP_Component__c, ZPAPER5__ZP_Document_Record_Type__c, MasterLabel,
                            ZPAPER5__ZP_Icon_Name__c, ZPAPER5__ZP_Tooltip__c, ZPAPER5__ZP_Ordinal__c, ZPAPER5__ZP_Action__c
                    FROM ZPAPER5__Document_Viewer_Action_Ribbon__mdt
                    WHERE ZPAPER5__ZP_Active__c = :TRUE AND ZPAPER5__ZP_Document_Record_Type__c = :dr.getName()
                    ORDER BY ZPAPER5__ZP_Ordinal__c
            ];

            LIST<ZPAPER5__Document_Viewer_Action_Ribbon__mdt> actionIconMetaData_All = [
                    SELECT ZPAPER5__ZP_Active__c, ZPAPER5__ZP_Component__c, ZPAPER5__ZP_Document_Record_Type__c, MasterLabel,
                            ZPAPER5__ZP_Icon_Name__c, ZPAPER5__ZP_Tooltip__c, ZPAPER5__ZP_Ordinal__c, ZPAPER5__ZP_Action__c
                    FROM ZPAPER5__Document_Viewer_Action_Ribbon__mdt
                    WHERE ZPAPER5__ZP_Active__c = :TRUE AND
                    (ZPAPER5__ZP_Document_Record_Type__c = :'' OR ZPAPER5__ZP_Document_Record_Type__c = 'ALL')
                    ORDER BY ZPAPER5__ZP_Ordinal__c
            ];

            System.debug('@@@ Number of ALL action Icons = ' + actionIconMetaData_All.size());

            actionIconMetaData.addAll(actionIconMetaData_RecordType);
            actionIconMetaData.addAll(actionIconMetaData_All);

            FOR (ZPAPER5__Document_Viewer_Action_Ribbon__mdt a : actionIconMetaData) {
                actionIconsWrapper.add(new ActionIconsWrapper(a));
            }
        } catch (Exception e) {
            System.debug('@@@@ Exception building Icon List: ' + e);
        }
        System.debug('@@actionIconsWrapper :' + actionIconsWrapper);
        RETURN actionIconsWrapper;
    }

    /**
	* Wrapper for the action icons setup. Includes all information needed to initialize the
	* action icons.
	*/
    global class ActionIconsWrapper {
        @AuraEnabled public Boolean iconActive {get; set;}
        @AuraEnabled public String 	iconActionComponent {get; set;}
        @AuraEnabled public String 	iconActionComponentAndAction {get; set;}
        @AuraEnabled public String 	iconDocRecordType {get; set;}
        @AuraEnabled public String 	iconImage {get; set;}
        @AuraEnabled public String 	iconLabel {get; set;}
        @AuraEnabled public String 	iconAction {get; set;}
        @AuraEnabled public Decimal iconOrdinal {get; set;}
        @AuraEnabled public Boolean iconVisibility {get; set;}

        global ActionIconsWrapper() {}

        global ActionIconsWrapper(ZPAPER5__Document_Viewer_Action_Ribbon__mdt a) {
            iconActive 			= a.ZPAPER5__ZP_Active__c;
            iconActionComponent = a.ZPAPER5__ZP_Component__c;
            iconActionComponentAndAction = NULL != a.ZPAPER5__ZP_Action__c ?
                    a.ZPAPER5__ZP_Component__c + '::' + a.ZPAPER5__ZP_Action__c : a.ZPAPER5__ZP_Component__c;
            iconDocRecordType 	= a.ZPAPER5__ZP_Document_Record_Type__c;
            iconImage 			= a.ZPAPER5__ZP_Icon_Name__c;
            iconLabel 			= a.MasterLabel;
            iconAction 			= a.ZPAPER5__ZP_Action__c;
            iconOrdinal 		= a.ZPAPER5__ZP_Ordinal__c;
            iconVisibility 		= True;
        }
    }

}