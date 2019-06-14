global class ZP_DocumentSetBodyRowController {
    @AuraEnabled
    public static ResponseDto callZPaperService(String recordId, String dbId, String eventName) {
        String msgBuffer = '';
        Boolean isSuccess = true;
        System.debug('@@@ event to be sent to zPaper Rules Engine: ' + eventName);
        try {
            ZP_RulesEngineEvent event = new ZP_RulesEngineEvent(dbId,
                    ZP_Constants.RULES_ENGINE_BUTTON_ACTION, eventName, recordId, null);
            Type t = Type.forName('ZPAPER5', 'ZP_Utilities');
            System.debug('### ZP_Utilities Type = ' + t);
            msgBuffer += '### ZP_Utilities Type = ' + t + ' -- ';
            Object o = t.newInstance();
            System.debug('### zPaper Partner Object = ' + o);
            msgBuffer += '### zPaper Partner Object = ' + o + ' -- ';
            ((ZPAPER5.ZP_PartnerInterface.Partner) o).invoke(event);
            msgBuffer += '@@@ event sent to zPaper Rules Engine: ' + eventName;
        }
        catch (Exception e) {
            System.debug(e);
            System.debug('$$$$$ Exception calling invoke in Partner Interface: ' + e.getMessage());
            msgBuffer += '$$$$$ Exception calling invoke in Partner Interface: ' + e.getMessage();
            isSuccess = false;
        }
        return new ResponseDto(isSuccess, msgBuffer);
    }

    global class ResponseDto {
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public String message { get; set; }
        @AuraEnabled public Map<Object, Object> values { get; set; }
        private void addValue(Object key, Object val) {
            this.values.put(key, val);
        }
        public ResponseDto(Boolean isSuccess, String msg){
            this.isSuccess = isSuccess;
            this.message = msg;
            this.values = new Map<Object, Object>();
        }
    }
}