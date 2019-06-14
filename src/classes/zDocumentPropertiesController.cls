/*******************************************************************************************
* @Author      : Prathyusha Vasireddy
* @Date        : 6/15/2017
* @Description : The zDocumentPropertiesController is using for zDocumentProperties VF page to configure User defined columns and Doc Types in the zDocumentSet_case lighting component.
* @Visulforce Page: zDocumentProperties
* @Visulforce Component: zDocumentPropertiesMultiSelect_ltng
*
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer                          Date                    Description
* ---------------                   -----------             -------------------------
* Prathyusha Vasireddy              06/22/2017              Original Version  
*********************************************************************************************/
public with sharing class zDocumentPropertiesController {

    public SelectOption[] selectedZDocsClmns { get; set; }
    public SelectOption[] availableZDocsClmns { get; set; }

    public SelectOption[] selectedZDocsTypes { get; set; }
    public SelectOption[] availableZDocsTypes { get; set; }

    public SelectOption[] leftOptions { get; set; }
    public SelectOption[] rightOptions { get; set; }

    public Map<id, ZPAPER5__ZDocument_Setup__c> zDocColumnsMap { get; set; }
    public Map<id, ZPAPER5__ZDocument_Setup__c> zDocTypesMap { get; set; }

    public String selectedProperty { get; set; }
    public ZPAPER5__ZDocument_Setup__c ZDocumentSetup { get; set; }

    public SelectOption[] designLayoutOptions { get; set; }
    public String selectedDesignLayout { get; set; }

    public String actionButtonsJSON { get; set; }

    public ZPAPER5__ZDocument_DesignLayout__c DesignLayout { get; set; }

    /* Constructor : zDocumentPropertiesController
     * Parameters : N/A
     * Description : Initial loading to get all Design Layouts.
     */
    public zDocumentPropertiesController() {
        /* designLayoutOptions =  new List<SelectOption>();
         for(ZPAPER5__ZDocument_DesignLayout__c dLayout : [SELECT id, Name FROM ZPAPER5__ZDocument_DesignLayout__c]){
             designLayoutOptions.add(new SelectOption(dLayout.id,dLayout.Name));
             selectedDesignLayout = dLayout.id;
         } */
        getDesignLayouts();
        getZDocumentSetups();
    }

    /* Method : getDesignLayouts
     * Parameters : N/A
     * Return Type : Void
     * Description : get all Design Layouts.
     */
    public void getDesignLayouts() {
        selectedProperty = '';
        designLayoutOptions = new List<SelectOption>();
        for (ZPAPER5__ZDocument_DesignLayout__c dLayout : [SELECT id, Name FROM ZPAPER5__ZDocument_DesignLayout__c]) {
            designLayoutOptions.add(new SelectOption(dLayout.id, dLayout.Name));
            selectedDesignLayout = dLayout.id;
        }
    }

    /* Method : getZDocumentSetups
     * Parameters : N/A
     * Return Type : Void
     * Description : To load Document set table's columns, visibility and order configurations for selected design layout. and this data is passing to zDocumentPropertiesMultiSelect_ltng VF component.
     */
    public void getZDocumentSetups() {
        selectedZDocsClmns = new List<SelectOption>();
        availableZDocsClmns = new List<SelectOption>();

        selectedZDocsTypes = new List<SelectOption>();
        availableZDocsTypes = new List<SelectOption>();

        ZDocumentSetup = new ZPAPER5__ZDocument_Setup__c();
        selectedProperty = '';
        DesignLayout = new ZPAPER5__ZDocument_DesignLayout__c();

        zDocColumnsMap = new Map<id, ZPAPER5__ZDocument_Setup__c>([Select Id, Name, Sort_Order__c, IsRequired__c, ActualColumn_Name__c From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Columns' AND ZPAPER5__ZDocument_DesignLayout__c = :selectedDesignLayout ORDER BY Sort_Order__c NULLS LAST]);
        for (ZPAPER5__ZDocument_Setup__c setup : zDocColumnsMap.values()) {
            if (!setup.IsRequired__c)
                availableZDocsClmns.add(new SelectOption(setup.Id, setup.Name)); else
                    selectedZDocsClmns.add(new SelectOption(setup.Id, setup.Name));
        }

        zDocTypesMap = new Map<id, ZPAPER5__ZDocument_Setup__c>([Select Id, Name, Sort_Order__c, IsRequired__c, Referred_DocType__c From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Types' AND ZPAPER5__ZDocument_DesignLayout__c = :selectedDesignLayout ORDER BY Sort_Order__c NULLS LAST]);
        for (ZPAPER5__ZDocument_Setup__c setup : zDocTypesMap.values()) {
            if (!setup.IsRequired__c)
                availableZDocsTypes.add(new SelectOption(setup.Id, setup.Name)); else
                    selectedZDocsTypes.add(new SelectOption(setup.Id, setup.Name));
        }
    }

    @TestVisible
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i = 0; i < parts.size() / 2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i * 2], 'UTF-8'),
                    EncodingUtil.urlDecode(parts[(i * 2) + 1], 'UTF-8')));
        }
    }

    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden {
        get;
        set {
            leftOptionsHidden = value;
            setOptions(leftOptions, value);
        }
    }

    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden {
        get;
        set {
            rightOptionsHidden = value;
            setOptions(rightOptions, value);
        }
    }

    /* Method : getzCompleteForms
     * Parameters : CaseId (Current record Id)
     * Return Type : zFormsResponse(Inner class)
     * Description : Doing zPaper server HTTP callous and constructing the response in Apex objects.
     */
    public PageReference editColumnName() {
        zDocumentSetup = [SELECT id, Name FROM ZPAPER5__ZDocument_Setup__c WHERE id = :selectedProperty];
        return null;
    }

    /* Method : saveColumnName
     * Parameters : N/A
     * Return Type : Void
     * Description : Updating the User defined/ custom column names for for document set table.
     */
    public PageReference updateColumnName() {
        try {
            Update zDocumentSetup;
            getZDocumentSetups();
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**updateColumnName*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    /* Method : deleteColumn
     * Parameters : N/A
     * Return Type : Void
     * Description : Deleting the selected column from ZPAPER5__ZDocument_Setup__c associated selected design layout.
     */
    public void deleteColumn() {
        try {
            Delete [SELECT id, Name FROM ZPAPER5__ZDocument_Setup__c WHERE id = :selectedProperty];
            getZDocumentSetups();
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**deleteColumn*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    /* Method : saveColumnProperties
     * Parameters : N/A
     * Return Type : Void
     * Description : Updating the columns visibility and order for document set table.
     */
    public PageReference saveColumnProperties() {
        try {
            if (selectedZDocsClmns != null && selectedZDocsClmns.size() > 0) {
                for (Integer i = 0; i < selectedZDocsClmns.size(); i++) {
                    zDocColumnsMap.get(selectedZDocsClmns[i].getValue()).Sort_Order__c = i + 1;
                    zDocColumnsMap.get(selectedZDocsClmns[i].getValue()).IsRequired__c = true;
                }
            }

            if (availableZDocsClmns != null && availableZDocsClmns.size() > 0) {
                for (SelectOption so : availableZDocsClmns) {
                    zDocColumnsMap.get(so.getValue()).Sort_Order__c = null;
                    zDocColumnsMap.get(so.getValue()).IsRequired__c = false;
                }
            }
            Update zDocColumnsMap.values();
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**saveColumnProperties*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    /* Method : saveDocTypeProperties
     * Parameters : N/A
     * Return Type : Void
     * Description : Updating the DocTypes visibility and order for document set table.
     */
    public PageReference saveDocTypeProperties() {
        System.debug('$$$$ in saveDocTypeProperties $$$');
        try {
            if (selectedZDocsTypes != null && selectedZDocsTypes.size() > 0) {
                for (Integer i = 0; i < selectedZDocsTypes.size(); i++) {
                    zDocTypesMap.get(selectedZDocsTypes[i].getValue()).Sort_Order__c = i + 1;
                    zDocTypesMap.get(selectedZDocsTypes[i].getValue()).IsRequired__c = true;
                }
            }

            if (availableZDocsTypes != null && availableZDocsTypes.size() > 0) {
                for (SelectOption so : availableZDocsTypes) {
                    zDocTypesMap.get(so.getValue()).Sort_Order__c = null;
                    zDocTypesMap.get(so.getValue()).IsRequired__c = false;
                }
            }
            Update zDocTypesMap.values();
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**saveDocTypeProperties*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    /* Method : getDesignLayout
     * Parameters : N/A
     * Return Type : Void
     * Description : Fetching the selected Design Layout.
     */
    public void getDesignLayout() {
        DesignLayout = null;
        List<ZPAPER5__ZDocument_DesignLayout__c> layouts = [
                SELECT id, Name, ZPAPER5__Documents_ViewLink_Name__c, ZPAPER5__Documents_ViewLink_URL__c,
                                ZPAPER5__Document_ViewLink_URL_Parameters__c, ZPAPER5__Suppress_Blank_Entries__c
                FROM ZPAPER5__ZDocument_DesignLayout__c
                WHERE id = :selectedDesignLayout
        ];
        if (layouts.size() > 0) {
            DesignLayout = layouts.get(0);
        }
        List<ZPAPER5__zPaper_Document_Set_Action__c> actions = [
                SELECT Id, Button_Event_Name__c, Column_Location__c, Label__c, ZPAPER5__Component__c, zDocument_Design_Layout__c, Visible_In_Stages__c
                FROM ZPAPER5__zPaper_Document_Set_Action__c
                WHERE ZPAPER5__zDocument_Design_Layout__c = :selectedDesignLayout
        ];
        if (actions.size() > 0) {
            actionButtonsJSON = JSON.serialize(actions);
        }
        else {
            actionButtonsJSON = '[]';
        }
//        DesignLayout = [SELECT id, Name, Documents_ViewLink_Name__c, Documents_ViewLink_URL__c,Document_ViewLink_URL_Parameters__c FROM ZPAPER5__ZDocument_DesignLayout__c WHERE id=: selectedDesignLayout];
    }

    // Initializing the new ZPAPER5__ZDocument_DesignLayout__c
    public void setNewDesignLayout() {
        DesignLayout = new ZPAPER5__ZDocument_DesignLayout__c();
    }

    // Importing designs from Salesforce static resource
    public void importDesignLayout() {
        MetadataService.MetadataPort service = createService();
        if (null == service) {
            return;
        }
        String nameSpace = 'ZPAPER5__';
//        MetadataService.IReadResult[] results = service.readMetadata('StaticResource', new String[] { 'zDocSetup_json' }).getRecords();
        MetadataService.IReadResult iResult = service.readMetadata('StaticResource', new String[]{
                'zDocSetup_json'
        });
        if (null != iResult) {
            MetadataService.Metadata[] results = iResult.getRecords();
            if (results.size() > 0) {
                MetadataService.StaticResource staticResource = (MetadataService.StaticResource) results[0];
                if (null == staticResource.fullName) {
                    System.debug('@@ No static resource found for fullname zDocSetup_json, trying with namespace: ' + nameSpace);
                    // The static resource wasn't found. Try tacking on the namespace to the front.
                    iResult = service.readMetadata('StaticResource', new String[]{
                            nameSpace + 'zDocSetup_json'
                    });
                    if (null != iResult) {
                        results = iResult.getRecords();
                        if (results.size() > 0) {
                            staticResource = (MetadataService.StaticResource) results[0];
                        }
                    }
                }
                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Static Content @@@@@@@@@@@@@@@\n@@ Number of records = ' + results.size() + '\n@@ Name = ' + staticResource.fullName +
                        '\n@@ contentType = ' + staticResource.contentType + '\n@@ content = ' + staticResource.content + '\n@@@@@@@@@@@@@@@@@@@@@@@@@');
                if (null != staticResource.content) {
                    String json = EncodingUtil.base64Decode(staticResource.content).toString();
                    System.debug('@@@@@@@@@@@@@@@ Decoded Content @@@@@@@@@@@@\n' + json);
                    /* ****************************************************************************************************
                        The JSON looks like this:
                        [{
                            "layout": "{"id":a0841000008UmowAAC",
                            "Name": "Account Layout",
                            "ZPAPER5__Documents_ViewLink_Name__c": "",
                            "ZPAPER5__Documents_ViewLink_URL__c": "test.salesforce.com?Record Id",
                            "ZPAPER5__Document_ViewLink_URL_Parameters__c": "Record Id",
                            "zDocument_Columns": [{
                                "attributes": {
                                    "type": "ZPAPER5__ZDocument_Setup__c",
                                    "url": "/services/data/v40.0/sobjects/ZPAPER5__ZDocument_Setup__c/a074100000GLSPYAA5"
                                },
                                "Id": "a074100000GLSPYAA5",
                                "Name": "Discovered",
                                "ZPAPER5__Sort_Order__c": 1,
                                "ZPAPER5__IsRequired__c": true,
                                "ZPAPER5__ActualColumn_Name__c": "Discovered",
                                "RecordTypeId": "01241000001IIG2AAO"
                            }],
                            "zDocument_Types": [{
                                "attributes": {
                                    "type": "ZPAPER5__ZDocument_Setup__c",
                                    "url": "/services/data/v40.0/sobjects/ZPAPER5__ZDocument_Setup__c/a074100000G3Rr5AAF"
                                },
                                "Id": "a074100000G3Rr5AAF",
                                "Name": "PAF",
                                "ZPAPER5__Sort_Order__c": 1,
                                "ZPAPER5__IsRequired__c": true,
                                "RecordTypeId": "01241000001IIG7AAO"
                            }],
                        }]
                    ***************************************************************************************************** */
                    Integer idxBegin, idxEnd = 0;
                    String layoutLabel = '"layout": {';
                    String docColumnsLabel = '"zDocument_Columns":';
                    String docTypesLabel = '"zDocument_Types":';
                    List<ZPAPER5__ZDocument_DesignLayout__c> layoutsToInsert = new List<ZPAPER5__ZDocument_DesignLayout__c>();
                    List<ZPAPER5__ZDocument_DesignLayout__c> layoutsToUpdate = new List<ZPAPER5__ZDocument_DesignLayout__c>();
                    Map<String, ZPAPER5__ZDocument_Setup__c> setupsMap = new Map<String, ZPAPER5__ZDocument_Setup__c>();
                    do {
                        idxBegin = json.indexOf(layoutLabel, idxEnd);
                        if (idxBegin > 0) {
                            idxBegin += layoutLabel.length();
                            idxEnd = json.indexOf(docColumnsLabel, idxBegin);
                            if (idxEnd > idxBegin) {
                                String layout = json.substring(idxBegin, idxEnd);

                                String id = parseFromJSON(layout, 'id');
                                String name = parseFromJSON(layout, 'Name');
                                String viewLinkName = parseFromJSON(layout, 'ZPAPER5__Documents_ViewLink_Name__c');
                                String viewLinkURL = parseFromJSON(layout, 'ZPAPER5__Documents_ViewLink_URL__c');
                                String viewLinkParams = parseFromJSON(layout, 'ZPAPER5__Document_ViewLink_URL_Parameters__c');
                                Boolean suppressBlankEntries = Boolean.valueOf(parseFromJSON(layout, 'ZPAPER5__Suppress_Blank_Entries__c'));
                                ZPAPER5__ZDocument_DesignLayout__c layoutIn;
//                                if (null != id && id.length() > 0) {
                                if (null != name && name.length() > 0) {
                                    List<ZPAPER5__ZDocument_Setup__c> docColList = null;
                                    List<ZPAPER5__ZDocument_Setup__c> docTypeList = null;
                                    layoutIn = null;
                                    List<ZPAPER5__ZDocument_DesignLayout__c> layouts = [
//                                    layoutIn = [
                                            SELECT Id, Name,
                                                    ZPAPER5__Documents_ViewLink_Name__c,
                                                    ZPAPER5__Documents_ViewLink_URL__c,
                                                    ZPAPER5__Document_ViewLink_URL_Parameters__c,
                                                    ZPAPER5__Suppress_Blank_Entries__c
                                            FROM ZPAPER5__ZDocument_DesignLayout__c
                                            where Name = :name
                                    ];
                                    if (layouts.size() > 0) {
                                        layoutIn = layouts.get(0);
                                    }
                                    if (null == layoutIn) {
                                        layoutIn = new ZPAPER5__ZDocument_DesignLayout__c();
                                        layoutIn.Name = name;
                                        layoutIn.ZPAPER5__Documents_ViewLink_Name__c = viewLinkName;
                                        layoutIn.ZPAPER5__Documents_ViewLink_URL__c = viewLinkURL;
                                        layoutIn.ZPAPER5__Document_ViewLink_URL_Parameters__c = viewLinkParams;
                                        layoutIn.ZPAPER5__Suppress_Blank_Entries__c = suppressBlankEntries;
                                        System.debug('@@@ Inserting Layout @@@');
//                                        layoutsToInsert.add(layoutIn);
                                        Insert layoutIn;                    // we can't delay this create since we need the Id for the setup record
//                                    } else if (name != layoutIn.Name ||
                                    } else if (viewLinkName != layoutIn.ZPAPER5__Documents_ViewLink_Name__c ||
                                            viewLinkURL != layoutIn.ZPAPER5__Documents_ViewLink_URL__c ||
                                            viewLinkParams != layoutIn.ZPAPER5__Document_ViewLink_URL_Parameters__c ||
                                            suppressBlankEntries != layoutIn.ZPAPER5__Suppress_Blank_Entries__c) {
//                                        layoutIn.Name = name;
                                        layoutIn.ZPAPER5__Documents_ViewLink_Name__c = viewLinkName;
                                        layoutIn.ZPAPER5__Documents_ViewLink_URL__c = viewLinkURL;
                                        layoutIn.ZPAPER5__Document_ViewLink_URL_Parameters__c = viewLinkParams;
                                        layoutIn.ZPAPER5__Suppress_Blank_Entries__c = suppressBlankEntries;
                                        System.debug('@@@ Updating Layout @@@');
                                        layoutsToUpdate.add(layoutIn);
                                    }
                                    System.debug('@@ After Insert/Update of Layout: Layout ID = ' + layoutIn.Id);
                                    idxBegin = json.indexOf(docColumnsLabel, idxEnd);
                                    docColList = parseZDocumentSetups(json, idxBegin, docColumnsLabel);
                                    for (ZPAPER5__ZDocument_Setup__c docSetup : docColList) {
                                        docSetup.ZPAPER5__ZDocument_DesignLayout__c = layoutIn.Id;
//                                        setupsMap.put(docSetup.Id, docSetup);
                                        setupsMap.put(docSetup.Name, docSetup);
                                    }
                                    idxBegin = json.indexOf(docTypesLabel, idxEnd);
                                    docTypeList = parseZDocumentSetups(json, idxBegin, docTypesLabel);
                                    for (ZPAPER5__ZDocument_Setup__c docSetup : docTypeList) {
                                        docSetup.ZPAPER5__ZDocument_DesignLayout__c = layoutIn.Id;
//                                        setupsMap.put(docSetup.Id, docSetup);
                                        setupsMap.put(docSetup.Name, docSetup);
                                    }
                                    idxEnd = idxBegin + docTypesLabel.length();
                                }
                            }
                        }
                    } while (idxBegin > 0);
//                    if (layoutsToInsert.size() > 0) { Insert layoutsToInsert; }
                    if (layoutsToUpdate.size() > 0) {
                        Update layoutsToUpdate;
                    }
                    createUpdateZDocSetupList(setupsMap);
                    return;
                }
            }
        }
        System.debug('@@ Did not find any zDocSetup_json static resource.');
    }

    private List<ZPAPER5__ZDocument_Setup__c> parseZDocumentSetups(String jsonStr, Integer idxBegin, String zDocSetupLabel) {
        if (idxBegin > 0) {
            // parse out the column list
            idxBegin += zDocSetupLabel.length();
            Integer idxEnd = jsonStr.indexOf(']', idxBegin);
            if (idxEnd > idxBegin) {
                idxEnd++;
                String zTypes = jsonStr.substring(idxBegin, idxEnd).trim();
                if (zTypes.length() > 2) {    // string is bigger that []
                    return (List<ZPAPER5__ZDocument_Setup__c>) JSON.deserialize(zTypes, List<ZPAPER5__ZDocument_Setup__c>.class);
                }
            }
        }
        return null;
    }

//    private void createUpdateZDocSetupList(Map<Id, ZPAPER5__ZDocument_Setup__c> setupsMap) {
    private void createUpdateZDocSetupList(Map<String, ZPAPER5__ZDocument_Setup__c> setupsMap) {
        if (null != setupsMap && setupsMap.size() > 0) {
            List<ZPAPER5__ZDocument_Setup__c> setupsToInsert = new List<ZPAPER5__ZDocument_Setup__c>();
            List<ZPAPER5__ZDocument_Setup__c> setupsToUpdate = new List<ZPAPER5__ZDocument_Setup__c>();
            // first pull any zDocSetup objects that already exist here
//            Map<Id, ZPAPER5__ZDocument_Setup__c> setupsThatExistMap = new Map<ID, ZPAPER5__ZDocument_Setup__c> ([
            Map<String, ZPAPER5__ZDocument_Setup__c> setupsThatExistMap = new Map<String, ZPAPER5__ZDocument_Setup__c>([
                    Select Id, Name, RecordTypeId,
                            ZPAPER5__ActualColumn_Name__c,
                            ZPAPER5__IsRequired__c,
                            ZPAPER5__Referred_Column__c,
                            ZPAPER5__Referred_DocType__c,
                            ZPAPER5__Sort_Order__c,
                            ZPAPER5__ZDocument_DesignLayout__c
                    From ZPAPER5__ZDocument_Setup__c
                    WHERE Name in :setupsMap.keySet()
//                WHERE Id in :setupsMap.keySet()
            ]);
            // separate the new creates from the updates
//            for (Id key : setupsMap.keySet()) {
            for (String key : setupsMap.keySet()) {
                ZPAPER5__ZDocument_Setup__c curSetup = setupsMap.get(key);
                ZPAPER5__ZDocument_Setup__c prevSetup = setupsThatExistMap.get(key);
                if (null != prevSetup) {
//                    prevSetup.Name = curSetup.Name;
                    prevSetup.ZPAPER5__ActualColumn_Name__c = curSetup.ZPAPER5__ActualColumn_Name__c;
                    prevSetup.ZPAPER5__IsRequired__c = curSetup.ZPAPER5__IsRequired__c;
                    prevSetup.ZPAPER5__Referred_Column__c = curSetup.ZPAPER5__Referred_Column__c;
                    prevSetup.ZPAPER5__Referred_DocType__c = curSetup.ZPAPER5__Referred_DocType__c;
                    prevSetup.ZPAPER5__Sort_Order__c = curSetup.ZPAPER5__Sort_Order__c;
                    prevSetup.ZPAPER5__ZDocument_DesignLayout__c = curSetup.ZPAPER5__ZDocument_DesignLayout__c;
                    System.debug('@@@ Updating zDocSetup with ID: ' + prevSetup.Id);
                    setupsToUpdate.add(prevSetup);
                } else {
                    curSetup.Id = null;
                    System.debug('@@@ Inserting new zDocSetup @@@');
                    setupsToInsert.add(curSetup);
                }
            }
            // we are bulk friendly!
            if (setupsToInsert.size() > 0) {
                Insert setupsToInsert;
            }
            if (setupsToUpdate.size() > 0) {
                Update setupsToUpdate;
            }
        }
    }

    private String parseFromJSON(String json, String key) {
        Integer idxBegin, idxEnd;
        idxBegin = json.indexOf('"' + key + '"');
        if (idxBegin >= 0) {
            idxBegin += key.length() + 2;
            idxBegin = json.indexOf('"', idxBegin);
            if (idxBegin > 0) {
                idxBegin++;
                idxEnd = json.indexOf('"', idxBegin);
                if (idxEnd > idxBegin) {
                    return json.substring(idxBegin, idxEnd).trim();
                }
            }
        }
        return '';
    }

    // Exporting designs to Salesforce static resource
    public void exportDesignLayout() {
        List<ZPAPER5__ZDocument_Setup__c> columnsList;
        List<ZPAPER5__ZDocument_Setup__c> typesList;
        String jsonBuffer = '';
        for (ZPAPER5__ZDocument_DesignLayout__c dLayout : [
                SELECT Id, Name,
                        ZPAPER5__Documents_ViewLink_Name__c,
                        ZPAPER5__Documents_ViewLink_URL__c,
                        ZPAPER5__Document_ViewLink_URL_Parameters__c
                FROM ZPAPER5__ZDocument_DesignLayout__c
        ]) {
            if (jsonBuffer.length() > 0) {
                jsonBuffer += '}},';
            }
            jsonBuffer += '{"layout": {"id":"' + dLayout.Id + '","Name":"' + dLayout.Name +
                    '","ZPAPER5__Documents_ViewLink_Name__c":"' + (null != dLayout.ZPAPER5__Documents_ViewLink_Name__c ? dLayout.ZPAPER5__Documents_ViewLink_Name__c : '') +
                    '","ZPAPER5__Documents_ViewLink_URL__c":"' + (null != dLayout.ZPAPER5__Documents_ViewLink_URL__c ? dLayout.ZPAPER5__Documents_ViewLink_URL__c : '') +
                    '","ZPAPER5__Document_ViewLink_URL_Parameters__c":"' + (null != dLayout.ZPAPER5__Document_ViewLink_URL_Parameters__c ? dLayout.ZPAPER5__Document_ViewLink_URL_Parameters__c : '') + '"';
//            columnsList = [Select Id, Name, RecordType, Sort_Order__c, IsRequired__c, ActualColumn_Name__c From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Columns' AND ZPAPER5__ZDocument_DesignLayout__c =:dLayout.Id ORDER BY Sort_Order__c NULLS LAST];
            columnsList = [
                    Select Id, Name, RecordTypeId,
                            ZPAPER5__ActualColumn_Name__c,
                            ZPAPER5__IsRequired__c,
                            ZPAPER5__Referred_Column__c,
                            ZPAPER5__Referred_DocType__c,
                            ZPAPER5__Sort_Order__c,
                            ZPAPER5__ZDocument_DesignLayout__c
                    From ZPAPER5__ZDocument_Setup__c
                    WHERE RecordType.DeveloperName = 'zDocument_Columns' AND ZPAPER5__ZDocument_DesignLayout__c = :dLayout.Id
                    ORDER BY Sort_Order__c NULLS LAST
            ];
            if (columnsList.size() > 0) {
                jsonBuffer += ',"zDocument_Columns":[';
                Integer count = 0;
                for (ZPAPER5__ZDocument_Setup__c setup : columnsList) {
                    if (count > 0) {
                        jsonBuffer += ',';
                    }
                    count++;
                    jsonBuffer += JSON.serialize(setup);
                }
                jsonBuffer += ']';
            }
//            typesList = [Select Id, Name, Sort_Order__c, IsRequired__c, Referred_DocType__c From ZPAPER5__ZDocument_Setup__c WHERE RecordType.DeveloperName = 'zDocument_Types' AND ZPAPER5__ZDocument_DesignLayout__c =:dLayout.Id ORDER BY Sort_Order__c NULLS LAST];
            typesList = [
                    Select Id, Name, RecordTypeId,
                            ZPAPER5__ActualColumn_Name__c,
                            ZPAPER5__IsRequired__c,
                            ZPAPER5__Referred_Column__c,
                            ZPAPER5__Referred_DocType__c,
                            ZPAPER5__Sort_Order__c,
                            ZPAPER5__ZDocument_DesignLayout__c
                    From ZPAPER5__ZDocument_Setup__c
                    WHERE RecordType.DeveloperName = 'zDocument_Types' AND ZPAPER5__ZDocument_DesignLayout__c = :dLayout.Id
                    ORDER BY Sort_Order__c NULLS LAST
            ];
            if (typesList.size() > 0) {
                jsonBuffer += ',"zDocument_Types":[';
                Integer count = 0;
                for (ZPAPER5__ZDocument_Setup__c typeSetup : typesList) {
                    if (count > 0) {
                        jsonBuffer += ',';
                    }
                    count++;
                    jsonBuffer += JSON.serialize(typeSetup);
                }
                jsonBuffer += ']';
            }
        }
        jsonBuffer = '[' + jsonBuffer + '}}]';
        MetadataService.MetadataPort service = createService();
        MetadataService.StaticResource staticResource = new MetadataService.StaticResource();
        staticResource.fullName = 'zDocSetup_json';
        staticResource.contentType = 'json';
        staticResource.cacheControl = 'public';
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n@@ 1.0 jsonBuffer = ' + jsonBuffer + '\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        staticResource.content = EncodingUtil.base64Encode(Blob.valueOf(jsonBuffer));
        List<MetadataService.SaveResult> results;
        //CRN190502 Case 51310 Determine if we should create or update the static resource
        List<StaticResource> curResources = [SELECT Id,Name from StaticResource where Name = :staticResource.fullName];
        System.debug('Does static resource named ' + staticResource.fullName + ' exist? ' + (curResources.size() > 0 ? 'YES' : 'NO'));
        if (curResources.size() > 0) {
            results = service.updateMetadata(new List<MetadataService.Metadata>{
                    staticResource
            });
        }
        else {
            results = service.createMetadata(new List<MetadataService.Metadata>{
                    staticResource
            });
        }
        if (null != results) {
            handleSaveResults(results[0]);
        }
    }

    // Initializing the new ZPAPER5__ZDocument_DesignLayout__c
    public void deleteDesignLayout() {
        System.debug('*****delete***' + selectedDesignLayout);
        Delete [SELECT id, Name FROM ZPAPER5__ZDocument_Setup__c WHERE ZPAPER5__ZDocument_DesignLayout__c = :selectedDesignLayout];
        delete [select id FROM ZPAPER5__ZDocument_DesignLayout__c WHERE Id = :selectedDesignLayout];
        setNewDesignLayout();
        getZDocumentSetups();
        getDesignLayouts();
    }

    /* Method : saveDesignLayout
     * Parameters : N/A
     * Return Type : Void
     * Description : Inserting new Design Layout / Updating old Design Layout.
     */
    public void saveDesignLayout() {
        try {
            // Modified by Pra.V after Beta 1 release 7/7/17. Replaced zObj --> String.isNotBlank for Documents_ViewLink_URL__c
            if (String.isNotBlank(DesignLayout.ZPAPER5__Documents_ViewLink_URL__c) && String.isNotBlank(DesignLayout.Document_ViewLink_URL_Parameters__c)) {
                DesignLayout.ZPAPER5__Documents_ViewLink_URL__c = DesignLayout.ZPAPER5__Documents_ViewLink_URL__c.substringBefore('?');
                String[] paramList = DesignLayout.Document_ViewLink_URL_Parameters__c.split(';');
                for (Integer i = 0; i < paramList.size(); i++) {
                    if (i == 0)
                        DesignLayout.ZPAPER5__Documents_ViewLink_URL__c += '?' + paramList[i];
                    if (i == 1)
                        DesignLayout.ZPAPER5__Documents_ViewLink_URL__c += '&' + paramList[i];
                    if (i == 2)
                        DesignLayout.ZPAPER5__Documents_ViewLink_URL__c += '&' + paramList[i];
                }
            }
            Upsert DesignLayout;
            if (selectedProperty.equals('NewDesign')) {
                List<ZPAPER5__ZDocument_Setup__c> newZDocSetupList = new List<ZPAPER5__ZDocument_Setup__c>();
                for (ZPAPER5__ZDocument_Setup__c setup : [Select Id,Name,Sort_Order__c, IsRequired__c, Referred_DocType__c, ActualColumn_Name__c, ZPAPER5__ZDocument_DesignLayout__c From ZPAPER5__ZDocument_Setup__c WHERE ZDocument_DesignLayout__r.Name = 'Default Layout' AND RecordType.DeveloperName = 'zDocument_Columns']) {
                    ZPAPER5__ZDocument_Setup__c newSetup = setup.clone(false, true, false, false);
                    newSetup.ZPAPER5__ZDocument_DesignLayout__c = DesignLayout.id;
                    newZDocSetupList.add(newSetup);
                }

                Id rtID = Schema.SObjectType.ZPAPER5__ZDocument_Setup__c.getRecordTypeInfosByName().get('zDocument Types').getRecordTypeId();
                for (String str : getDocTypesFromZStack()) {
                    ZPAPER5__ZDocument_Setup__c setup = new ZPAPER5__ZDocument_Setup__c(Name = str, RecordTypeId = rtID, ZPAPER5__ZDocument_DesignLayout__c = DesignLayout.id);
                    newZDocSetupList.add(setup);
                }
                Insert newZDocSetupList;
            }
            //CRN180405 Now save the action buttons if needed
            if (NULL != actionButtonsJSON && actionButtonsJSON.length() > 0) {
                System.debug('### actionButtonsJSON = ' + actionButtonsJSON);
                List<ZPAPER5__zPaper_Document_Set_Action__c> actions =
                        (List<ZPAPER5__zPaper_Document_Set_Action__c>)JSON.deserialize(actionButtonsJSON, List<ZPAPER5__zPaper_Document_Set_Action__c>.class);
                for (ZPAPER5__zPaper_Document_Set_Action__c action : actions) {
                    action.zDocument_Design_Layout__c = DesignLayout.Id;
                    if (NULL == action.Id) {
                        Insert action;
                    }
                    else {
                        Update action;
                    }
                    System.debug('$$$ action = ' + action);
                }
                actionButtonsJSON = JSON.serialize(actions);
            }

            setNewDesignLayout();
            selectedDesignLayout = DesignLayout.id;
            getZDocumentSetups();
            getDesignLayouts();
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**saveDesignLayout*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    /* Method : getDocTypesFromZStack
    * Parameters : N/A
    * Return Type : String
    * Description : get Document types from zStack Object.
    */
    @TestVisible
    private Set<String> getDocTypesFromZStack() {
        String pkDocTypes = '';
        Schema.DescribeFieldResult fieldResult = ZPAPER__zStack__c.ZPAPER__faxType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f : ple) {
            pkDocTypes += f.getLabel() + ',';
        }

        String[] allTypes = pkDocTypes.split(',');
        Set<String> DocTypes = new Set<String>();
        for (Integer j = 0; j < allTypes.size(); j++) {
            //CRN180724 Case #48880 Don't only pull the prefix (part before the colon) because it prevents matching of the chosen doc type from the picklist.
            docTypes.add(allTypes[j]);
//            String[] parts = allTypes[j].split(':');
            //DocTypes += parts[0]+',';
//            docTypes.add(parts[0]);
        }
        return docTypes;
    }

    /* Method : refreshDocTypes
    * Parameters : N/A
    * Return Type : Void
    * Description : sync Document types from zStack Object with design layout doc types.
    */
    public void refreshDocTypes() {
        try {
            Set<String> docTypeSet = new Set<String>();
            Set<String> removeDocTypeSet = new Set<String>();

            docTypeSet = getDocTypesFromZStack();
            removeDocTypeSet.addAll(docTypeSet);

            Set<String> selectedDocTypeSet = new Set<String>();
            for (SelectOption so : selectedZDocsTypes) {
                selectedDocTypeSet.add(so.getLabel());
            }
            List<ZPAPER5__ZDocument_Setup__c> deleteList = new List<ZPAPER5__ZDocument_Setup__c>();

            for (ZPAPER5__ZDocument_Setup__c zdc : zDocTypesMap.values()) {
                removeDocTypeSet.remove(zdc.name);
                if (!docTypeSet.contains(zdc.Name) && !selectedDocTypeSet.contains(zdc.name))
                    deleteList.add(zdc);
            }

            delete deleteList;

            Id rtID = Schema.SObjectType.ZPAPER5__ZDocument_Setup__c.getRecordTypeInfosByName().get('zDocument Types').getRecordTypeId();

            List<ZPAPER5__ZDocument_Setup__c> newDocSetupList = new List<ZPAPER5__ZDocument_Setup__c>();
            for (String str : removeDocTypeSet) {
                ZPAPER5__ZDocument_Setup__c setup = new ZPAPER5__ZDocument_Setup__c(Name = str, RecordTypeId = rtID, ZPAPER5__ZDocument_DesignLayout__c = selectedDesignLayout);
                newDocSetupList.add(setup);
            }
            insert newDocSetUpList;
            getZDocumentSetups();
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**refreshDocTypes*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    /* Method : getColumnsFromZStack
     * Parameters : N/A
     * Return Type : String
     * Description : get Document columns from zStack Object.
     */
    @TestVisible
    private Set<String> getColumnsFromZStack() {
        Set<String> stageSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = ZPAPER__zStack__c.ZPAPER__Stage__c.getDescribe();
        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            stageSet.add(f.getLabel());
        }
        return stageSet;
    }

    /* Method : refreshColumns
     * Parameters : N/A
     * Return Type : Void
     * Description : sync Stages/columns from zStack Object with design layout doc types.
     */
    public void refreshColumns() {
        try {
            Set<String> columnsSet = getColumnsFromZStack();
            if (columnsSet != null && columnsSet.Size() > 0) {
                Id rtID = Schema.SObjectType.ZPAPER5__ZDocument_Setup__c.getRecordTypeInfosByName().get('zDocument Columns').getRecordTypeId();
                Delete [SELECT id FROM ZPAPER5__ZDocument_Setup__c WHERE RecordTypeId = :rtID AND ZPAPER5__ZDocument_DesignLayout__c = :selectedDesignLayout];

                List<ZPAPER5__ZDocument_Setup__c> newColumnsSetupList = new List<ZPAPER5__ZDocument_Setup__c>();
                for (String str : columnsSet) {
                    ZPAPER5__ZDocument_Setup__c setup = new ZPAPER5__ZDocument_Setup__c(Name = str, ActualColumn_Name__c = str, RecordTypeId = rtID, ZPAPER5__ZDocument_DesignLayout__c = selectedDesignLayout);
                    newColumnsSetupList.add(setup);
                }

                // Added by Pra.V after 8/8/17 Meeting with Eric, to get below columns as dynamic from This(Properties) Page
                newColumnsSetupList.add(new ZPAPER5__ZDocument_Setup__c(Name = 'Type', ActualColumn_Name__c = 'Type', RecordTypeId = rtID, ZPAPER5__ZDocument_DesignLayout__c = selectedDesignLayout));
                newColumnsSetupList.add(new ZPAPER5__ZDocument_Setup__c(Name = 'Updated Date', ActualColumn_Name__c = 'Updated Date', RecordTypeId = rtID, ZPAPER5__ZDocument_DesignLayout__c = selectedDesignLayout));
                newColumnsSetupList.add(new ZPAPER5__ZDocument_Setup__c(Name = 'Form', ActualColumn_Name__c = 'Form', RecordTypeId = rtID, ZPAPER5__ZDocument_DesignLayout__c = selectedDesignLayout));

                insert newColumnsSetupList;
                getZDocumentSetups();
            } else {
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.INFO, 'No columns found in Stage field of Stack Object');
                ApexPages.addMessage(msg);
            }
        } catch (Exception e) {
            System.debug('****Class:**zDocumentPropertiesController****Method:**refreshDocTypes*****' + e.getMessage());
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }

    }

    /* Method : saveNewColumn
     * Parameters : N/A
     * Return Type : Void
     * Description : Inserting new column in ZPAPER5__ZDocument_Setup__c for selected design layout.
     */

    /* public void saveNewColumn(){
       try{
          Integer clmnCount = [SELECT count() FROM ZPAPER5__ZDocument_Setup__c WHERE ActualColumn_Name__c =: ZDocumentSetup.ActualColumn_Name__c AND ZPAPER5__ZDocument_DesignLayout__c =: selectedDesignLayout];
          if(clmnCount < 1){
              ZDocumentSetup.RecordTypeId = Schema.SObjectType.ZPAPER5__ZDocument_Setup__c.getRecordTypeInfosByName().get('zDocument Columns').getRecordTypeId();
              ZDocumentSetup.ZPAPER5__ZDocument_DesignLayout__c = selectedDesignLayout; 
              Insert ZDocumentSetup;
              getZDocumentSetups();
          }else{
             ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.WARNING, '"'+ZDocumentSetup.ActualColumn_Name__c+'" referred column already has been added!');
             ApexPages.addMessage(msg);
          }
        }
        catch(Exception e){         
            System.debug('****Class:**zDocumentPropertiesController****Method:**saveNewColumn*****'+e.getMessage()); 
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }  
    }
    */
    public static MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

    /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleSaveResults(MetadataService.SaveResult saveResult) {
        // Nothing to see?
        if (saveResult == null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if (saveResult.errors != null) {
            List<String> messages = new List<String>();
            messages.add(
                    (saveResult.errors.size() == 1 ? 'Error ' : 'Errors ') +
                            'occured processing component ' + saveResult.fullName + '.');
            for (MetadataService.Error error : saveResult.errors)
                messages.add(
                        error.message + ' (' + error.statusCode + ').' +
                                (error.fields != null && error.fields.size() > 0 ?
                                        ' Fields ' + String.join(error.fields, ',') + '.' : ''));
            if (messages.size() > 0)
                throw new MetadataServiceException(String.join(messages, ' '));
        }
        if (!saveResult.success)
            throw new MetadataServiceException('Request failed with no specified error.');
    }
    public class MetadataServiceException extends Exception {
    }

}