/*********************************************************************************
  Class Name      : ZP_RulesEngineEvent
  Description     : Event object sent when invoking zPaper action in zPaper Rules Engine
  Created By      : Cory Newey
  Created Date    : Jan 16, 2018
  Modification Log:
  ----------------------------------------------------------------------------------
  Developer                   Date                   Description
  -----------------------------------------------------------------------------------
  Cory Newey              Oct 14, 2017              Initial Version
  *********************************************************************************/
global with sharing class ZP_RulesEngineEvent {
    private String triggerFieldName;
    private String triggerFieldValue;
    private String sObjectId;
    private String statusField;
    private String dbId;
    private Map<String,String> params = new Map<String,String>();

    /**
     * Create a new Rules Engine Event.
     *
     * @author Cory Newey
     * @param dbId              zPaper database Id of record that is associated with the event (optional - may be null)
     * @param triggerFieldName  field name parameter that will be tested in rules engine to determine if rule should fire
     * @param triggerFieldValue field value parameter that will be tested in rules engine to determine if rule should fire
     * @param sObjectId         Salesforce object that should be used when executing the zPaper rule (optional - may be null)
     * @param statusField       field in sObject that will be used to record the status of the service call (optional - may be null)
     */
    global ZP_RulesEngineEvent(String dbId, String triggerFieldName, String triggerFieldValue, String sObjectId, String statusField) {
        this.dbId = null != dbId ? dbId : 'DUMMY';
        this.triggerFieldName = triggerFieldName;
        this.triggerFieldValue = triggerFieldValue;
        this.sObjectId = sObjectId;
        this.statusField = statusField;
    }

    /**
     * Create a new Rules Engine Event.
     *
     * @author Cory Newey
     * @param dbId              zPaper database Id of record that is associated with the event (optional - may be null)
     * @param triggerFieldName  field name parameter that will be tested in rules engine to determine if rule should fire
     * @param triggerFieldValue field value parameter that will be tested in rules engine to determine if rule should fire
     */
    global ZP_RulesEngineEvent(String dbId, String triggerFieldName, String triggerFieldValue) {
        this.dbId = null != dbId ? dbId : 'DUMMY';
        this.triggerFieldName = triggerFieldName;
        this.triggerFieldValue = triggerFieldValue;
    }

    /**
     * Create a new Rules Engine Event.
     *
     * @author Cory Newey
     * @param triggerFieldName  field name parameter that will be tested in rules engine to determine if rule should fire
     * @param triggerFieldValue field value parameter that will be tested in rules engine to determine if rule should fire
     */
    global ZP_RulesEngineEvent(String triggerFieldName, String triggerFieldValue) {
        this.dbId = 'DUMMY';            // default to DUMMY - instructs the rules engine to use a dummy Snippet record
        this.triggerFieldName = triggerFieldName;
        this.triggerFieldValue = triggerFieldValue;
    }

    /**
     * Create a new Rules Engine Event. This constructor is meant to help with marshalling event data to an @future method
     *
     * @author Cory Newey
     * @param futureSafeData    map that holds field values that were marshalled to call an @future method
     */
    global ZP_RulesEngineEvent(Map<String,String> futureSafeData) {
        this.triggerFieldName = futureSafeData.get('triggerFieldName');
        this.triggerFieldValue = futureSafeData.get('triggerFieldValue');
        this.sObjectId = futureSafeData.get('sObjectId');
        this.statusField = futureSafeData.get('statusField');
        this.dbId = futureSafeData.get('dbId');
        for (String key : futureSafeData.keySet()) {
            if (key.startsWith('param_')) {
                this.params.put(key.substring('param_'.length()), futureSafeData.get(key));
            }
        }
    }

    global void addParameter(String name, String value) {
        this.params.put(name, value);
    }

    global String getDbId() {
        return this.dbId;
    }

    global String getTriggerFieldName() {
        return this.triggerFieldName;
    }

    global String getTriggerFieldValue() {
        return this.triggerFieldValue;
    }

    global String getSObjectId() {
        return this.sObjectId;
    }

    global String getStatusField() {
        return this.statusField;
    }

    global Map<String,String> getParameters() {
        return this.params;
    }

    global Map<String,String> getFutureSafeEventData() {
        Map<String,String> data = new Map<String, String>();
        if (null != params) {
            for (String key : params.keySet()) {
                data.put('param_' + key, params.get(key));
            }
        }
        if (null != triggerFieldName) { data.put('triggerFieldName', triggerFieldName); }
        if (null != triggerFieldValue) { data.put('triggerFieldValue', triggerFieldValue); }
        if (null != sObjectId) { data.put('sObjectId', sObjectId); }
        if (null != statusField) { data.put('statusField', statusField); }
        data.put('dbId', null != dbId ? dbId : 'DUMMY');
        return data;
    }
}