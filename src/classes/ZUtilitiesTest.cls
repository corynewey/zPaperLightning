/**
 * Test for zPaper Utilities. Contains utility methods that allow partner code to work with zPaper services.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         11/14/2017    Creation
 */
@isTest
private class ZUtilitiesTest {
    private static User adminUser;
    private static Opportunity opportunity;

    /**
     * This method is used to test the attachPages webservice callout to zPaper.
     * @author Cory Newey
     * @return void
     */
    @isTest static void testAttachPages() {
        ZUtilitiesTest.createTestData();
        System.runAs(adminUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ZP_MockHttpResponse());
            System.debug('New Opportunity Id = ' + opportunity.Id);
            ZUtilities.attachPages('1-4', null, opportunity.Id, adminUser.username, 'https://dummy.sf.com', 'dummy_sf_session');
//            System.debug('Result: successful = ' + result.wasSuccessful() + ', message = ' + result.getMessage());
//            System.assertEquals(result.wasSuccessful(), true);
            Test.stopTest();
        }
    }

//    /**
//     * This method is used to test the splitPages webservice callout to zPaper.
//     * @author Cory Newey
//     * @return void
//     */
//    @isTest static void testSplitPages() {
//        ZUtilitiesTest.createTestData();
//        System.runAs(adminUser) {
//            Test.startTest();
//            Test.setMock(HttpCalloutMock.class, new ZP_MockHttpResponse());
//            System.debug('New Opportunity Id = ' + opportunity.Id);
//            ZResult result = ZUtilities.splitPages('1-4', null, adminUser.username, 'https://dummy.sf.com', 'dummy_sf_session');
//            System.debug('Result: successful = ' + result.wasSuccessful() + ', message = ' + result.getMessage());
//            System.assertEquals(result.wasSuccessful(), true);
//            Test.stopTest();
//        }
//    }

    private static void createTestData() {
        adminUser = ZP_Test_Setup.createUser(ZP_Test_Setup.SYS_ADMIN_PROFILE, 'userzptest@test.com', 'zptest1');
        opportunity = ZP_Test_Setup.createOpportunity('Test Opportunity');
    }
}