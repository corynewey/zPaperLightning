/*******************************************************************************************
* @Author      : Vikas Reddy
* @Date        : 8/29/2017
* @Description : The zLDSDocumentSetController_Test is used for UnitTesting and code-coverage the zLDSDocumentSetController class.
* @Apex Class  : zLDSDocumentSetController
*
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer               Date                    Description
* ---------------        ----------             -------------------------
* Vikas Reddy            08/29/2017               Original Version
*********************************************************************************************/

@isTest
private class zLDSDocumentSetController_Test {
   @isTest
   static void TestUnitTest(){
        ZDocument_DesignLayout__c design = new ZDocument_DesignLayout__c(Name = 'Case Layout');
        Insert design;

        List<ZDocument_Setup__c> zDocSetList = new List<ZDocument_Setup__c>();        
        Id RTId = Schema.SObjectType.ZDocument_Setup__c.getRecordTypeInfosByName().get('zDocument Columns').getRecordTypeId();
                
        ZDocument_Setup__c setup1 = new ZDocument_Setup__c();
        setup1.Name = 'Indexed';
        setup1.RecordTypeId = RTId;
        setup1.ZDocument_DesignLayout__c = design.id;
        setup1.Referred_Column__c = 'Indexed';
        setup1.Sort_Order__c = 1;
        setup1.IsRequired__c = true;        
        zDocSetList.add(setup1);
        
        ZDocument_Setup__c setup2 = new ZDocument_Setup__c();
        setup2.Name = 'Updated';
        setup2.RecordTypeId = RTId;
        setup2.ZDocument_DesignLayout__c = design.id;
        setup2.Referred_Column__c = 'Updated';
        setup2.Sort_Order__c = 2;
        setup2.IsRequired__c = true;        
        zDocSetList.add(setup2);
        
        Id DocRTId = Schema.SObjectType.ZDocument_Setup__c.getRecordTypeInfosByName().get('zDocument Types').getRecordTypeId();
        
        ZDocument_Setup__c setup3 = new ZDocument_Setup__c();
        setup3.Name = 'HDOT';
        setup3.ZDocument_DesignLayout__c = design.id;
        setup3.RecordTypeId = DocRTId;
        setup3.Referred_DocType__c = 'HDOT';
        setup3.Sort_Order__c = 1;
        setup3.IsRequired__c = true;        
        zDocSetList.add(setup3);
        
        ZDocument_Setup__c setup4 = new ZDocument_Setup__c();
        setup4.Name = 'REFR';
        setup4.ZDocument_DesignLayout__c = design.id;
        setup4.RecordTypeId = DocRTId;
        setup4.Referred_DocType__c = 'REFR';
        setup4.Sort_Order__c = 2;
        setup4.IsRequired__c = true;
        zDocSetList.add(setup4);
        
        ZDocument_Setup__c setup5 = new ZDocument_Setup__c();
        setup5.Name = 'Rejected';
        setup5.ZDocument_DesignLayout__c = design.id;
        setup5.RecordTypeId = RTId;
        setup5.Referred_Column__c = 'Rejected';
        setup5.Sort_Order__c = 3;
        setup5.IsRequired__c = true;
        zDocSetList.add(setup5);
        
        Insert zDocSetList;
       
        Test.StartTest();
        zLDSDocumentSetController zLDS = new zLDSDocumentSetController();
		zLDS.layoutId = design.id;
        zLDS.getLayoutJSON();
        Test.StopTest();
   }
}