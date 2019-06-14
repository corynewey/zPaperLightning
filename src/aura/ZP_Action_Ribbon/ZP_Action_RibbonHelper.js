({
    setNamespace : function(component) {

        var component_to_string = component.toString();

        var markupTagLoc = component_to_string.indexOf('markup://');
        var endOfNamespaceLoc = component_to_string.indexOf(':',markupTagLoc+9);
        var ns = component_to_string.substring(markupTagLoc+9,endOfNamespaceLoc);

        var namespacePrefix = ns === "c" ?  namespacePrefix = "" :  namespacePrefix = ns + "__";

        component.set("v.namespace", ns);
        component.set("v.namespacePrefix", namespacePrefix);
    },

    setupActionIcons : function(component, helper){
        var recId = component.get("v.recordId");
        var action = component.get("c.setupActionIcons");

        action.setParams({
            "recId": recId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set("v.actionIconsWrapper", returnValue);
                var actionIconsWrapper = component.get("v.actionIconsWrapper");
                for(var i=0; i<returnValue.length; i++){
                    actionIconsWrapper[i].iconLabel = returnValue[i].iconLabel;
                }

                component.set("v.actionIconsWrapper", actionIconsWrapper);
                component.set("v.showForm", true);
            } else {
                console.log("setupActionIcons: Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    createMap : function(component){
        // convert to map
        var createMap = {};
        var cmps = component.get("v.actionIconsWrapper");
        var noOfItems = component.get("v.noOfItemsInARow");
        var noOfCols = component.get("v.noOfColumns");
        var noOfRows = component.get("v.noOfRows");
        //Set Columns
        for(var i=1; i<=noOfItems; i++){
            noOfCols.push(i);
        }
        component.set("v.noOfColumns",noOfCols);

        //Set Rows
        for(var i=1; i<=Math.ceil((cmps.length)/noOfItems); i++){
            noOfRows.push(i);
        }
        component.set("v.noOfRows",noOfRows);
        var cmpIndex = 0;
        for(var i=0; i<noOfRows.length; i++) {
            for(var j=0; j<noOfCols.length; j++) {
                if(cmpIndex < cmps.length) {
                    createMap[i + '' + j] = cmps[cmpIndex];
                } else {
                    createMap[i + '' + j] = {};
                }
                cmpIndex++;
            }
        }
        component.set("v.actionIconsWrapperMap",createMap);
        component.set("v.showForm", true);
    },

    showModalBox : function (component, event){
        var auraModalBoxBackground = component.find('auraModalBoxBackground').getElement();
        var auraModalBoxMain = component.find('auraModalBoxMain').getElement();
        auraModalBoxBackground.style.display = "block";
        auraModalBoxMain.style.display = "block";
    }
})