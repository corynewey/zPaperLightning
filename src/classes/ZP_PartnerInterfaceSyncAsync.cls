/*********************************************************************************
  Class Name      : ZP_PartnerInterfaceSynchronous
  Description     : Synchronous and Asynchronous versions of our Interface definitions for all external-facing API classes.
                    These methods allow the partner to choose whether to use @future methods or not, depending on their needs.
  Created By      : Cory Newey
  Created Date    : Jan 16, 2018
  Modification Log:
  ----------------------------------------------------------------------------------
  Developer                   Date                   Description
  -----------------------------------------------------------------------------------
  Cory Newey              June 9, 2018              Initial Version
  *********************************************************************************/
global class ZP_PartnerInterfaceSyncAsync {
    global interface PartnerSyncAsync {

        /**
         * Send a document (fax, email, etc.) via zPaper services. This call is done asynchronously,
         * in a @future method
         *
         * @param objectId      Salesforce object Id
         * @param templateId    zPaper template Id
         * @param recipients    comma-separated list of email addresses, fax numbers, etc
         * @param sendToCurrentUser true if an email should also be sent to the current user
         */
        void sendAsync(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser);

        /**
         * Split pages off of the document indicated by the zpaperDBId and attach to Salesforc
         * object indicated by attachToSObjectId This call is done asynchronously, in a @future method
         *
         * @param zpaperDBId            zPaper database Id of document to split
         * @param pageRange             range of pages to split off
         * @param attachToSObjectId     Id of Salesforce to attach the split-off pages to
         */
        void splitAsync(String zpaperDBId, String pageRange, String attachToSObjectId);

        /**
         * Send a zPaper action request to invoke the zPaper Rules Engine. This call is done
         * asynchronously, in a @future method
         *
         * @param eventData     name/value and other data required for Rules Engine invocation
         */
        void invokeAsync(ZP_RulesEngineEvent eventData);

        /**
         * Send a zPaper request to pull data via the zPaper Rest API, in a @future method
         * NOTE: this method probably won't have much use since pulling data asynchronously isn't
         * very useful without a callback and Salesforce @future methods don't support the callback.
         * However, I'm putting it here to preserve symmetry between the sync/async calls and also
         * because once this interface has been deployed in a managed package, we won't be able to
         * add new methods.
         *
         * @param httpMethod        method to use (GET, POST, etc)
         * @param servicePath       path to service request
         * @param pathParameters    parameters that should be added to the path
         * @param queryParameters   parameters that should be added to the query String
         */
        void getDataAsync(String httpMethod, String servicePath, String pathParameters, String queryParameters);

        /**
         * Send a document (fax, email, etc.) via zPaper services.
         *
         * @param objectId      Salesforce object Id
         * @param templateId    zPaper template Id
         * @param recipients    comma-separated list of email addresses, fax numbers, etc
         * @param sendToCurrentUser true if an email should also be sent to the current user
         */
        ZP_Result sendSynchronous(Id objectId, String templateId, String recipients, Boolean sendToCurrentUser);

        /**
         * Split pages off of the document indicated by the zpaperDBId and attach to Salesforc
         * object indicated by attachToSObjectId
         *
         * @param zpaperDBId            zPaper database Id of document to split
         * @param pageRange             range of pages to split off
         * @param attachToSObjectId     Id of Salesforce to attach the split-off pages to
         */
        ZP_Result splitSynchronous(String zpaperDBId, String pageRange, String attachToSObjectId);

        /**
         * Send a zPaper action request to invoke the zPaper Rules Engine.
         *
         * @param eventData     name/value and other data required for Rules Engine invocation
         */
        ZP_Result invokeSynchronous(ZP_RulesEngineEvent eventData);

        /**
         * Send a zPaper request to pull data via the zPaper Rest API.
         *
         * @param httpMethod        method to use (GET, POST, etc)
         * @param servicePath       path to service request
         * @param pathParameters    parameters that should be added to the path
         * @param queryParameters   parameters that should be added to the query String
         */
        ZP_Result getDataSynchronous(String httpMethod, String servicePath, String pathParameters, String queryParameters);
    }
}