/**
 * Created by Cory on 6/6/2019.
 *
 * This is a test service that I'm using to determine if a Lightning (Aura) session Id can be used
 * to call our web service (it cannot be use to invoke the built-in Salesforce Rest API).
 */
@RestResource(urlMapping='/validateSession/*')
global class SessionValidation {
    @HttpGet
    global static String validate() {
        return UserInfo.getSessionId();
    }
}