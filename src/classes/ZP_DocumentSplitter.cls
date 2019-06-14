/*********************************************************************************
  Class Name      : ZP_DocumentSplitter
  Description     : Gateway class for calling zPaper services for splitting documents
  Created By      : Cory Newey
  Created Date    : Jan 17, 2018
  Modification Log:
  ----------------------------------------------------------------------------------
  Developer                   Date                   Description
  -----------------------------------------------------------------------------------
  Cory Newey              Jan 17, 2018              Initial Version
  Cory Newey              Jan 31, 2018              Implementing PC_Document.Splitter interface
  *********************************************************************************/
public with sharing class ZP_DocumentSplitter implements PCAlpa.PC_Document.Splitter {
    private String zUtilitiesClassName = 'ZP_Utilities';

    /**
     * Splits the parent attachment into a separate attachment for each child document.
     * The split documents should be attached to the corresponding child documents.
     * This method should throw a <code>SplitException</code> if there is a problem calling
     * the external service.
     *
     * @param parentDoc The parent document containing the attachment to split.
     * @param childDocs The child document containing the page ranges to split on.
     */
    public void splitDocument(PC_Document__c parentDoc, PC_Document__c[] childDocs) {
        for (PC_Document__c childDoc : childDocs) {
            splitDocument(parentDoc, childDoc);
        }
    }

    public void splitDocument(PC_Document__c parentDocument, PC_Document__c attachToDocument) {
        // only works if the zPaper package is installed
        if (fieldExists('ZPAPER__zpaper__c', null)) {
            String zpaperDBId = parentDocument.PC_zPaper_Fax_Unique_Id__c;
            Type t = Type.forName(zUtilitiesClassName);
            Object o = t.newInstance();
            ((ZP_PartnerInterface.Partner) o).split(zpaperDBId, attachToDocument.PC_ParentPgRange__c, attachToDocument.Id);
        }
    }

    public void setZUtilitiesClassName(String name) {
        zUtilitiesClassName = name;
    }

    private boolean fieldExists(String objName, String fieldName) {
        try {
            SObject sObj = Schema.getGlobalDescribe().get(objName).newSObject();
            if (null == fieldName) { return true; }
            return sObj.getSObjectType().getDescribe().fields.getMap().containsKey(fieldName);
        }
        catch (Exception e) { /* don't care */ }
        return false;
    }
}