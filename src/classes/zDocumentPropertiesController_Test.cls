/*******************************************************************************************
* @Author      : Prathyusha Vasireddy
* @Date        : 6/27/2017
* @Description : The zDocumentPropertiesController_test is  Test Class for zDocumentPropertiesController.
* Modification Logs:
* -----------------------------------------------------------------------------------
* Developer                			 Date                    Description
* ---------------           		-----------             -------------------------
* Prathyusha Vasireddy	            06/27/2017              Original Version
*********************************************************************************************/
@IsTest
private class zDocumentPropertiesController_Test {
   @isTest
    static void TestUnitTest(){
        ZDocument_DesignLayout__c design = new ZDocument_DesignLayout__c(Name = 'Case Layout');
        Insert design;
        ZDocument_DesignLayout__c design1 = new ZDocument_DesignLayout__c(Name = 'Default Layout');
        Insert design1;
        
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
        setup5.ZDocument_DesignLayout__c = design1.id;
        setup5.RecordTypeId = RTId;
        setup5.Referred_Column__c = 'Rejected';
        setup5.Sort_Order__c = 3;
        setup5.IsRequired__c = true;
        zDocSetList.add(setup5);
        
        Insert zDocSetList;
        Test.startTest();
        zDocumentPropertiesController propCntrl = new zDocumentPropertiesController();
        propCntrl.setOptions(new SelectOption[]{new SelectOption('Indexed','Indexed'), new SelectOption('Updated','Updated')}, 'Updated');
        System.debug(''+propCntrl.leftOptionsHidden);
        System.debug(''+propCntrl.rightOptionsHidden);
        propCntrl.selectedProperty = setup1.id;
        propCntrl.editColumnName();
        propCntrl.selectedProperty = setup1.id;
        propCntrl.updateColumnName();        
        propCntrl.selectedZDocsClmns = new SelectOption[]{new SelectOption('Indexed','Indexed')};
        propCntrl.availableZDocsClmns = new SelectOption[]{new SelectOption('Updated','Updated')};
        propCntrl.saveColumnProperties();
        propCntrl.selectedZDocsTypes = new SelectOption[]{new SelectOption('HDOT','HDOT')};
        propCntrl.availableZDocsTypes = new SelectOption[]{new SelectOption('REFR','REFR')};
        propCntrl.saveDocTypeProperties();
        propCntrl.selectedDesignLayout = design.id;
        propCntrl.refreshDocTypes();
        propCntrl.refreshColumns();
        propCntrl.getDesignLayout();
        propCntrl.DesignLayout = new ZDocument_DesignLayout__c(Name = 'test Layout', Document_ViewLink_URL_Parameters__c = 'Test;test;test', Documents_ViewLink_URL__c='test');
        propCntrl.selectedProperty = 'NewDesign';
        propCntrl.saveDesignLayout();
        propCntrl.ZDocumentSetup = new ZDocument_Setup__c(Name = 'Verified', Referred_Column__c = 'Verified');
        //propCntrl.saveNewColumn();
        propCntrl.ZDocumentSetup = new ZDocument_Setup__c(Name = 'Verified', Referred_Column__c = 'Verified');
        //propCntrl.saveNewColumn();
        propCntrl.selectedProperty = setup1.id;
        propCntrl.deleteColumn();
        System.debug(''+propCntrl.leftOptions);
        System.debug(''+propCntrl.rightOptions);
        propCntrl.zDocumentSetup = new ZDocument_Setup__c();
        propCntrl.updateColumnName();
        propCntrl.selectedProperty = 'sad45k56';
        propCntrl.deleteColumn();
        propCntrl.DesignLayout = null;
        propCntrl.saveDesignLayout();
        propCntrl.selectedDesignLayout = setup1.id;
       // propCntrl.saveNewColumn();
        propCntrl.selectedDesignLayout = design.id;
        propCntrl.refreshDocTypes();
        propCntrl.selectedDesignLayout = design.id;
        
        Test.stopTest();
    }    
    
    @isTest
    static void TestUnitTest1(){
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        MetadataService.Error error = new MetadataService.Error();
        error.message = 'Test Error Message!';
        MetadataService.SaveResult SaveResult = new MetadataService.SaveResult();
        SaveResult.fullName = 'Test';
        SaveResult.success = false;
        SaveResult.errors = new MetadataService.Error[]{error};
        try{
        zDocumentPropertiesController.handleSaveResults(SaveResult);
        }catch(Exception e){}
        Test.stopTest();        
    }

