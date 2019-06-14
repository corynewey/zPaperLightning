@isTest
private class zPaperUXLPostInstallScript_Test{
static testMethod void testInstallScript() {
  zPaperUXLPostInstallScript postinstall = new zPaperUXLPostInstallScript();
    Test.testInstall(postinstall, null);
    List<ZDocument_DesignLayout__c> design = [Select id, name from ZDocument_DesignLayout__c where name ='Default Layout'];
    System.assertEquals(design.size(), 1, 'Design Layout not found');
  }
}