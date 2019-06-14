/**
 * zPaper Callout Service Contains utility method that allow http callout to zPaper services.
 *
 * Update History
 * Who          Date          Change
 * =====================================================================================================================
 * Cory         10/24/2017    Creation
 */
global with sharing class ZP_Callout {
    /**
     * Method: callout
     *
     * Performs an http webservice call
     *
     * @param httpMethod     GET, POST, etc
     * @param endpoint       Host to send request to
     * @param jsonBody       body payload for post request
     * @param authorizationHeader    any required authorization data
     **/
    global static httpResponse callout(String httpMethod, String endpoint, String jsonBody, String authorizationHeader){
        //Instantiate an httpRequest and set the required attributes
        httpRequest req = new httpRequest();
        req.setMethod(httpMethod);
        req.setEndpoint(endpoint);
        //Optional attributes
        req.setHeader('Content-Type', 'application/json');
        // only if Authorization is needed
        if(String.isNotBlank(authorizationHeader)){
            req.setHeader('Authorization', authorizationHeader);
        }
        // only if body is set
        if(String.isNotBlank(jsonBody)) {
            req.setBody(jsonBody);
        }
        //You can adjust the timeout duration (in milliseconds) to deal with slow servers or large payloads
        req.setTimeout(120000);
        //Use the HTTP Class to send the httpRequest and receive an httpResposne
        Http h = new http();
        httpResponse response = new httpResponse();
        response = h.send(req);
        return response;
    }

    global static httpResponse calloutWithRedirect(String httpMethod, String endpoint, String jsonBody) {
        httpResponse response = null;
        // don't let the redirection go on forever
        Integer maxRedirects = 10;
        Integer curRedirectCount = 0;
        do {
            if (null != endpoint) {
                response = callout(httpMethod, endpoint, jsonBody, null);
            }
            System.debug('## Inside calloutWithRedirect: endpoint = ' + endpoint + ', status code = ' + response.getStatusCode());
            endpoint = response.getHeader('Location');
            System.debug('## Inside calloutWithRedirect: new endpoint = ' + endpoint);
        } while (curRedirectCount++ < maxRedirects &&
                response.getStatusCode() > 300 && response.getStatusCode() <= 308 && null != endpoint);
        return response;
    }
}