    @isTest
    static void testExportImport() {
        List<RecordType> docSetupTypes = [Select Name, Id, DeveloperName From RecordType where sObjectType='ZPAPER5__ZDocument_Setup__c' and isActive=true];
        RecordType typesRecordType = null;
        RecordType colsRecordType = null;
        for (RecordType recordType : docSetupTypes) {
            if ('zDocument_Types' == recordType.DeveloperName)      { typesRecordType = recordType; }
            if ('zDocument_Columns' == recordType.DeveloperName)    { colsRecordType = recordType; }
        }
        ZPAPER5__ZDocument_DesignLayout__c design1 = new ZPAPER5__ZDocument_DesignLayout__c(
                Name = 'Incoming Case Design',
                ZPAPER5__Documents_ViewLink_Name__c = 'Foo',
                ZPAPER5__Documents_ViewLink_URL__c = 'https://foo.com/hello',
                ZPAPER5__Document_ViewLink_URL_Parameters__c = 'test=true'
        );
        insert design1;
        ZPAPER5__ZDocument_Setup__c setup1 = new ZPAPER5__ZDocument_Setup__c(
                Name = 'setup1',
                RecordTypeId = colsRecordType.Id,
                ZPAPER5__ActualColumn_Name__c = 'ColName1',
                ZPAPER5__IsRequired__c = true,
                ZPAPER5__Referred_Column__c = 'Delivered',
                ZPAPER5__Referred_DocType__c = null,
                ZPAPER5__Sort_Order__c = 1,
                ZPAPER5__ZDocument_DesignLayout__c = design1.Id
        );
        insert setup1;
        ZPAPER5__ZDocument_Setup__c setup2 = new ZPAPER5__ZDocument_Setup__c(
                Name = 'setup2',
                RecordTypeId = colsRecordType.Id,
                ZPAPER5__ActualColumn_Name__c = 'ColName2',
                ZPAPER5__IsRequired__c = true,
                ZPAPER5__Referred_Column__c = 'Indexed',
                ZPAPER5__Referred_DocType__c = null,
                ZPAPER5__Sort_Order__c = 2,
                ZPAPER5__ZDocument_DesignLayout__c = design1.Id
        );
        insert setup2;
        ZPAPER5__ZDocument_Setup__c setup3 = new ZPAPER5__ZDocument_Setup__c(
                Name = 'setup3',
                RecordTypeId = typesRecordType.Id,
                ZPAPER5__ActualColumn_Name__c = 'ColName3',
                ZPAPER5__IsRequired__c = true,
                ZPAPER5__Referred_Column__c = null,
                ZPAPER5__Referred_DocType__c = 'ENRLC',
                ZPAPER5__Sort_Order__c = 1,
                ZPAPER5__ZDocument_DesignLayout__c = design1.Id
        );
        insert setup3;

        ZPAPER5__ZDocument_DesignLayout__c design1b = new ZPAPER5__ZDocument_DesignLayout__c(
                Name = 'Incoming Account Design',
                ZPAPER5__Documents_ViewLink_Name__c = 'Bar',
                ZPAPER5__Documents_ViewLink_URL__c = 'https://bar.com/hello',
                ZPAPER5__Document_ViewLink_URL_Parameters__c = 'test=false'
        );
        insert design1b;
        ZPAPER5__ZDocument_Setup__c setup1b = new ZPAPER5__ZDocument_Setup__c(
                Name = 'setup1b',
                RecordTypeId = colsRecordType.Id,
                ZPAPER5__ActualColumn_Name__c = 'ColName1b',
                ZPAPER5__IsRequired__c = true,
                ZPAPER5__Referred_Column__c = 'Delivered',
                ZPAPER5__Referred_DocType__c = null,
                ZPAPER5__Sort_Order__c = 1,
                ZPAPER5__ZDocument_DesignLayout__c = design1b.Id
        );
        insert setup1b;
        ZPAPER5__ZDocument_Setup__c setup2b = new ZPAPER5__ZDocument_Setup__c(
                Name = 'setup2b',
                RecordTypeId = colsRecordType.Id,
                ZPAPER5__ActualColumn_Name__c = 'ColName2b',
                ZPAPER5__IsRequired__c = true,
                ZPAPER5__Referred_Column__c = null,
                ZPAPER5__Referred_DocType__c = 'REFR',
                ZPAPER5__Sort_Order__c = 1,
                ZPAPER5__ZDocument_DesignLayout__c = design1b.Id
        );
        insert setup2b;
        ZPAPER5__ZDocument_Setup__c setup3b = new ZPAPER5__ZDocument_Setup__c(
                Name = 'setup3b',
                RecordTypeId = typesRecordType.Id,
                ZPAPER5__ActualColumn_Name__c = 'ColName3b',
                ZPAPER5__IsRequired__c = true,
                ZPAPER5__Referred_Column__c = null,
                ZPAPER5__Referred_DocType__c = 'ENRLC',
                ZPAPER5__Sort_Order__c = 2,
                ZPAPER5__ZDocument_DesignLayout__c = design1b.Id
        );
        insert setup3b;
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        zDocumentPropertiesController propCntrl = new zDocumentPropertiesController();
        propCntrl.exportDesignLayout();
//        design1.Name = 'Updated by Test';
//        update design1;
//        setup1b.ZPAPER5__ActualColumn_Name__c = 'Updated by Test';
//        update setup1b;
        propCntrl.importDesignLayout();
        // make sure that the import created expected objects
        List<ZPAPER5__ZDocument_DesignLayout__c> designs =
            [Select Id, Name ,ZPAPER5__Documents_ViewLink_URL__c from ZPAPER5__ZDocument_DesignLayout__c where Name = 'Test Import Layout'];
//        design1 = [Select Id, Name ,ZPAPER5__Documents_ViewLink_URL__c from ZPAPER5__ZDocument_DesignLayout__c where Name = 'Test Import Layout'];
        if (designs.size() > 0) { design1 = designs.get(0); }
        List<ZPAPER5__ZDocument_Setup__c> setups =
            [Select Id, Name, ZPAPER5__ActualColumn_Name__c from ZPAPER5__ZDocument_Setup__c where Name = 'Test Discovered'];
//        setup1b = [Select Id, Name, ZPAPER5__ActualColumn_Name__c from ZPAPER5__ZDocument_Setup__c where Name = 'Test Discovered'];
        if (setups.size() > 0) { setup1b = setups.get(0); }
        System.assertEquals(design1.ZPAPER5__Documents_ViewLink_URL__c, 'importtest.salesforce.com?Record Id');
        System.assertEquals(setup1b.ZPAPER5__ActualColumn_Name__c, 'Test Doc Setup');
        // Finally, update some values in the setup and design records and re-import and make sure the updates are over-written by the import.
        // We cannot run this test since we can't do any DML stuff before a call to a mock (the metadata service is mocked)
        // Thanks Saleforce for making it impossible to test updates.
//        design1.ZPAPER5__Documents_ViewLink_URL__c = 'updatedtest.salesforce.com';
//        Update design1;
//        setup1b.ZPAPER5__ActualColumn_Name__c = 'Upd Doc Setup';
//        Update setup1b;
//        System.assertEquals(design1.ZPAPER5__Documents_ViewLink_URL__c, 'updatedtest.salesforce.com');
//        System.assertEquals(setup1b.ZPAPER5__ActualColumn_Name__c, 'Upd Doc Setup');
//        propCntrl.importDesignLayout();
//        design1 = [Select Id, Name ,ZPAPER5__Documents_ViewLink_URL__c from ZPAPER5__ZDocument_DesignLayout__c where Id = :design1.Id];
//        setup1b = [Select Id, Name, ZPAPER5__ActualColumn_Name__c from ZPAPER5__ZDocument_Setup__c where Id = :setup1b.Id];
//        System.assertEquals(design1.ZPAPER5__Documents_ViewLink_URL__c, 'importtest.salesforce.com?Record Id');
//        System.assertEquals(setup1b.ZPAPER5__ActualColumn_Name__c, 'Test Doc Setup');
        Test.stopTest();
    }
    
