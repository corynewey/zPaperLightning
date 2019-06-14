/**
 * Test for zPaper Utilities. Contains utility methods that allow partner code to work with zPaper services.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         11/14/2017    Creation
 */
@isTest
private class ZP_UtilitiesTest {
    private static User adminUser;
    private static Opportunity opportunity;

    /**
     * This method is used to test the split webservice callout to zPaper.
     * @author Cory Newey
     * @return void
     */
    @isTest
    static void testSplit() {
        ZP_UtilitiesTest.createTestData();
        ZP_Utilities utilities = new ZP_Utilities();
        System.runAs(adminUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ZP_MockHttpResponse());
            Case objCase = ZP_Test_Setup.creatCase();
            utilities.split('00012345', '1,2,3-6', objCase.Id);
            Test.stopTest();
        }
    }

    /**
     * This method is used to test the send (email, fax, etc) webservice callout to zPaper.
     * @author Cory Newey
     * @return void
     */
    @isTest
    static void testSend() {
        ZP_UtilitiesTest.createTestData();
        ZP_Utilities utilities = new ZP_Utilities();
        System.runAs(adminUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ZP_MockHttpResponse());
            Case objCase = ZP_Test_Setup.creatCase();
            utilities.send(objCase.Id, 'test_template', 'tom@nowhere.com,8885551111', true);
            Test.stopTest();
        }
    }

    /**
     * This method is used to test the zPaper Rules Engine invocation.
     * @author Cory Newey
     * @return void
     */
    @isTest
    static void testInvoke() {
        ZP_UtilitiesTest.createTestData();
        ZP_Utilities utilities = new ZP_Utilities();
        System.runAs(adminUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ZP_MockHttpResponse());
            Case objCase = ZP_Test_Setup.creatCase();
            ZP_RulesEngineEvent event = new ZP_RulesEngineEvent('00012345', ZP_Constants.EVENT_FIELD_ATTACH_PAGES, '1-4', objCase.Id, 'Status');
            utilities.invoke(event);
            Test.stopTest();
        }
    }

    private static void createTestData() {
        adminUser = ZP_Test_Setup.createUser(ZP_Test_Setup.SYS_ADMIN_PROFILE, 'userzptest@test.com', 'zptest1');
        opportunity = ZP_Test_Setup.createOpportunity('Test Opportunity');
    }
}