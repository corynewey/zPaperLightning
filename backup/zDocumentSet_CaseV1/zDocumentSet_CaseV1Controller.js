({
	doInit : function(component, event, helper) {
        
        var zDocStatusMap = {};
        zDocStatusMap['Delivered'] = component.get('v.Delivered');
        zDocStatusMap['Indexed'] = component.get('v.Indexed');
        zDocStatusMap['Rejected'] = component.get('v.Rejected');
        zDocStatusMap['Processed'] = component.get('v.Processed');
        zDocStatusMap['Updated'] = component.get('v.Updated');
        zDocStatusMap['Verified'] = component.get('v.Verified');
        zDocStatusMap['Type'] = component.get('v.Type'); 
        zDocStatusMap['UpdatedDate'] = component.get('v.UpdatedDate');
        zDocStatusMap['Form'] = component.get('v.Form');
        
        var zDocStatusOld = new Array(10);
        var zDocStatusNew = new Array(10);        
        for(var key in zDocStatusMap) {
            var clmn = zDocStatusMap[key];
            if(clmn.indexOf("Yes") != -1){
               var clnms = clmn.split(';');
               zDocStatusOld[clnms[2]] = key;
               zDocStatusNew[clnms[2]] = clnms[1];
            }
            else if(clmn.indexOf("Yes") == -1 && clmn.indexOf("No") == -1){
               zDocStatusOld.push(key);
               zDocStatusNew.push(key);
            }else{}
        }
        component.set('v.zDocStatusOld', zDocStatusOld);
        component.set('v.zDocStatusNew', zDocStatusNew);

        var zDocTypeMap = {};
        zDocTypeMap['HDOT'] = component.get('v.HDOT');
        zDocTypeMap['3500'] = component.get('v.a3500a');
        zDocTypeMap['DOSE'] = component.get('v.DOSE');
        zDocTypeMap['ENRLC'] = component.get('v.ENRLC');
        zDocTypeMap['PIRM'] = component.get('v.PIRM');
        zDocTypeMap['REFR'] = component.get('v.REFR');
        var zDocTypes = [];
        for(var key in zDocTypeMap) {
		   if(zDocTypeMap[key] != 'No'){
              zDocTypes.push(key);
		   }
        }
        component.set('v.zDocTypes', zDocTypes); 
        
        var action = component.get('c.getZPaperDocs');
        action.setParams({
            "caseid": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {                
                component.set('v.ZPaperDocsList', response.getReturnValue());                
                helper.getzPAttachements(component, helper, response.getReturnValue());                
            } else if (state === "ERROR") {
                alert('Error : ' + JSON.stringify(errors));
            }
        });        
        $A.enqueueAction(action);    
    }
})