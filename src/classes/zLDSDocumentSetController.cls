/*******************************************************************************************
* @Author      : Cory Newey
* @Date        : 8/28/2017
* @Description : The zDocumentPropertiesController is using for zDocumentProperties VF page to configure User defined columns and Doc Types in the zDocumentSet_case lighting component.
* @Visualforce Component: zLDSDocumentSet
* @Visualforce Page: zStyledCaseDocuments
*
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer                          Date                    Description
* ---------------                   -----------             -------------------------
* Cory Newey                        08/28/2017               Original Version
*********************************************************************************************/

public with sharing class zLDSDocumentSetController {
    public String layoutId { get; set; }
    public String layoutName { get; set; }
    public String zpaperServer { get; set; }
    public String sfId { get; set; }
    public String sfServer { get; set; }
    public String sfSession { get; set; }

    public String getLayoutJSON() {
        System.debug('Pulling layout with Id: ' + layoutId);
        String jsonBuffer = '';
        List<ZPAPER5__ZDocument_Setup__c> columnsList;
        List<ZPAPER5__ZDocument_Setup__c> typesList;
        List<ZPAPER5__ZDocument_DesignLayout__c> layouts = new List<ZPAPER5__ZDocument_DesignLayout__c>();
        if (null != layoutId && layoutId.length() > 0) {
            layouts = [
                    SELECT Id, Name,
                            ZPAPER5__Documents_ViewLink_Name__c,
                            ZPAPER5__Documents_ViewLink_URL__c,
                            ZPAPER5__Document_ViewLink_URL_Parameters__c
                    FROM ZPAPER5__ZDocument_DesignLayout__c
                    where Id = :layoutId
            ];
        }
        if (0 == layouts.size() && null != layoutName && layoutName.length() > 0) {
            layouts =[SELECT Id, Name,
                    ZPAPER5__Documents_ViewLink_Name__c,
                    ZPAPER5__Documents_ViewLink_URL__c,
                    ZPAPER5__Document_ViewLink_URL_Parameters__c FROM ZPAPER5__ZDocument_DesignLayout__c where Name = :layoutName];
        }
        if (layouts.size() > 0) {
            ZPAPER5__ZDocument_DesignLayout__c dLayout = layouts.get(0);
            jsonBuffer += '{"layout": {"id":"' + dLayout.Id + '","Name":"' + dLayout.Name +
                    '","ZPAPER5__Documents_ViewLink_Name__c":"' + (null != dLayout.ZPAPER5__Documents_ViewLink_Name__c ? dLayout.ZPAPER5__Documents_ViewLink_Name__c : '') +
                    '","ZPAPER5__Documents_ViewLink_URL__c":"' + (null != dLayout.ZPAPER5__Documents_ViewLink_URL__c ? dLayout.ZPAPER5__Documents_ViewLink_URL__c : '') +
                    '","ZPAPER5__Document_ViewLink_URL_Parameters__c":"' + (null != dLayout.ZPAPER5__Document_ViewLink_URL_Parameters__c ? dLayout.ZPAPER5__Document_ViewLink_URL_Parameters__c  : '') + '"';

            columnsList = [Select Id, Name, RecordTypeId,
                    ZPAPER5__ActualColumn_Name__c,
                    ZPAPER5__IsRequired__c,
                    ZPAPER5__Referred_Column__c,
                    ZPAPER5__Referred_DocType__c,
                    ZPAPER5__Sort_Order__c,
                    ZPAPER5__ZDocument_DesignLayout__c
            From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Columns' AND ZPAPER5__ZDocument_DesignLayout__c =:dLayout.Id ORDER BY Sort_Order__c NULLS LAST];
            if (columnsList.size() > 0) {
                jsonBuffer += ',"zDocument_Columns":[';
                Integer count = 0;
                for (ZPAPER5__ZDocument_Setup__c setup : columnsList) {
                    if (count > 0) { jsonBuffer += ','; }
                    count++;
                    jsonBuffer += JSON.serialize(setup);
                }
                jsonBuffer += ']';
            }
//            typesList = [Select Id, Name, Sort_Order__c, IsRequired__c, Referred_DocType__c From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Types' AND ZPAPER5__ZDocument_DesignLayout__c =:dLayout.Id ORDER BY Sort_Order__c NULLS LAST];
            typesList = [Select Id, Name, RecordTypeId,
                    ZPAPER5__ActualColumn_Name__c,
                    ZPAPER5__IsRequired__c,
                    ZPAPER5__Referred_Column__c,
                    ZPAPER5__Referred_DocType__c,
                    ZPAPER5__Sort_Order__c,
                    ZPAPER5__ZDocument_DesignLayout__c
            From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Types' AND ZPAPER5__ZDocument_DesignLayout__c =:dLayout.Id ORDER BY Sort_Order__c NULLS LAST];
            if (typesList.size() > 0) {
                jsonBuffer += ',"zDocument_Types":[';
                Integer count = 0;
                for (ZPAPER5__ZDocument_Setup__c typeSetup : typesList) {
                    if (count > 0) { jsonBuffer += ','; }
                    count++;
                    jsonBuffer += JSON.serialize(typeSetup);
                }
                jsonBuffer += ']';
            }
            return jsonBuffer + '}}';
        }
        return '{}';
    }
}