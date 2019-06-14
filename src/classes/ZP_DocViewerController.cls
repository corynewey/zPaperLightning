/*********************************************************************************
Class Name      : ZP_DocViewerController
Description     : Build zPaper information to support displaying documents under zPaper control
Modification Log:
----------------------------------------------------------------------------------
Developer                   Date                   Description
-----------------------------------------------------------------------------------
Cory Newey                 02/23/2018              Creation
*********************************************************************************/
public with sharing class ZP_DocViewerController {

    /*********************************************************************************
    Method Name    : getAttachmentId
    Author         : Cory Newey
    Description    : This method is used to get all the fax details
    Return Type    : FaxDetailsWrapper
    Parameter      : String strDocId
    Parameter      : String zpSnippetIdFld
    *********************************************************************************/
    @AuraEnabled
    public static FaxDetailsWrapper getAttachmentId(String strDocId, String zpSnippetIdFld, String strDbId) {
        FaxDetailsWrapper faxDetailsWrapper = new FaxDetailsWrapper();

        System.debug('@@@@ strDocId = *' + strDocId + '*');
        if (NULL != strDocId && strDocId.length() > 0) {
            Id docId = Id.valueOf(strDocId);
            System.debug('@@@@ Id = ' + docId);
            Schema.DescribeSObjectResult dr = docId.getSobjectType().getDescribe();
            System.debug('@@@@ Document type = *' + dr.getName() + '* @@@@');

            /*
            * FLS Check for Attachment
            */
            List<String> fields = new List<String>{'Name'};
            List<Attachment> lstAttachments = [SELECT Id FROM Attachment WHERE parentId =: strDocId limit 1];
            System.debug('@@@@ Number of attachments = ' + lstAttachments.size());
            if (lstAttachments.size() > 0) {
                faxDetailsWrapper.attachmentId = lstAttachments[0].Id;
            }

            /*
             * zCRN170907 -- gather more information that is needed for viewing fax from zPaper servers
             */
            faxDetailsWrapper.sfSession = UserInfo.getSessionId();
            faxDetailsWrapper.sfServer = URL.getSalesforceBaseUrl().getHost();
//        List<String> docFields = new List<String>{'PC_zPaper_Fax_Unique_Id__c'};
            if ('NONE' != zpSnippetIdFld) {
                List<String> docFields = new List<String>();
                docFields.add(zpSnippetIdFld);
//        List<SObject> parentDoc = [SELECT PC_zPaper_Fax_Unique_Id__c FROM PC_Document__c WHERE Id =: strDocId];
                System.debug('@@@@ SOQL Query = [SELECT ' + zpSnippetIdFld + ' FROM ' + dr.getName() + ' WHERE Id = ' + strDocId + ']');
                List<SObject> parentDoc = Database.query('SELECT ' + zpSnippetIdFld + ' FROM ' + dr.getName() + ' WHERE Id = \'' + strDocId + '\'');
                System.debug('@@@@ Number of parentDoc objects = ' + parentDoc.size());
                if (0 == parentDoc.size()) {
                    System.debug('ERROR: Parent document not found. Not setting zPaper fields.');
                    return faxDetailsWrapper;
                }
                faxDetailsWrapper.zpDBId = (String) parentDoc[0].get(zpSnippetIdFld);
            }
            else if (NULL != strDbId && strDbId.length() > 0) {
                faxDetailsWrapper.zpDBId = strDbId;
            }
            System.debug('@@@@ zPaper dbID = ' + faxDetailsWrapper.zpDBId);
        }
        // New global API endpoint for all partners so that there is no dependency on our
        // custom setting object in our managed package.
        String zpServer = 'api.zpaper.com';
        LIST<ZPAPER5__ZP_Partner_Setting__mdt> partnerSettings =
            [SELECT ZPAPER5__Partner_API_Host__c,DeveloperName,MasterLabel FROM ZPAPER5__ZP_Partner_Setting__mdt WHERE DeveloperName = 'ZP_General_Settings' ];
        System.debug('@@@ Partner Settings List = ' + partnerSettings);
        if (partnerSettings.size() > 0) {
            System.debug('### Settings[0]: Api Host = ' + partnerSettings[0].ZPAPER5__Partner_API_Host__c);
            System.debug('### Settings[0]: Name = ' + partnerSettings[0].DeveloperName);
            System.debug('### Settings[0]: Label = ' + partnerSettings[0].MasterLabel);
            System.debug('@@@ Setting api host from General Settings: ' + partnerSettings[0].ZPAPER5__Partner_API_Host__c);
            zpServer = partnerSettings[0].ZPAPER5__Partner_API_Host__c;
        }
        System.debug('@@@@ zPaper API Server: ' + zpServer);
        faxDetailsWrapper.sfUser = UserInfo.getUserName();
        faxDetailsWrapper.sfOrg = UserInfo.getOrganizationId();
        faxDetailsWrapper.sfDocId = strDocId;
        faxDetailsWrapper.zpServer = zpServer;
        return faxDetailsWrapper;
    }

    /*********************************************************************************
    Class Name    : FaxDetailsWrapper
    Author        : Cory Newey
    Description   : Wrapper class for fax details
    *********************************************************************************/
    public class FaxDetailsWrapper {
        @AuraEnabled public Id attachmentId {get; set;}
        @AuraEnabled public String sfServer {get; set;}
        @AuraEnabled public String sfSession {get; set;}
        @AuraEnabled public String sfDocId {get; set;}
        @AuraEnabled public String sfUser {get; set;}
        @AuraEnabled public String sfOrg {get; set;}
        @AuraEnabled public String zpServer {get; set;}
        @AuraEnabled public String zpDBId {get; set;}
    }
}