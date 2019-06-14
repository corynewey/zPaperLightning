/**
 * Setup test date for zPaper Apex tests.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         11/14/2017    Creation
 */
public with sharing class ZP_Test_Setup {
    public static final String SYS_ADMIN_PROFILE = 'System Administrator';

    /**
     * Create a new Salesforce user for testing
     *
     * @author Cory Newey
     * @param sProfileName  Salesforce profile
     * @param sUserName     new user name
     * @param sAlias        new alias
     *
     * @return
     */
    public static User createUser(String sProfileName, String sUserName, String sAlias) {
        // Get the profile details
        Profile p = [SELECT Id FROM Profile WHERE Name = :sProfileName];
        User objUser = new User(Alias = sAlias, email = sUserName, emailencodingkey = 'UTF-8',
                lastname = 'Testing', languagelocalekey = 'en_US',
                localesidkey = 'en_US',country = 'United States', profileid = p.Id,
                timezonesidkey = 'America/Los_Angeles', username = sUserName);
        insert objUser;
        return objUser;
    }

    /**
     * Create a new Salesforce Opportunity record for testing
     *
     * @author Cory Newey
     * @param sProfileName  Salesforce profile
     * @param sUserName     new user name
     * @param sAlias        new alias
     *
     * @return
     */
    public static Opportunity createOpportunity(String oppName) {
        Opportunity objOpportunity = new Opportunity(name = oppName, StageName = 'Prospecting', CloseDate = Date.newInstance(2017,10,31));
        insert objOpportunity;
        return objOpportunity;
    }

    public static Case creatCase() {
        Case objCase = new Case(Status = 'New', Priority = 'Medium');
        insert objCase;
        return objCase;
    }
}