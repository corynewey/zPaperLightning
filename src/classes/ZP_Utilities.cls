/**
 * zPaper Utilities. Contains utility methods that allow partner code to work with zPaper services.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         10/24/2017    Creation
 * Cory         01/17/2018    Made methods non-static so that we can implement interfaces that our partners can code to
 */
global with sharing class ZP_Utilities implements ZP_PartnerInterface.Partner, ZP_PartnerInterfaceSyncAsync.PartnerSyncAsync {

    /**
     * Method split
     *
     * @param zpaperDBId            database Id for document
     * @param pageRange             pages to split
     * @param attachToSObjectId     attach split-off pages to this SObject
     */
    global void split(String zpaperDBId, String pageRange, String attachToSObjectId) {
        ZP_RulesEngineEvent event = new ZP_RulesEngineEvent(zpaperDBId, ZP_Constants.EVENT_FIELD_SPLIT_PAGES, pageRange, attachToSObjectId, null);
        invokeRulesEngine(event.getFutureSafeEventData());
    }

    /**
     * Send a document (fax, email, etc.) via zPaper services.
     *
     * @param objectId      Salesforce object Id
     * @param templateId    zPaper template Id
     * @param recipients    comma-separated list of email addresses, fax numbers, etc
     * @param sendToCurrentUser true if an email should also be sent to the current user
     */
    global void send(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser) {
        sendDocument(objectId, templateId, recipients, sendToCurrentUser);
    }

    /**
     * Send a zPaper action request to invoke the zPaper Rules Engine.
     *
     * @param eventData     name/value and other data required for Rules Engine invocation
     */
    global void invoke(ZP_RulesEngineEvent eventData) {
        invokeRulesEngine(eventData.getFutureSafeEventData());  // martial the object to name/value pairs
    }

    /**
     * Method split
     *
     * @param zpaperDBId            database Id for document
     * @param pageRange             pages to split
     * @param attachToSObjectId     attach split-off pages to this SObject
     */
    global void splitAsync(String zpaperDBId, String pageRange, String attachToSObjectId) {
        ZP_RulesEngineEvent event = new ZP_RulesEngineEvent(zpaperDBId, ZP_Constants.EVENT_FIELD_SPLIT_PAGES, pageRange, attachToSObjectId, null);
        invokeRulesEngine(event.getFutureSafeEventData());
    }

    /**
     * Send a document (fax, email, etc.) via zPaper services.
     *
     * @param objectId      Salesforce object Id
     * @param templateId    zPaper template Id
     * @param recipients    comma-separated list of email addresses, fax numbers, etc
     * @param sendToCurrentUser true if an email should also be sent to the current user
     */
    global void sendAsync(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser) {
        sendDocument(objectId, templateId, recipients, sendToCurrentUser);
    }

    /**
     * Send a zPaper action request to invoke the zPaper Rules Engine.
     *
     * @param eventData     name/value and other data required for Rules Engine invocation
     */
    global void invokeAsync(ZP_RulesEngineEvent eventData) {
        invokeRulesEngine(eventData.getFutureSafeEventData());  // martial the object to name/value pairs
    }

    /**
     * Send a zPaper request to pull data via the zPaper Rest API, in a @future method
     * NOTE: this method probably won't have much use since pulling data asynchronously isn't
     * very useful without a callback and Salesforce @future methods don't support the callback.
     * However, I'm putting it here to preserve symmetry between the sync/async calls and also
     * because once this interface has been deployed in a managed package, we won't be able to
     * add new methods.
     *
     * @param httpMethod        method to use (GET, POST, etc)
     * @param servicePath       path to service request
     * @param pathParameters    parameters that should be added to the path
     * @param queryParameters   parameters that should be added to the query String
     */
    global void getDataAsync(String httpMethod, String servicePath, String pathParameters, String queryParameters) {
        invokeService(httpMethod, servicePath, pathParameters, queryParameters);
    }

    /**
     * Send a document (fax, email, etc.) via zPaper services.
     *
     * @param objectId      Salesforce object Id
     * @param templateId    zPaper template Id
     * @param recipients    comma-separated list of email addresses, fax numbers, etc
     * @param sendToCurrentUser true if an email should also be sent to the current user
     */
    global ZP_Result sendSynchronous(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser) {
        return doSendDocument(objectId, templateId, recipients, sendToCurrentUser);
    }

    /**
     * Split pages off of the document indicated by the zpaperDBId and attach to Salesforc
     * object indicated by attachToSObjectId
     *
     * @param zpaperDBId            zPaper database Id of document to split
     * @param pageRange             range of pages to split off
     * @param attachToSObjectId     Id of Salesforce to attach the split-off pages to
     */
    global ZP_Result splitSynchronous(String zpaperDBId, String pageRange, String attachToSObjectId) {
        ZP_RulesEngineEvent event = new ZP_RulesEngineEvent(zpaperDBId, ZP_Constants.EVENT_FIELD_SPLIT_PAGES, pageRange, attachToSObjectId, null);
        return doInvokeRulesEngine(event.getFutureSafeEventData());
    }

    /**
     * Send a zPaper action request to invoke the zPaper Rules Engine.
     *
     * @param eventData     name/value and other data required for Rules Engine invocation
     */
    global ZP_Result invokeSynchronous(ZP_RulesEngineEvent eventData) {
        return doInvokeRulesEngine(eventData.getFutureSafeEventData());
    }

    /**
     * Send a zPaper request to pull data via the zPaper Rest API.
     *
     * @param httpMethod        method to use (GET, POST, etc)
     * @param servicePath       path to service request
     * @param pathParameters    parameters that should be added to the path
     * @param queryParameters   parameters that should be added to the query String
     */
    global ZP_Result getDataSynchronous(String httpMethod, String servicePath, String pathParameters, String queryParameters) {
        return doInvokeService(httpMethod, servicePath, pathParameters, queryParameters);
    }

    /**
     *
     * Send a fax or email. NOTE: This requires @future otherwise we get an error
     * that says: "System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out".
     * We can't make an outbound Rest call after we have made a call to create/update an object.
     *
     * @param objectId
     * @param templateId
     * @param recipients
     * @param sendToCurrentUser
     */
    @future(callout=true)
    private static void sendDocument(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser) {
        doSendDocument(objectId, templateId, recipients, sendToCurrentUser);
    }

    private static ZP_Result doSendDocument(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser) {
        // Sending the letters/fax via SendFax.
        String sfSession = UserInfo.getSessionId();
        string orgId = UserInfo.getOrganizationId();
        String userName = UserInfo.getUserName().replace('+', '%2B');   // + characters get filtered by http escaping
        String sfServer = URL.getSalesforceBaseUrl().getHost();

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

        if (null != recipients && recipients.length() > 0) {
            if (sendToCurrentUser) {
                recipients += ',' + UserInfo.getUserEmail();
            }

            String endpoint = 'https://' + zpServer +
//                    '/v1/kb/jsp/SF_sendFax.jsp?SFuser=' + userName +
                    '/kb/jsp/SF_sendFax.jsp?SFuser=' + userName +
                    '&SFsession=' + sfSession + '&SFserver=' + sfServer + '&SForg=' + orgId +
                    '&coverID=' + templateId + '&SFtype=Case&SFids=' + objectId +
                    '&ContactFax=' + recipients + '&zPaper=1220';    //CRN180518 getting around out-dated validation
            System.debug('zPaper: Send Fax/Email: ' + endpoint);

            httpResponse response;
            try {
                String httpMethod = 'GET';
                response = ZP_Callout.callout(httpMethod, endpoint, null, null);
                if (response != NULL && response.getStatus() == 'OK') {
                    System.debug('@@@ eLetter successfully faxed/emailed.');
                    return new ZP_Result(true, 'Letter successfully faxed/emailed');
                }
            }
            catch (Exception ex) {
                return new ZP_Result(false, ex.getMessage());
            }
        }
        return new ZP_Result(false, 'Unknown error occurred');
    }

    /**
     * Method: invokeRulesEngine
     *
     * Send an event to the zPaper Rules engine. NOTE: This requires @future otherwise we get an error
     * that says: "System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out".
     * We can't make an outbound Rest call after we have made a call to create/update an object.
     *
     * @param event         event to send
     * @param sfUsername    the username for the current Salesforce user
     * @param sfServer      the Salesforce server host URL
     * @param sfSession     the current Salesforce session Id
     */
    @future(callout=true)
    private static void invokeRulesEngine(Map<String,String> eventData) {
        doInvokeRulesEngine(eventData);
    }

    private static ZP_Result doInvokeRulesEngine(Map<String,String> eventData) {
        String sfServer = URL.getSalesforceBaseUrl().getHost();
        String sfUsername = UserInfo.getUserName().replace('+', '%2B');   // + characters get filtered by http escaping
        String sfSession = UserInfo.getSessionId();
        ZP_RulesEngineEvent event = new ZP_RulesEngineEvent(eventData);
        String sfOrg = UserInfo.getOrganizationId();
        System.debug('@@@@@ sfOrg = ' + sfOrg);
        // Pull API server from custom settings, defaulting to api.zpaper.com
        String zpServer = 'api.zpaper.com';    // single api point for all service calls
//        List<ZPAPER5__ZpaperConfig__c> lightnigConfigs = ZPAPER5__ZpaperConfig__c.getAll().values();
//        String zpServer = null;
//        if (lightnigConfigs.size() > 0) {
//            zpServer = lightnigConfigs[0].ZPAPER5__PartnerUrl__c;
//        }
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

        String strExtraParms = '';
        if (null != event.getSObjectId()) { strExtraParms += 'sfID=' + event.getSObjectId(); }
        Map<String,String> extraParms = event.getParameters();
        if (null != extraParms && extraParms.size() > 0) {
            for (String key : extraParms.keySet()) {
                if (strExtraParms.length() > 0) { strExtraParms += '&'; }
                strExtraParms += key + '=' + EncodingUtil.urlEncode(extraParms.get(key),'UTF-8');
            }
        }
        String strRuleTrigger = '';
        if (null != event.getTriggerFieldName() && null != event.getTriggerFieldValue()) {
            strRuleTrigger = '&' + event.getTriggerFieldName() + '=' + event.getTriggerFieldValue();
        }
        String httpMethod = 'GET';
        String endpoint = 'https://' + zpServer +
                '/kb/jsp/execRulesEngine.jsp?updateDB=true&dbID=' + event.getDbId() + '&SFuser=' + sfUsername +
                '&SFsession=' + sfSession + '&SFserver=' + sfServer + '&SForg=' + sfOrg +
                (strExtraParms.length() > 0 ? '&' + strExtraParms : '') + strRuleTrigger;
        endpoint += '&zPaper=1220';    //CRN180518 getting around out-dated validation
        System.debug('zPaper: Rules Engine Endpoint: ' + endpoint);
//        HttpResponse response = ZP_Callout.callout(httpMethod, endpoint, null, null);
        HttpResponse response = ZP_Callout.calloutWithRedirect(httpMethod, endpoint, null);
        System.debug('zPaper: Rules Engine Response: ' + response.getStatusCode() + ' -- ' + response.getStatus());
        System.debug('zPaper: Rules Engine Response Body: ' + response.getBody());
        if(response != NULL && (200 == response.getStatusCode() || response.getStatus() == 'OK')) {
            String body = response.getBody();
            if (body.contains('<SUCCESS>')) {
                return new ZP_Result(true, body);
                System.debug('Successful callout to zPaper service');
                //CRN171116 ToDo: we need allow for writing the call status in a field in the passed-in Salesforce object if requested.
            }
            return new ZP_Result(false, body);
        }
        return new ZP_Result(false, ZPaperConstants.UNKNOWN_ERROR);
    }

    @future
    private static void invokeService(String httpMethod, String servicePath, String pathParameters, String queryParameters) {
        doInvokeService(httpMethod, servicePath, pathParameters, queryParameters);
    }

    private static ZP_Result doInvokeService(String httpMethod, String servicePath, String pathParameters, String queryParameters) {
        String sfServer = URL.getSalesforceBaseUrl().getHost();
        String sfUsername = UserInfo.getUserName().replace('+', '%2B');   // + characters get filtered by http escaping
        String sfSession = UserInfo.getSessionId();
        String sfOrg = UserInfo.getOrganizationId();
        System.debug('@@@@@ sfOrg = ' + sfOrg);
        // Pull API server from custom settings, defaulting to api.zpaper.com
        String zpServer = 'api.zpaper.com';    // single api point for all service calls
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
        String endpoint = 'https://' + zpServer + (!servicePath.startsWith('/') ? '/' + servicePath : servicePath) +
                (NULL != pathParameters ? pathParameters : '') +
                (NULL != queryParameters ? '?' + queryParameters + '&SFuser=' + sfUsername : '?SFuser=' + sfUsername) +
                '&SFsession=' + sfSession + '&SFserver=' + sfServer + '&SForg=' + sfOrg;
        endpoint += '&zPaper=1220';    //CRN180518 getting around out-dated validation
        System.debug('zPaper: Rules Engine Endpoint: ' + endpoint);
        HttpResponse response = ZP_Callout.calloutWithRedirect(httpMethod, endpoint, null);
        if(response != NULL && (200 == response.getStatusCode() || response.getStatus() == 'OK')) {
            String body = response.getBody();
            if (null != body) {
                return new ZP_Result(true, 'Successful call to service: ' + servicePath, body);
                System.debug('Successful callout to zPaper service');
            }
            return new ZP_Result(false, body);
        }
        return new ZP_Result(false, ZPaperConstants.UNKNOWN_ERROR);
    }
}