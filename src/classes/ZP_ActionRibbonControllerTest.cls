/*********************************************************************************
Class Name      : ZP_ActionRibbonControllerTest
Description     : Unit tests for ZP_ActionRibbonController
Modification Log:
----------------------------------------------------------------------------------
Developer                   Date                   Description
-----------------------------------------------------------------------------------
Cory Newey                 02/23/2018              Creation
*********************************************************************************/
@isTest
public with sharing class ZP_ActionRibbonControllerTest {
    private static User adminUser;
    private static Opportunity opportunity;

    @isTest
    public static void testSetupActionIcons() {
        adminUser = ZP_Test_Setup.createUser(ZP_Test_Setup.SYS_ADMIN_PROFILE, 'tAdmin@nowhere.com', 'tadm');
        opportunity = ZP_Test_Setup.createOpportunity('testOpp');
        System.runAs(adminUser) {
            Test.startTest();

// Cutsom metadata that is defined in an org is always visible in tests - you can't create it in the test.
//            ZPAPER5__Document_Viewer_Action_Ribbon__mdt meta =
//                    new ZPAPER5__Document_Viewer_Action_Ribbon__mdt(ZPAPER5__ZP_Active__c=true,
//                            ZPAPER5__ZP_Component__c='componentName', ZPAPER5__ZP_Icon_Name__c='action:apex',
//                            ZPAPER5__ZP_Document_Record_Type__c='Account', ZPAPER5__ZP_Tooltip__c='help',
//                            ZPAPER5__ZP_Ordinal__c=1);
//            insert meta;
            List<ZP_ActionRibbonController.ActionIconsWrapper> wrappers = ZP_ActionRibbonController.setupActionIcons(opportunity.Id);
            System.assert(wrappers.size() > 0);
            Test.stopTest();
        }
    }
}