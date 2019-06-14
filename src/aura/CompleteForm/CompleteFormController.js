({  // Method: doInit and invoking Apex controller method.
    doInit : function(component, event, helper) {
	 try{
        //helper.getSessionId();
        var action = component.get('c.getzCompleteForms');
        action.setParams({
            "caseid": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
		 // Cory has to be add detail comments in diInit method
            //CRN170524 - Updating code such that it populates the various sections according to filter criteria that are supplied in app builder.
            var entryTemplate = "<span class=\"slds-radio\">" +
                                "<input type=\"radio\" id=\"%DOC_ID%\" class=\"zOption\" name=\"%DOC_NAME%\" onchange=\"{!c.getFormImage}\"/>" +
                                "<label class=\"slds-radio__label\" for=\"%DOC_ID%\">" +
                                "<span class=\"slds-radio--faux\"></span>" +
                                "<span class=\"slds-form-element__label\">%DOC_LABEL%</span>" +
                                "</label>" +
                                "</span><br/>";
            var state = response.getState();
            if (state === 'SUCCESS') {
                var zFormsResponse = response.getReturnValue();
                component.set('v.zFormsResponse', zFormsResponse);
                var debugTA = document.getElementById("debugTA");
                // debugTA.innerHTML = zFormsResponse.zforms;
                var sect1Buffer = "";
                var sect1Filter = component.get('v.Section1Filter');
                var sect2Buffer = "";
                var sect2Filter = component.get('v.Section2Filter');
                var sect3Buffer = "";
                var sect3Filter = component.get('v.Section3Filter');

                //CRN170524 Utility function to aid in filtering which zForm entries go into which section
                var evalFilter = function(form, filter) {
                    try {
                        filter = filter.replace(/@/g, "\"");
                        var json = JSON.parse(filter);
                        switch (json.op) {
                            case 'eq':
                                if (form[json.field] === json.testValue) {
                                    return true;
                                }
                        }
                        return false;
                        // return eval(filter);
                    } catch (err) { return "ERROR evaluation failed: " + err; }
                };

                var dbgStr = "";
                var res  = JSON.parse(zFormsResponse.zforms);
                res.forms.forEach(function(form) {
                    var filterResult = evalFilter(form, sect1Filter);
                    // var filterResult = evalInContext.call(form, sect1Filter);
                    dbgStr += "@@@@ zForm: " + form.name + " - type: " + form.type + " - filter: *" + sect1Filter + "* - filterResult: " + filterResult + "\n";
                    if (filterResult) {
                        sect1Buffer += entryTemplate.replace(/%DOC_ID%/g, form.id).replace(/%DOC_NAME%/g, form.BATES).replace(/%DOC_LABEL%/g, form.name);
                    }
                    filterResult = evalFilter(form, sect2Filter);
                    // var filterResult = evalInContext.call(form, sect2Filter);
                    dbgStr += "@@@@ zForm: " + form.name + " - type: " + form.type + " - filter: *" + sect2Filter + "* - filterResult: " + filterResult + "\n";
                    if (filterResult) {
                        sect2Buffer += entryTemplate.replace(/%DOC_ID%/g, form.id).replace(/%DOC_NAME%/g, form.BATES).replace(/%DOC_LABEL%/g, form.name);
                    }
                    filterResult = evalFilter(form, sect3Filter);
                    // var filterResult = evalInContext.call(form, sect3Filter);
                    dbgStr += "@@@@ zForm: " + form.name + " - type: " + form.type + " - filter: *" + sect3Filter + "* - filterResult: " + filterResult + "\n";
                    if (filterResult) {
                        sect3Buffer += entryTemplate.replace(/%DOC_ID%/g, form.id).replace(/%DOC_NAME%/g, form.BATES).replace(/%DOC_LABEL%/g, form.name);
                    }
                    // alert(dbgStr);
                    // filterResult = this.evalInContext(sect2Filter).call(form);
                    // dbgStr += "@@@@ zForm: " + form.name + " - type: " + form.type + " - filter: " + sect2Filter + " - filterResult: " + filterResult;
                    // alert(dbgStr);
                    // filterResult = this.evalInContext(sect3Filter).call(form);
                    // dbgStr += "@@@@ zForm: " + form.name + " - type: " + form.type + " - filter: " + sect3Filter + " - filterResult: " + filterResult;
                    // alert(dbgStr);

                    // if(form.name.includes("Master")){
                    //     var Master = document.getElementById("Master");
                    //     Master.setAttribute('value', form.BATES);
                    //     Master.setAttribute('title', form.URL);
					 // }else if(form.name.includes("zPapyrus")){
                    //     var zPapyrus = document.getElementById("zPapyrus");
                    //     zPapyrus.setAttribute('value', form.BATES);
                    //     zPapyrus.setAttribute('title', form.URL);
                    //  }else if(form.name.includes("AZapplication")){
                    //     var AZapplication = document.getElementById("AZapplication");
                    //     AZapplication.setAttribute('value', form.BATES);
                    //     AZapplication.setAttribute('title', form.URL);
                    //  }else{}
                });
                debugTA.innerHTML = dbgStr + "\n";
                if (sect1Buffer.length > 0) {
                    document.getElementById("sect1Container").innerHTML = sect1Buffer;
                }
                else { document.getElementById("sect1Container").innerHTML = "None Found"; }
                if (sect2Buffer.length > 0) {
                    document.getElementById("sect2Container").innerHTML = sect2Buffer;
                }
                else { document.getElementById("sect2Container").innerHTML = "None Found"; }
                if (sect3Buffer.length > 0) {
                    document.getElementById("sect3Container").innerHTML = sect3Buffer;
                }
                else { document.getElementById("sect3Container").innerHTML = "None Found"; }

            } else if (state === "ERROR") {
                alert('Error : ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
      }catch(err) {
        console.log('****CompleteForms***doInit****ERROR**'+err);
	  }		
    },
	
    // Generating and placing the ProduceForm button functionality based on zPaper Server response
    getProduceForm : function(component, event, helper) {
	 try{
        var zFormsResponse = component.get('v.zFormsResponse');
         var radios = document.getElementsByClassName("zOption");
         var isChecked;
         radios.forEach(function(rd) {
           if(rd.checked){
                isChecked = true;
                var formImg = document.getElementById("zImg");
                formImg.setAttribute('style', 'display:none');
                var formPdf = document.getElementById("zPDF");
                formPdf.setAttribute('src', zFormsResponse.zPaperBaseURL+'/kb/jsp/SF_pull.jsp?BATES='+zFormsResponse.recordId+'@'+zFormsResponse.OrdId+'-'+rd.value+'.htm');
                formPdf.setAttribute('style', 'display:show');
             }
         });
        if(!isChecked){
                alert('Please select a form'); 
        }
	  }catch(err) {
        console.log('****CompleteForms***getProduceForm****ERROR**'+err);
	  }	
    },
    
	// Generating and placing the SendForm button functionality based on zPaper Server response
    getSendForm : function(component, event, helper) {
	  try{
        var zFormsResponse = component.get('v.zFormsResponse');
        var radios = document.getElementsByClassName("zOption");
        radios.forEach(function(rd) {
           if(rd.checked){
                 var formImg = document.getElementById("zImg");
                 formImg.setAttribute('style', 'display:none');
                 var formPdf = document.getElementById("zPDF");
                 formPdf.setAttribute('src', zFormsResponse.zPaperBaseURL+'/kb/jsp/massFaxBin.jsp?sfIDs='+zFormsResponse.recordId+'&dbID='+rd.value);
                 formPdf.setAttribute('style', 'display:show');
            }
        });
	  }catch(err) {
        console.log('****CompleteForms***getSendForm****ERROR**'+err);
	  }	
    },
    
	// Generating and placing the PrintForm button functionality based on zPaper Server response
    getPrintForm : function(component, event, helper) {
	 try{
        var zFormsResponse = component.get('v.zFormsResponse');
        var radios = document.getElementsByClassName("zOption");
        var isChecked;
        radios.forEach(function(rd) {
           if(rd.checked){
                 isChecked = true;
                 var formImg = document.getElementById("zImg");
                 formImg.setAttribute('style', 'display:none');
                 var formPdf = document.getElementById("zPDF");
                 formPdf.setAttribute('src', zFormsResponse.zPaperBaseURL+'/kb/jsp/SF_pull.jsp?BATES='+zFormsResponse.recordId+'@'+zFormsResponse.OrdId+'-'+rd.value+'.htm&forceNative=true');
                 formPdf.setAttribute('style', 'display:show');
            }
        });
        if(!isChecked){
                alert('Please select a form'); 
        }
	  }catch(err) {
        console.log('****CompleteForms***getPrintForm****ERROR**'+err);
	  }	
    },
    
	// Generating and placing Preview image based on radio button selection
    getFormImage : function(component, event, helper) { 
	  try{
        document.getElementById("newClientSectionId").style.display = "block";
        var zFormsResponse = component.get('v.zFormsResponse');
        var rdTitle = event.currentTarget.title;
        var formImg = document.getElementById("zImg");
        formImg.setAttribute('src', zFormsResponse.zPaperBaseURL+'/kb'+rdTitle.replace('../','/')+'-p01.png?SFuser='+zFormsResponse.LoggedInUser);
        formImg.setAttribute('style', 'display:show');
        //helper.getSessionId();
	  }catch(err) {
        console.log('****CompleteForms***getFormImage****ERROR**'+err);
	  }	
    },
    
	// Model show/hide functionality
    showModal : function(component, event, helper) {
        document.getElementById("newClientSectionId").style.display = "block";
    },
    
	// Model show/hide functionality. Based on hide logic all the Preview images and forms are setting as null
    hideModal : function(component,event, helper){
	 try{
        var formImg = document.getElementById("zImg");
        formImg.setAttribute('src', 'display:none');
        var formPdf = document.getElementById("zPDF");
		formPdf.setAttribute('style', 'display:none');
        document.getElementById("newClientSectionId").style.display = "none" ;
	  }catch(err) {
        console.log('****CompleteForms***hideModal****ERROR**'+err);
	  }
    }
})