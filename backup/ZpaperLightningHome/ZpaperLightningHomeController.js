({
    
	doinit : function(component, event, helper) {
        
        //current contact Id
        var zID = component.get("v.recordId");
        if(zID == null) {
        	var cmpTarget = component.find("sendADocButton");
			$A.util.addClass(cmpTarget, "HideButton");
        } 
        
        //Method giving response of the 
        var action = component.get('c.service');
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.zPData', response.getReturnValue());
            } else if (state === "ERROR") {
                alert('Error : ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
        
        window.console.log("pendo about to start on home!");
        
        //CDN forbids 'https://cdn.pendo.io/agent/static/73be4c48-de12-4297-63e4-2d862dce84d3/pendo.js';
        //var pendojs='https://cdn.pendo.io/agent/static/73be4c48-de12-4297-63e4-2d862dce84d3/pendo.js';
        var pendojs=$A.get("$Resource.ZPAPER5__pendojs");
        window.console.log("pendo from "+pendojs);
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
        
    window.console.log("pendo should be running on the home!");
        
	},
    
        
    show : function(component,event,helper) {
		
        var op = event.currentTarget.id;
        var ses = component.get("v.sessionId");
        
        helper.sendADocHelper(component, function() {
            
            var settings = component.get("v.settings");
            //function w(s) {document.writeln(s);}
            var URL="https://zp20.zpaper.com/kb/jsp/SF_find.jsp?op="+op+"&with=SF_files.jsp&go=console.jsp&SFtype=All&SFserver="+
             settings.PartnerUrl +"&SFsession="+ settings.sessionId;
            
            //ERS150627 added op to URL
            var n="zPaperConsole";
            var props="resizable=1,width=1100,height=700";
            if (op == "admin") {
                n="zPaperAdmin"; URL=URL.replace("go=console.jsp","mode=view&dbID=000000011071104170");
            }
            
            if (window.name.indexOf("SF1") > -1) location=URL; //ERS150701 SF1
            else if (1==1 || confirm(window.name)) { var w=window.open(URL,n,props);}
            
            event.preventDefault();            
        });        
        event.preventDefault();   
    },
    
    sendADoc : function(component, event, helper) {
        var mode = event.currentTarget.id;
        var ele = component.getElements();
        
        helper.sendADocHelper( component, function() {
            
            var settings = component.get("v.settings");
            var id = settings.accountId;
            
            if ( id.indexOf("00P")==0 || id.indexOf("00T")==0 || (id.length != 18 && id.length != 15) ) {
                alert("Navigate to a record and drag the 'https' symbol in the address bar to this panel.");
                return;
            }
            if (!ele) ele=""; 
            if (!mode) mode="send"; //ERS150711
            
            var data = "/"+id;
            id='';
            id=data.substring(data.lastIndexOf("/")+1);
            if (id.indexOf("#")>-1) id=id.substring(0,id.indexOf("#"));
            
            if (!mode) mode=1; //ERS150708
            
            //this goAnId function
            var r=false;
            if (!mode) mode=1;
            if (id.length == 18 || id.length == 15) {
                var pre=","+id.substring(0,3)+",";
                if (",001,003,005,500,00Q,006,".indexOf(pre)>-1) r=true; //ERS150627 800,801, later?
                else if (mode != 2) alert(id.substring(0,3) + " is not an Id supported by this zPaper solution. ERS150708");
            }
            
            if ( !r ) {
                alert("Drop links that contain record IDs.  Attachment and Task links do not.");
                return;
            }
            
            var zServer = "https://zp20.zpaper.com"; //ERS150708 security issues //ERS150812 fix this manaually
            var URL=zServer+"/kb/jsp/zSend.jsp?sfUser=" + settings.userName +"&sfOrg=" + settings.orgId + "&sfIDs="+id+"&mode=firstOne&SFserver=" + settings.PartnerUrl +"&SFsession=" + settings.sessionId;
            if (mode == "sign") URL=URL.replace("&mode=","&cmd="+mode+"&mode="); //ERS150711
            
            if (window.name.indexOf("SF1") > -1) location=URL; //ERS150701 SF1
            else if (1==1 || confirm(URL)) { var w=window.open(URL,"zPaperSend","resizable=1,width=850,height=800,scrollbars=1"); w.focus();}

        });
    }
}