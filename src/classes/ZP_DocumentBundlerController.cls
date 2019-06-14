/**
 * Controller for ZP_DocumentBundler Lightning component.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         6/04/2018    Creation
 */
public with sharing class ZP_DocumentBundlerController {
    @AuraEnabled
    public static String getTemplateList(Id recId) {
        List<TemplateWrapper> templateWrappers = new List<TemplateWrapper>();
        TemplateWrapper wrapper = new TemplateWrapper();
        wrapper.id = '123456789id';
        wrapper.label = 'Test Template';
        templateWrappers.add(wrapper);
        Type t = Type.forName('ZPAPER5', 'ZP_Utilities');
        System.debug('### ZP_Utilities Type = ' + t);
        Object o = t.newInstance();
        System.debug('### zPaper Partner Object = ' + o);
        ZP_Result result = ((ZPAPER5.ZP_PartnerInterfaceSyncAsync.PartnerSyncAsync)o).getDataSynchronous('GET', '/zpaper-dev/users/mytemplates/', NULL, NULL);
        System.debug('$$$$$$ my templates service response: ' + result.getData());

        if (result.wasSuccessful()) {
            return result.getData();
        }
        return '{}';
    }

    /**
	* Wrapper for the action icons setup. Includes all information needed to initialize the
	* action icons.
	*/
    public class TemplateWrapper {
        @AuraEnabled public String 	id {get; set;}
        @AuraEnabled public String 	label {get; set;}
    }
}