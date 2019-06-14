({
    fireApplicationEvent : function(component, event, helper) {
        // Get the application event by using the
        // e.<namespace>.<event> syntax
        helper.setNamespace(component);
        helper.fireApplicationEvent(component, event, helper);

    }
})