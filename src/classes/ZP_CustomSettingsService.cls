/**
 * zpSettings: custom web service that updates fields in a Custom Setting. This service accepts a JSON
 * body with the following fields:
 *
 * @param custom_setting_name       The Name of the Custom Setting which is to be updated
 * @param fields                    List of name/value pairs for the fields that are to be mudated
 *
 * Here is an example bit of JSON:
 * {
 *      "custom_setting_name": "ZPAPER5__ZpaperConfig__c",
 *      "fields": {
 *          "ZPAPER5__API_Key__c": "foo123456",
 *          "ZPAPER5__Named_Credential__c": "My Named Credential3"
 *       }
 * }
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory        09/19/2018     Creation
 */

@RestResource(urlMapping='/zpSettings/v1/')
global class ZP_CustomSettingsService {

//    ZPAPER5__ZpaperConfig__c config = [Select Id,
//            ZPAPER5__PartnerUrl__c,
//            ZPAPER5__SessionId__c,
//            ZPAPER5__Named_Credential__c From ZPAPER5__ZpaperConfig__c];
//    ZPAPER__zpaper__c zpar = ZPAPER__zpaper__c.getInstance();

    @HttpPatch
    global static void setCustomSettings() {
        String debugInfo = '';
        String queryFields = '';
        String reqBody = RestContext.request.requestBody.toString();
        Map<String, Object> parmsMap = (Map<String, Object>)JSON.deserializeUntyped(reqBody);
        String settingName = (String)parmsMap.get('custom_setting_name');
        debugInfo += '@@ Setting Name: ' + settingName;
        // default to not-found
        String response = '{"status":"failed","code":0,"message":"Custom Setting: ' + settingName + ' not found.","debug":"DEBUG_MSG"}';
        Map<String,Object> fields = (Map<String,Object>)parmsMap.get('fields');
        // handle the fields to be updated
        if (fields.size() > 0) {
            for (String field : fields.keySet()) {
                if (queryFields.length() > 0) {
                    queryFields += ',';
                }
                queryFields += String.escapeSingleQuotes(field);
            }
            String query = 'SELECT ' + queryFields + ' FROM ' + settingName;
            debugInfo += ', @@ Query: ' + query;
            List<SObject> settings = Database.query(query);
            debugInfo += ', @@ Number of Custom Settings found: ' + settings.size();
            if (1 == settings.size()) {
                SObject setting = settings.get(0);
                for (String key : fields.keySet()) {
                    debugInfo += ', @@ Old setting value = ' + setting.get(key);
                    setting.put(key, (String) fields.get(key));
                    debugInfo += ', @@ New setting value = ' + setting.get(key);
                }
                // now save it
                Database.SaveResult result = Database.update(setting);
                if (result.isSuccess()) {
                    response = '{"status":"success","code":0,"message":"Custom Setting: ' + settingName + ' was successfully updated.","debug":"DEBUG_MSG"}';
                } else {
                    String errors = '';
                    for (Database.Error error : result.getErrors()) {
                        if (errors.length() > 0) {
                            errors += ', ';
                        }
                        errors += 'Code: ' + error.getStatusCode() + ', Message: ' + error.getMessage();
                    }
                    response = '{"status":"failed","code":0,"message":"Custom Setting: ' + settingName +
                            ' was not updated. The following errors occurred: ' + errors + '","debug":"DEBUG_MSG"}';
                }
            }
        }
        else {
            // the JSON contained no fields to update
            response = '{"status":"failed","code":0,"message":"No update fields were passed in request.","debug":"DEBUG_MSG"}';
        }
        RestContext.response.responseBody = Blob.valueOf(response.replace('DEBUG_MSG', debugInfo));
    }

}