/**
 * ZP_Result. Object that can be returned from ZP_Utilities call in order to indicate the result of the call.
 *
 * Update History:
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         10/24/2017    Creation
 */
global with sharing class ZP_Result {
    private Boolean success;
    private String message;
    private String data;

    global ZP_Result(Boolean success, String message, String data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }

    global ZP_Result(Boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    global Boolean wasSuccessful() {
        return this.success;
    }

    global String getMessage() {
        return this.message;
    }

    global void setData(String data) {
        this.data = data;
    }

    global String getData() {
        return this.data;
    }
}