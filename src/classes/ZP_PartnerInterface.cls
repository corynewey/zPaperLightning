/*********************************************************************************
  Class Name      : ZP_PartnerInterface
  Description     : Interface definitions for all external-facing API classes NOTE: this interface
                    is considered to be depracated. Use the ZP_PartnerInterfaceSyncAsync interface
                    instead.
  Created By      : Cory Newey
  Created Date    : Jan 16, 2018
  Modification Log:
  ----------------------------------------------------------------------------------
  Developer                   Date                   Description
  -----------------------------------------------------------------------------------
  Cory Newey              Jan 16, 2018              Initial Version
  *********************************************************************************/
global class ZP_PartnerInterface {
    global interface Partner {
        /**
         * Send a document (fax, email, etc.) via zPaper services.
         *
         * @param objectId      Salesforce object Id
         * @param templateId    zPaper template Id
         * @param recipients    comma-separated list of email addresses, fax numbers, etc
         * @param sendToCurrentUser true if an email should also be sent to the current user
         */
        void send(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser);

        /**
         * Split pages off of the document indicated by the zpaperDBId and attach to Salesforc
         * object indicated by attachToSObjectId
         *
         * @param zpaperDBId            zPaper database Id of document to split
         * @param pageRange             range of pages to split off
         * @param attachToSObjectId     Id of Salesforce to attach the split-off pages to
         */
        void split(String zpaperDBId, String pageRange, String attachToSObjectId);

        /**
         * Send a zPaper action request to invoke the zPaper Rules Engine.
         *
         * @param eventData     name/value and other data required for Rules Engine invocation
         */
        void invoke(ZP_RulesEngineEvent eventData);
    }

}