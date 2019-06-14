/*******************************************************************************************
* @Author      : Prathyusha Vasireddy
* @Date        : 6/27/2017
* @Description : The zPaperHomeController_Test is the Test Class for zPaperHomeController.
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer                			 Date                    Description
* ---------------           		-----------             -------------------------
* Prathyusha Vasireddy	            06/27/2017              Original Version
*********************************************************************************************/
@isTest
private class zPaperHomeController_Test
{
    @isTest
    static void TestUnitTest()
    {
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        Contact con = new Contact(LastName = 'Test ' , FirstName = 'Con', AccountId = acc.Id);
        insert con;
        
        ZpaperConfig__c zpConfig = new ZpaperConfig__c( PartnerUrl__c = 'https://zpaper1-dev-ed--c.na35.visual.force.com/services/Soap/u/31.0/00D41000000UDnk',
                            SessionId__c = '00D41000000UDnk!AQoAQEzegYlxkcUAC.gaj2GNyY11KCRldm8YX5ty_EIcmsGz02P1wt37uajh.7trYXl2LwFfKw.TICdy5iNtt_MoJhAE7hZF');
        insert zpConfig;
        
        ZPAPER__zpaper__c zpar = new ZPAPER__zpaper__c();
        zpar.ZPAPER__activated__c = true;
        zpar.ZPAPER__Home_Service_Page__c = '/kb/jsp/SF_kbGreetings.jsp';
        zpar.ZPAPER__server__c = 'zp20.zpaper.com';
        insert zpar;
        Test.startTest();
        
          String s = '{"New0": 4,"Received": 4, "NewFaxPage": 0, "Sent": 2, "SentFaxPage": 1, "zStatus": "","zFax": "<a href=\'mailto:pdf.0987654321.null@mfb.zpaper.com?Subject=Send a PDF to this record\' title=\'email to this record\'>+1 (098) 765-4321</a>","zUserData": {"Admin":"yes","Triage":"yes","Sign":"yes"},"zClock": "Tue Jun 27 13:50:32 EDT 2017"};';
          SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 s,
                                                 null);

          // Set mock callout class
          Test.setMock(HttpCalloutMock.class, fakeResponse);
          Map<String, String> zdt =  ZpaperHomeController.sendADocController(acc.Id);
        
          ZpaperHomeController.zData zdta= ZpaperHomeController.service();
          
          ZpaperHomeController.zData zt = new ZpaperHomeController.zData();
          zt.received = 1;
          zt.newFaxPage = 0;
          zt.sent = 1;
          zt.sentFaxPage = '1';
          zt.zstatus = 'Yes';
          zt.zFax = '<a href';
          zt.zClock  = '6767';
          
          ZpaperHomeController.zUserDataList zUsrData = new ZpaperHomeController.zUserDataList();
          zUsrData.Admin = 'Yes';
          zUsrData.Triage = 'Yes';
          zUsrData.sign = 'Yes';
         Test.stopTest();
    }
}