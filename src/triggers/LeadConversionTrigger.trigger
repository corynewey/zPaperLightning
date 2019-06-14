trigger LeadConversionTrigger on Lead (after update) {
    for(Lead lead:System.Trigger.new) {
        if (lead.isConverted && (null != lead.convertedOpportunityId || null != lead.convertedAccountId || null != lead.convertedContactId)) {
            // Create an event to hold the parameters that we need to call out to zPaper services.
            ZP_RulesEngineEvent event = new ZP_RulesEngineEvent(null, ZP_Constants.RULES_ENGINE_SERVICE_REQUEST, 'COPY_ATTACHMENTS', lead.Id, null); //This service rule must be defined in the rules engine for this org
            // Note: all extra parameters that will sent to the Rules Engine must be prepended with 'X_'; the rest of the field name can be free-form.
            if (null != lead.convertedOpportunityId) { event.addParameter('X_opportunityId', lead.convertedOpportunityId); }
            if (null != lead.convertedAccountId) { event.addParameter('X_accountId', lead.convertedAccountId); }
            if (null != lead.convertedContactId) { event.addParameter('X_contactId', lead.convertedContactId); }
            String sfSession = UserInfo.getSessionId();
            String orgId = UserInfo.getOrganizationId();
            String userName = UserInfo.getUserName();
            String sfServer = URL.getSalesforceBaseUrl().getHost();
            System.debug('@@@@@ CALLING zPaper SERVICES: userName = ' + userName + ', sfServer = ' + sfServer + ', sfOrg = ' + orgId + ', sfSession = ' + sfSession);
            // Since the callout is done asynchronously via the @future annotation, we need to marshal the event as a Map<String,String>.
            // That is what the getFutureSafeEventData() method does.
            ZP_Utilities zpUtilities = new ZP_Utilities();
            zpUtilities.invoke(event);
        }
    }
}