    private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			if(request instanceof MetadataService.retrieve_element)
				response.put('response_x', new MetadataService.retrieveResponse_element());
			else if(request instanceof MetadataService.checkDeployStatus_element)
				response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
			else if(request instanceof MetadataService.listMetadata_element)
				response.put('response_x', new MetadataService.listMetadataResponse_element());
			else if(request instanceof MetadataService.checkRetrieveStatus_element)
				response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
			else if(request instanceof MetadataService.describeMetadata_element)
				response.put('response_x', new MetadataService.describeMetadataResponse_element());
			else if(request instanceof MetadataService.deploy_element)
				response.put('response_x', new MetadataService.deployResponse_element());
            else if(request instanceof MetadataService.updateMetadata_element)
                response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof MetadataService.renameMetadata_element)
                response.put('response_x', new MetadataService.renameMetadataResponse_element());
            else if(request instanceof  MetadataService.cancelDeploy_element)
                response.put('response_x', new MetadataService.cancelDeployResponse_element());
            else if(request instanceof  MetadataService.deleteMetadata_element)
                response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            else if(request instanceof  MetadataService.upsertMetadata_element)
                response.put('response_x', new MetadataService.upsertMetadataResponse_element());
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());
            else if(request instanceof  MetadataService.deployRecentValidation_element)
                response.put('response_x', new MetadataService.deployRecentValidationResponse_element());
            else if(request instanceof MetadataService.describeValueType_element)
                response.put('response_x', new MetadataService.describeValueTypeResponse_element());
            else if(request instanceof MetadataService.checkRetrieveStatus_element)
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
            else if(request instanceof MetadataService.readMetadata_element) {
//                response.put('response_x', new MetadataService.IReadResponseElement());
                MetadataService.readStaticResourceResponse_element ele = new MetadataService.readStaticResourceResponse_element();
                MetadataService.ReadStaticResourceResult result = new MetadataService.ReadStaticResourceResult();
                MetadataService.StaticResource staticResource = new MetadataService.StaticResource();
                result.records = new MetadataService.StaticResource[1];
                result.records[0] = staticResource;
                staticResource.fullName = 'zDocSetup_json';
                String jsonBuffer = testInputJSON;
                staticResource.content = EncodingUtil.base64Encode(Blob.valueOf(jsonBuffer));
                ele.result = result;
                response.put('response_x', ele);
            }
			return;
		}
	}

    private static String testInputJSON =
        '[' +
        '  {' +
        '    "layout": {' +
        '      "id": "a0841000008UmowAAC",' +
        '      "Name": "Test Import Layout",' +
        '      "ZPAPER5__Documents_ViewLink_Name__c": "",' +
        '      "ZPAPER5__Documents_ViewLink_URL__c": "importtest.salesforce.com?Record Id",' +
        '      "ZPAPER5__Document_ViewLink_URL_Parameters__c": "Record Id",' +
        '      "zDocument_Columns": [' +
        '        {' +
        '          "attributes": {' +
        '            "type": "ZPAPER5__ZDocument_Setup__c",' +
        '            "url": "/services/data/v40.0/sobjects/ZPAPER5__ZDocument_Setup__c/a074100000GLSPYAA5"' +
        '          },' +
        '          "Id": "a074100000GLSPYAA5",' +
        '          "Name": "Test Discovered",' +
        '          "RecordTypeId": "01241000001IIG2AAO",' +
        '          "ZPAPER5__ActualColumn_Name__c": "Test Doc Setup",' +
        '          "ZPAPER5__IsRequired__c": true,' +
        '          "ZPAPER5__Sort_Order__c": 1,' +
        '          "ZPAPER5__ZDocument_DesignLayout__c": "a0841000008UmowAAC"' +
        '        }' +
        '      ],' +
        '      "zDocument_Types": [' +
        '        {' +
        '          "attributes": {' +
        '            "type": "ZPAPER5__ZDocument_Setup__c",' +
        '            "url": "/services/data/v40.0/sobjects/ZPAPER5__ZDocument_Setup__c/a074100000G3Rr5AAF"' +
        '          },' +
        '          "Id": "a074100000G3Rr5AAF",' +
        '          "Name": "Test Document Type",' +
        '          "RecordTypeId": "01241000001IIG7AAO",' +
        '          "ZPAPER5__IsRequired__c": true,' +
        '          "ZPAPER5__Sort_Order__c": 1,' +
        '          "ZPAPER5__ZDocument_DesignLayout__c": "a0841000008UmowAAC"' +
        '        }' +
        '      ]' +
        '    }' +
        '  }' +
        ']';
}