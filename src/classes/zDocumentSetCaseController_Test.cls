/*******************************************************************************************
* @Author      : Prathyusha Vasireddy
* @Date        : 6/27/2017
* @Description : The zDocumentSetCaseController_Test is  Test Class for zDocumentSetCaseController.
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer                			 Date                    Description
* ---------------           		-----------             -------------------------
* Prathyusha Vasireddy	            06/27/2017              Original Version
*********************************************************************************************/
@isTest
private class zDocumentSetCaseController_Test
{
    @isTest
    static void TestUnitTest()
    {
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        Case cs = new Case(Origin = 'Phone' , Status = 'Medium', AccountId = acc.Id);
        insert cs;
        
        ZDocument_DesignLayout__c zDD = new ZDocument_DesignLayout__c(name = 'Default Layout');
        insert zDD;
        
        ZPAPER__zpaper__c zpar = new ZPAPER__zpaper__c();
        zpar.ZPAPER__activated__c = true;
        zpar.ZPAPER__Home_Service_Page__c = '/kb/jsp/SF_kbGreetings.jsp';
        zpar.ZPAPER__server__c = 'zp20.zpaper.com';
        insert zpar;
        Test.startTest();
        String s = '{"sfId": "50041000001155o","crmTypes" : "Account:001,Contact:003,Case:500,Lead:00Q,","docTypes" : "Account:CRD:Credit Application,Case:3500:FDA Medwatch 3500,Case:DATA:Portal Data,Case:DOSE:Dosage Formlet,Case:ENRLC:zCharta Enrollment,Case:PIRM:*Patient Release,Case:REFR:Referral,Lead:HDOT:Handout,Case:HIPAA:HIPAA release","docStates" : "Received,Delivered,Indexed,Rejected,Processed,Updated,Verified,Wilco","files": [{"label" : "eric.stephens-6782356595-PDF00Q41000001XPxPEAW-NeedAttachmentName-1491935178773-1.pdf","ID" : "000046b4X1bdf49375","BATES" : "","View" : "<a  target=detail2  href=\'https://zp20.zpaper.com/kb/jsp/SF_files.jsp?dbID=000046b4X1bdf49375&skin=SFbare&type=FileLink\'>View</a>","created" : "2017-04-11 14:26:43.0","modified" : "2017-06-23 14:12:18.0","modifiedBy" : "18100","X_reviewedStatus" : "Wilco","X_docType" : "HDOT","X_reviews" : "Reviewed by lightning@zpaper.com at 4/11/2017 14:54<br>Indexed by lightning@zpaper.com at 4/11/2017 14:58<br>Undetected Barcode by lightning@zpaper.com at 4/11/2017 14:58<br>Verified by lightning@zpaper.com at 4/11/2017 14:58<br>"}]}';
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 s,
                                                 null);

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        zDocumentSetCaseController.zPaperFilesResponse zPFR= zDocumentSetCaseController.getZPaperDocs(cs.id, zDD.id, null);
        zDocumentSetCaseController.zFile zFile = new zDocumentSetCaseController.zFile();
        zFile.label = '';
        zFile.ID = '';
        zFile.BATES = '';
        zFile.created = '';
        zFile.modified = '';
        zFile.modifiedBy = '';
        zFile.X_reviewedStatus = '';      
        Test.stopTest();
    }
}