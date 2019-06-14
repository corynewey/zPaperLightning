({
    handleComponentEvent : function(component, event, helper) {
        var type = event.getParam("type");
        // alert("Received event in parent component: type = " + type);
        event.stopPropagation();
        if ("Refresh" === type) {
            // component.set("v.body", []);
            $A.get('e.force:refreshView').fire();
        }
    },
    doInit : function(component, event, helper) {
        helper.setNamespace(component);
        var action = component.get('c.getZPaperDocs');
        action.setParams({
            "recordId": component.get("v.recordId") ,
            "designLayoutName": component.get("v.DesignLayout"),
            "zSearchURL": component.get("v.zSearchURL")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var zPDocuments = response.getReturnValue();
                window.console.log("############### JSON RESPONSE ###########################");
                window.console.log(JSON.stringify(zPDocuments));
                window.console.log("############### JSON RESPONSE ###########################");
                component.set('v.zPDocuments', zPDocuments);
                // // helper.getzPAttachements(component, helper, response.getReturnValue());
                // // create the table header
                var namespace = component.get("v.namespace");
                window.console.log("Creating component: " + namespace + ":ZP_DocumentSetStatusTable");
                $A.createComponent(
                    namespace + ":ZP_DocumentSetStatusTable",
                    {
                        "zPDocumentsObj" : zPDocuments,
                        "recordId" : component.get("v.recordId")
                    },
                    function(newComponent, status, errorMessage) {
                        window.console.log("## ZP_DocumentSetStatusTable Component Create Status = " + status);
                        if ("SUCCESS" === status) {
                            var content = component.get("v.body");
                            content.push(newComponent);
                            component.set("v.body", content);
                            $A.createComponent(
                                namespace + ":ZP_DocumentSetMissedDocTypes",
                                {
                                    "zPDocumentsObj": zPDocuments,
                                    "recordId": component.get("v.recordId")
                                },
                                function (newComponent, status, errorMessage) {
                                    window.console.log("## ZP_DocumentSetMissedDocTypes Component Create Status = " + status);
                                    var content = component.get("v.body");
                                    content.push(newComponent);
                                    component.set("v.body", content);
                                }
                            );
                        }
                        else {
                            helper.displayError(component, errorMessage);
                        }
                    }
                );
            } else if (state === "ERROR") {
                var errorMsg = JSON.stringify(response.getError());
                window.console.log('Error calling APEX : ' + errorMsg);
                helper.displayError(component, errorMsg);
            }
        });
        $A.enqueueAction(action);

        //CDN forbids 'https://cdn.pendo.io/agent/static/73be4c48-de12-4297-63e4-2d862dce84d3/pendo.js';
        //var pendojs='https://cdn.pendo.io/agent/static/73be4c48-de12-4297-63e4-2d862dce84d3/pendo.js';
        //       var pendojs=$A.get("$Resource.pendojs");
        //  (function(p,e,n,d,o){var v,w,x,y,z;o=p[d]=p[d]||{};o._q=[];
        // v=['initialize','identify','updateOptions','pageLoad'];for(w=0,x=v.length;w<x;++w)(function(m){
        // o[m]=o[m]||function(){o._q[m===v[0]?'unshift':'push']([m].concat([].slice.call(arguments,0)));};})(v[w]);
        // y=e.createElement(n);y.async=!0;y.src=pendojs;
        // z=e.getElementsByTagName(n)[0];z.parentNode.insertBefore(y,z);})(window,document,'script','pendo');
        //
        // pendo.initialize({
        //   apiKey: '73be4c48-de12-4297-63e4-2d862dce84d3',
        //
        //   visitor: {
        //     id:              'lightning@zpaper.com',   // Required if user is logged in
        //     email:         'eric+lightning@zpaper.com',
        //     role:            'Lightning'
        //   },
        //
        //   account: {
        //     id:           '00D41000000UDnk', // Highly recommended
        //     name:         'zWilco'
        //   }
        // });
        //
        //   window.console.log("pendo should be running!");
    }
})