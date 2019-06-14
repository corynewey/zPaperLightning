/*******************************************************************************************
* @Author      : Prathyusha Vasireddy
* @Date        : 6/27/2017
* @Description : The CompleteFormController_Test is the Test Class for CompleteFormController.
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer                			 Date                    Description
* ---------------           		-----------             -------------------------
* Prathyusha Vasireddy	            06/27/2017              Original Version
*********************************************************************************************/
@isTest
private class CompleteFormController_Test
{
    @isTest
    static void TestUnitTest()
    {
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        Case cs = new Case(Origin = 'Phone' , Status = 'Medium', AccountId = acc.Id);
        insert cs;
        
        ZPAPER__zpaper__c zpar = new ZPAPER__zpaper__c();
        zpar.ZPAPER__activated__c = true;
        zpar.ZPAPER__Home_Service_Page__c = '/kb/jsp/SF_kbGreetings.jsp';
        zpar.ZPAPER__server__c = 'zp20.zpaper.com';
        insert zpar;
        Test.startTest();
        String s = 'zFormsResponse:[LoggedInUser=flash.lightning@zpaper.com, OrdId=00D41000000UDnkEAG, recordId=50041000001155oAAA, sfServer=https://zpaper1-dev-ed.my.salesforce.com/services/Soap/u/31.0/00D41000000UDnk, sfSession=SESSION_ID_REMOVED, zPaperBaseURL=https://zp20.zpaper.com, zforms={ "forms" : [ { "name" : "AbbVie_PAF_HUMIRA.pdf", "value" : "2050020175003075024_Form", "id" : "18100014Z1bf72bcbg", "BATES" : "2050020175003075024_Form", "type" : "Fax", "URL" : "../allfiles/18100014Z1bf72bcbg/AbbVie_PAF_HUMIRA.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "Access 360 Missing Insurance C", "value" : "2050020175205205213_Form", "id" : "18100014Z1bagl2s1m", "BATES" : "2050020175205205213_Form", "type" : "Fax", "URL" : "../allfiles/18100014Z1bagl2s1m/Access 360 Missing Insurance Card.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "Add PAP Attributes", "value" : "addPAPAttributes_Data2_Web_Form", "id" : "18100014Z1aj7iftcr", "BATES" : "addPAPAttributes_Data2_Web_Form", "type" : "HTML", "URL" : "../allfiles/18100014Z1aj7iftcr/blank.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "AZ DE Panel.pdf", "value" : "2050020160619150629_Data2_Web_Form", "id" : "18100014Z1avf5ctkm", "BATES" : "2050020160619150629_Data2_Web_Form", "type" : "HTML", "URL" : "../allfiles/18100014Z1avf5ctkm/Patient Referral Data Entry Panel.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "AZapplication_black.pdf", "value" : "2050020165919085943_Form", "id" : "18100014Z1avegdbnp", "BATES" : "2050020165919085943_Form", "type" : "Fax", "URL" : "../allfiles/18100014Z1avegdbnp/AZapplication_black.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "AZapplication_blackZP.pdf", "value" : "1810020160216170242_Form", "id" : "000046b4Z1b44qh153", "BATES" : "1810020160216170242_Form", "type" : "Coversheet", "URL" : "../allfiles/000046b4Z1b44qh153/AZapplication_blackZP.pdf", "readers" : ":18100:-18100:", "prepopType" : "Case" }, { "name" : "BRD Link Program and Medical P", "value" : "2050020162007152032_Form", "id" : "18100014Z1as31grbi", "BATES" : "2050020162007152032_Form", "type" : "Fax", "URL" : "../allfiles/18100014Z1as31grbi/Bard Link Program and Medical Prescription_w_QR_Code.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "BRD PMP Data Entry Panel.pdf", "value" : "2050020160514110529_Data2_Web_Form", "id" : "18100014Z1askjmi6s", "BATES" : "2050020160514110529_Data2_Web_Form", "type" : "HTML", "URL" : "../allfiles/18100014Z1askjmi6s/BRD PMP Data Entry Panel.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "Concealed Carry App", "value" : "2050020175123105146_Data2_Web_Form", "id" : "18100014Z1b9lqnjlf", "BATES" : "2050020175123105146_Data2_Web_Form", "type" : "HTML", "URL" : "../allfiles/18100014Z1b9lqnjlf/blank.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "Cosentyx Service Request Form ", "value" : "2050020161512101525_Form", "id" : "18100014Z1ausjutqm", "BATES" : "2050020161512101525_Form", "type" : "Fax", "URL" : "../allfiles/18100014Z1ausjutqm/Cosentyx Service Request Form and Prescription_BW.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "David Webb AbbVie Acknowledgem", "value" : "AbbVieHumiraAcknowledgement_Form", "id" : "18100014Z1bcqlaiao", "BATES" : "AbbVieHumiraAcknowledgement_Form", "type" : "Fax", "URL" : "../allfiles/18100014Z1bcqlaiao/David Webb AbbVie Acknowledgement letter.pdf", "readers" : ":-18100:", "prepopType" : "Case" }, { "name" : "Master Provider Referral Form ", "value" : "1810020165827165855_Form", "id" : "000046b4Z1b514m779", "BATES" : "1810020165827165855_Form", "type" : "Fax", "URL" : "../allfiles/000046b4Z1b514m779/Master Provider Referral Form 020416ZP.pdf", "readers" : ":18100:-18100:", "prepopType" : "Case" }, { "name" : "Simple Contact Coversheet", "value" : "1810012161358_zpPro_Form", "id" : "000046b4X1b44g0qsu", "BATES" : "1810012161358_zpPro_Form", "type" : "Coversheet", "URL" : "../allfiles/000046b4X1b44g0qsu/DefaultCoversheet.pdf", "readers" : ":18100:-18100:", "prepopType" : "Contact" }, { "name" : "zPapyrus Enrollment Form SRF-S", "value" : "1810020160516170544_Form", "id" : "000046b4Z1b44qmi94", "BATES" : "1810020160516170544_Form", "type" : "Fax", "URL" : "../allfiles/000046b4Z1b44qmi94/zPapyrus Enrollment Form SRF-SMN 2017ZP.pdf", "readers" : ":18100:-18100:", "prepopType" : "Case" }] }';
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 s,
                                                 null);

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        CompleteFormController.zFormsResponse zFR= CompleteFormController.getzCompleteForms(cs.id);
        Test.stopTest();
    }
}