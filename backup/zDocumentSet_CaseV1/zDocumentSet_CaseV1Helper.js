({
	getzPAttachements : function(component, helper, zPDocuments) {

        if(component.get("v.sortOrder") === 'ASC') {
        	 zPDocuments.lstDocTypes.sort();
        }
        
        if(component.get("v.sortOrder") === 'DESC') {
        	 zPDocuments.lstDocTypes.reverse();
        }	
        var zDocStatusOld = component.get('v.zDocStatusOld');
        var zDocTypes = component.get('v.zDocTypes');
        
         zPDocuments.lstDocTypes.forEach(function(DType) {    
             for(var i = 0; i < zDocTypes.length; i++){
                  if(DType != undefined && zDocTypes[i] != undefined && DType.indexOf("*") != -1 && DType.includes(zDocTypes[i])){
                     zDocTypes[i] = DType;
                  }
             }
         });
          
         document.getElementById("data").innerHTML ='';
         var mDataTypes = '';
         var zfile;
         zDocTypes.forEach(function(DType) {
              var tRow = document.createElement('tr');
              var zObj = '';
             if(zPDocuments.files.length > 0){
				  zPDocuments.files.forEach(function(file) {
					 if(file.X_docType != undefined && file.X_docType != '' && file.X_docType.trim() === DType.trim()){
						 var zMap = JSON.stringify(file.X_ReviewsMap);
						 zObj = JSON.parse(zMap);
						 mDataTypes += ","+file.X_docType.trim();
                         zfile = file;
                     }else{
                         zfile = null;
                     }				 
				  });				 
             }

             zDocStatusOld.forEach(function(field){
                    var tDCol = document.createElement('td');						
					var dv = document.createElement('div');
					helper.setAttrs(dv, {"scope": "col"});
					tDCol.appendChild(dv);
					
					if(field == 'Type'){
                       var dataFl = document.createTextNode(DType);
                       dv.appendChild(dataFl);
					}else if(field == 'UpdatedDate'){                 
             	        if(zfile != undefined && zfile != ''){
                            var dataFl2 = document.createTextNode(zfile.modified);
                            dv.appendChild(dataFl2);                   
                        }						
					}else if(field == 'Form'){
						if(zfile != undefined && zfile != ''){
							 var aLink= document.createElement('a');
							 helper.setAttrs(aLink, {"target": "_blank","href": zfile.View, "title": zfile.View});
							 var dataFl2 = document.createTextNode('View');
							 aLink.appendChild(dataFl2);
							 dv.appendChild(aLink);
						}else if(DType.indexOf("*") != -1){
						     dataFl2 = document.createTextNode('This is required.');
						     dv.appendChild(dataFl2);
						}else{
						     var dataFl2 = document.createTextNode('This is not required.');
						     dv.appendChild(dataFl2);
						}
					}					
					else{
						var spn1 = document.createElement('span');
						helper.setAttrs(spn1, {"class": "slds-checkbox"});
						dv.appendChild(spn1);
							
						var ip = document.createElement('input');
						var isChecked = (zObj != '' && zObj[field] != undefined && zObj[field] != '') ? true: false;
						if(isChecked)
						   helper.setAttrs(ip, {"type": "checkbox", "checked": isChecked});
						else
						   helper.setAttrs(ip, {"type": "checkbox"});   
						spn1.appendChild(ip);
							
						var lbl = document.createElement('label');
						helper.setAttrs(lbl, {"class": "slds-checkbox__label"});
						spn1.appendChild(lbl);                        
					  
						var spn2 = document.createElement('span');
						var title = (zObj != '' && zObj[field] != undefined && zObj[field] != '') ? zObj[field]: '';
						helper.setAttrs(spn2, {"class": "slds-checkbox--faux", "title": title});
						lbl.appendChild(spn2);
					}                    
                    tRow.appendChild(tDCol);
              });            
              document.getElementById("data").appendChild(tRow);
         });
        
         var mDocs = document.getElementById("mDocs");
         for(var i = zPDocuments.lstDocTypes.length-1; i--;){
             mDataTypes.split(",").forEach(function(str){                
                 if(zPDocuments.lstDocTypes[i].trim() === str.trim()){
                   zPDocuments.lstDocTypes.splice(i, 1);
                 }
             });            
         }

         for(var i = 0; i < zPDocuments.lstDocTypes.length; i++){            
             var mDoc = document.createElement('span');
            helper.setAttrs(mDoc, {"class": "slds-badge", "style": "color:red"});
             var mData = document.createTextNode(zPDocuments.lstDocTypes[i]);
             mDoc.appendChild(mData);
             mDocs.appendChild(mDoc);
         }
    },
    
    setAttrs : function (el, attrs) {        
      for(var key in attrs) {
        el.setAttribute(key, attrs[key]);
      }
    }        
})