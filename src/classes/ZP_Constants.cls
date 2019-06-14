/**
 * zPaper Utilities. Contains utility methods that allow partner code to work with zPaper services.
 *
 * Update History:
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         10/24/2017    Creation
 * Cory         01/11/2018    Added API_SESSION_TAGs
 */
global with sharing class ZP_Constants {
    global static final String RULES_ENGINE_SERVICE_REQUEST = 'X_service';
    global static final String RULES_ENGINE_BUTTON_ACTION = 'X_buttonAction';

    global static final String EVENT_FIELD_SPLIT_PAGES = 'X_splitPages';
    global static final String EVENT_FIELD_ATTACH_PAGES = 'X_attachPages';

    global static final String UNKNOWN_ERROR = 'An unknown error occurred';

    global static final String API_SESSION_TAG_BEGIN    = '<API_SESSION_ID>';
    global static final String API_SESSION_TAG_END      = '</API_SESSION_ID>';
}