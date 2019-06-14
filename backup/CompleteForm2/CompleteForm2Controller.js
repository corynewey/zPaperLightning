({
    produceForm : function(component, event, helper) {
        
        var toggleText = document.getElementById("produceForm");
        toggleText.setAttribute('style', 'display:show');
        component.set("v.ifmsrc", '../jsp/massFaxBin.jsp?sfIDs=50041000001155o&amp;dbID=000046b4Z1b514m779&amp;SFserver=https://zpaper1-dev-ed.my.salesforce.com&amp;SFsession=00D41000000UDnk!AQoAQEREF7czsTugS1jOjtYsHv31EPAJO3O6Tv3bbjF5neoMID7scAm591jifZz4YvWLOEuLpQ939yosY7Bhw797t6.eOmXF');   
   
    },
    
        
    sendForm : function(component, event, helper) {
        
        var toggleText = document.getElementById("sendForm");
        toggleText.setAttribute('style', 'display:show');
        component.set("v.ifmsrc", 'est.devconsole=1');   
   
    },
    
    produceForm2 : function(component, event, helper) {
        
        var toggleText = document.getElementById("produceForm");
        toggleText.setAttribute('style', 'display:show');
        component.set("v.ifmsrc", 'https://zpaper1-dev-ed--c.na35.visual.force.com/apex/MasterProviderReferralForm?core.apexpages.request.devconsole=1');   
   
    },
    
    /* The controller action */
    showItem : function(cmp, event) {
        var myCmp = cmp.find('myCmp');
        $A.util.toggleClass(myCmp, "cssClass");
    },
    
    getMasterReferralForm : function(component, event, helper) {        
        var toggleText = document.getElementById("img1");
        toggleText.setAttribute('style', 'display:show');
        
        var toggleText = document.getElementById("img2");
        toggleText.setAttribute('style', 'display:none');
        
        var toggleText = document.getElementById("img3");
        toggleText.setAttribute('style', 'display:none');
    },
    
    getzPapyrusEnrollmentForm : function(component, event, helper) {        
        var toggleText = document.getElementById("img1");
        toggleText.setAttribute('style', 'display:none');
        
        var toggleText = document.getElementById("img2");
        toggleText.setAttribute('style', 'display:show');
        
        var toggleText = document.getElementById("img3");
        toggleText.setAttribute('style', 'display:none');
    },
 
   getAZapplication_blackZP : function(component, event, helper) {        
         var toggleText = document.getElementById("img1");
        toggleText.setAttribute('style', 'display:none');
        
        var toggleText = document.getElementById("img2");
        toggleText.setAttribute('style', 'display:none');
        
        var toggleText = document.getElementById("img3");
        toggleText.setAttribute('style', 'display:show');
    }
})