/**
 * Created by User on 8/28/2018.
 */

global with sharing class TestNamedCredentialCalloutController {
    @AuraEnabled
    public static String doTestCallout(String sfId) {
        ZPAPER5__ZpaperConfig__c config = [Select Id,
                ZPAPER5__PartnerUrl__c,
                ZPAPER5__SessionId__c,
                ZPAPER5__Named_Credential__c From ZPAPER5__ZpaperConfig__c];
        ZPAPER__zpaper__c zpar = ZPAPER__zpaper__c.getInstance();

        Http httpSrv = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
//        req.setEndpoint('callout:ZPaperTestCallout/kb/admin/lightningTest.jsp?sfServer=https://zpaper1-dev-ed.lightning.force.com');
//        req.setEndpoint('callout:ZPaperPerUser/kb/admin/lightningTest.jsp?sfServer=https://zpaper1-dev-ed.lightning.force.com');
        String userId = UserInfo.getUserId();
        String orgId = UserInfo.getOrganizationId();
        String sfServer = Url.getSalesforceBaseUrl().getHost();
        if (!sfServer.startsWith('https://')) {
            if (sfServer.startsWith('http://')) { sfServer = sfServer.replace('http://', 'https://'); }
            else { sfServer = 'https://' + sfServer; }
        }
        String url = NULL != config.ZPAPER5__Named_Credential__c ?
                        'callout:' + config.ZPAPER5__Named_Credential__c + '/kb/admin/lightningTest.jsp' :
                        zpar.ZPAPER__server__c + '/kb/admin/lightningTest.jsp';

        System.debug('@@@ callout: ' + url + ' @@@');
        System.debug('@@@ Calling zippi: userId = ' + userId + ', orgId = ' + orgId + ', server = ' + sfServer);
        req.setHeader('X-Z-SFServer', sfServer);
        req.setHeader('X-Z-SForg', orgId);
        req.setHeader('X-Z-SFuserID', userId);
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(url);
        HttpResponse resp = httpSrv.send(req);
        System.debug('Callout response code = ' + resp.getStatusCode() + ', status = ' + resp.getStatus());
        return resp.getBody();
    }
}