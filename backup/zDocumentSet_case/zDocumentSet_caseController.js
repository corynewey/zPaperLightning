({    
	doInit : function(component, event, helper) {   
        var action = component.get('c.getZPaperDocs');
        action.setParams({
            "recordId": component.get("v.recordId") ,
            "designLayoutName": component.get("v.DesignLayout")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                helper.getzPAttachements(component, helper, response.getReturnValue());
            } else if (state === "ERROR") {
                alert('Error : ' + JSON.stringify(errors));
            }
        });        
        $A.enqueueAction(action);
        
        //CDN forbids 'https://cdn.pendo.io/agent/static/73be4c48-de12-4297-63e4-2d862dce84d3/pendo.js';
        //var pendojs='https://cdn.pendo.io/agent/static/73be4c48-de12-4297-63e4-2d862dce84d3/pendo.js';
        var pendojs=$A.get("$Resource.pendojs");
        //alert("Before pendo "+pendojs);
   (function(p,e,n,d,o){var v,w,x,y,z;o=p[d]=p[d]||{};o._q=[];
  v=['initialize','identify','updateOptions','pageLoad'];for(w=0,x=v.length;w<x;++w)(function(m){
  o[m]=o[m]||function(){o._q[m===v[0]?'unshift':'push']([m].concat([].slice.call(arguments,0)));};})(v[w]);
  y=e.createElement(n);y.async=!0;y.src=pendojs;
  z=e.getElementsByTagName(n)[0];z.parentNode.insertBefore(y,z);})(window,document,'script','pendo');
        
  pendo.initialize({
    apiKey: '73be4c48-de12-4297-63e4-2d862dce84d3',

    visitor: {
      id:              'lightning@zpaper.com',   // Required if user is logged in
      email:         'eric+lightning@zpaper.com',
      role:            'Lightning' 
    },

    account: {
      id:           '00D41000000UDnk', // Highly recommended
      name:         'zWilco'
    }
  }); 
        
    window.console.log("pendo should be running!");
    }
})