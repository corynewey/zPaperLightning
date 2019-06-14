/**
 * zPaper Utilities. Contains utility methods that allow partner code to work with zPaper services.
 *
 * Update History:
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         10/24/2017    Creation
 */
global with sharing class ZResult {
    private Boolean success;
    private String message;

    global ZResult(Boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    global Boolean wasSuccessful() {
        return this.success;
    }

    global String getMessage() {
        return this.message;
    }
}