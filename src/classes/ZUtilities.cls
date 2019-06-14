/**
 * zPaper Utilities. Contains utility methods that allow partner code to work with zPaper services.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         10/24/2017    Creation
 */
global with sharing class ZUtilities {

    /**
     * Mathod getApiSessionId
     *
     * The Session Id that is available in Lightning is not API-enabled. We need an API-enabled
     * Session Id to be sent to our service requests because we use that session Id to make SOAP
     * and Rest calls back to Salesforce. We also check the session to make sure it applies to the
     * current user.
     *
     * @return  API-enabled Session Id
     */
    global static String getApiSessionId(String lightningSessionId) {
        String sfServer = URL.getSalesforceBaseUrl().getHost();
        String vfURL = 'https://' + sfServer + '/apex/zApiSessionForLightning?sid=' + lightningSessionId;
        System.debug('===> VF Page Request: ' + vfURL);
        PageReference visualforcePage = new PageReference(vfURL);
        String content = visualforcePage.getContent().toString();
        System.debug('@@@@@@ VF PAGE CONTENT @@@@@@@@@@@@@@@@@');
        System.debug(content);
        System.debug('@@@@@@ VF PAGE CONTENT @@@@@@@@@@@@@@@@@');
        Integer iStart  = content.indexOf(ZPaperConstants.API_SESSION_TAG_BEGIN) + ZPaperConstants.API_SESSION_TAG_BEGIN.length();
        Integer iEnd    = content.indexOf(ZPaperConstants.API_SESSION_TAG_END, iStart);
        System.debug('@@@@ API-Enabled Session Id = ' + content.substring(iStart, iEnd));
        return content.substring(iStart, iEnd);
    }

    /**
     * Method attachPages
     *
     * Send a request to the zPaper Rules engine to split off the pages indicated in pageRange and attach them to the
     * Salesforce record indicated by sObjectId.
     *
     * ToDo: added statusField where we can write the status of the service call?
     * Like this: statusField   Id of the field in the above Salesforce record where status (success/failure) should be stored (optional)
     *
     * @param pageRange     pages to split
     * @param zpDbId        database Id for document (can be null)
     * @param sObjectId     Id of Salesforce record to attach the pages to
     * @param sfUsername    the userId for the current Salesforce user
     * @param sfServer      the Salesforce server host URL
     * @param sfSession     the current Salesforce session Id
     */
//    public static void attachPages(String pageRange, String zpDbId, String sObjectId, String statusField, String sfUsername, String sfServer, String sfSession) {
    global static void attachPages(String pageRange, String zpDbId, String sObjectId, String sfUsername, String sfServer, String sfSession) {
//        ZRulesEngineEvent event = new ZRulesEngineEvent(zpDbId, ZPaperConstants.EVENT_FIELD_ATTACH_PAGES, sObjectId, statusField);
        ZRulesEngineEvent event = new ZRulesEngineEvent(zpDbId, ZPaperConstants.EVENT_FIELD_ATTACH_PAGES, pageRange, sObjectId, null);
//        event.addParameter('pageRange', pageRange);

        invokeRulesEngine(event.getFutureSafeEventData(), sfUsername, sfServer, sfSession);
    }
//
//    /**
//     * Method splitPages
//     *
//     * Send a request to the zPaper Rules engine to split off the pages indicated in pageRange.
//     *
//     * @param pageRange     pages to split
//     * @param zpDbId        database Id for document (can be null)
//     * @param sfUsername    the username for the current Salesforce user
//     * @param sfServer      the Salesforce server host URL
//     * @param sfSession     the current Salesforce session Id
//     */
//    public static void splitPages(String pageRange, String zpDbId, String sfUsername, String sfServer, String sfSession) {
//        ZRulesEngineEvent event = new ZRulesEngineEvent(zpDbId, ZPaperConstants.EVENT_FIELD_SPLIT_PAGES);
//        event.addExtraParm('pageRange', pageRange);
//        ZResult result = invokeRulesEngine(event, sfUsername, sfServer, sfSession);
//        if (result.wasSuccessful()) {
//            return new ZResult(true, 'Pages: ' + pageRange + ' split successfully');
//        }
//        return result;
//    }

    /**
     * Method: invokeRulesEngine
     *
     * Send an event to the zPaper Rules engine.
     *
     * @param event         event to send
     * @param sfUsername    the username for the current Salesforce user
     * @param sfServer      the Salesforce server host URL
     * @param sfSession     the current Salesforce session Id
     */
    @future(callout=true)
    global static void invokeRulesEngine(Map<String,String> eventData, String sfUsername, String sfServer, String sfSession) {
        ZRulesEngineEvent event = new ZRulesEngineEvent(eventData);
        String sfOrg = UserInfo.getOrganizationId();
        System.debug('@@@@@ sfOrg = ' + sfOrg);
        ZPAPER__zpaper__c zpSettings = ZPAPER__zpaper__c.getInstance(sfOrg);
        System.debug('zPaper: zpSettings = ' + zpSettings);
        String zpServer = zpSettings.ZPAPER__server__c;

        String strExtraParms = '';
        if (null != event.getSObjectId()) { strExtraParms += 'sfID=' + event.getSObjectId(); }
        Map<String,String> extraParms = event.getParameters();
        if (null != extraParms && extraParms.size() > 0) {
            for (String key : extraParms.keySet()) {
                if (strExtraParms.length() > 0) { strExtraParms += '&'; }
                strExtraParms += key + '=' + extraParms.get(key);
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
        System.debug('zPaper: Rules Engine Endpoint: ' + endpoint);
        HttpResponse response = ZPaperCallout.callout(httpMethod, endpoint, null, null);
        System.debug('zPaper: Rules Engine Response: ' + response.getStatusCode());
        if(response != NULL && (200 == response.getStatusCode() || response.getStatus() == 'OK')) {
            String body = response.getBody();
            if (body.contains('<SUCCESS>')) {
//                return new ZResult(true, body);
                System.debug('Successful callout to zPaper service');
                //CRN171116 ToDo: we need allow for writing the call status in a field in the passed-in Salesforce object if requested.
            }
//            return new ZResult(false, body);
        }
//        return new ZResult(false, ZPaperConstants.UNKNOWN_ERROR);
    }
}