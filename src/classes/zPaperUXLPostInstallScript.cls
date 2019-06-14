global class zPaperUXLPostInstallScript implements InstallHandler {
  global void onInstall(InstallContext context) {
    if(context.previousVersion() == null) {
       ZDocument_DesignLayout__c design = new ZDocument_DesignLayout__c(Name = 'Default Layout');
       Insert design;
    }
  }
}