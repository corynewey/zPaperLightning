/**
 * Mock object to test http callouts.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         11/14/2017    Creation
 */
@isTest
public class ZP_MockHttpResponse implements HttpCalloutMock {
    // implementing the interface method
    public HttpResponse respond(HttpRequest req) {
        System.debug('@@@@@ ZP_MockHttpResponse is being used @@@@@');
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setBody('<SUCCESS>Operation was successful</SUCCESS>');
        res.setStatusCode(200);
//        res.setHeader('Content-Type', 'application/json');
//        if(req.getBody().contains('Call 1')) {
//            res.setBody('<soapenv:Envelope><soapenv:Body>Request Successful</soapenv:Body></soapenv:Envelope>');
//            res.setStatusCode(200);
//        }
//        else if(req.getBody().contains('Call 2')) {
//            res.setBody('<soapenv:Envelope><soapenv:Body>Unauthorized User Credentials</soapenv:Body></soapenv:Envelope>');
//            res.setStatusCode(401);
//        }
//        else if(req.getBody().contains('Call 3')) {
//            res.setBody('<soapenv:Envelope><soapenv:Body>Error In Submission</soapenv:Body></soapenv:Envelope>');
//            res.setStatusCode(404);
//        }
        return res;
    }
}