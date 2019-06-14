// This helper not using in Complete Form

({    
    generateForm : function(component, formURL) {
         var formImg = document.getElementById("zImg");
         formImg.setAttribute('style', 'display:none');
         var formPdf = document.getElementById("zPDF");
         formPdf.setAttribute('src', formURL);
         formPdf.setAttribute('style', 'display:show');
    },
    
    showFormImage : function(component, imgURL) {  
        var formImg = document.getElementById("zImg");
        formImg.setAttribute('src', imgURL);
        formImg.setAttribute('style', 'display:show');
    },
    
    getFormValue : function(component) {  
        var radios = document.getElementsByClassName("zOption");
        var isChecked;
        radios.forEach(function(rd) {
           if(rd.checked){
                 isChecked = true;
                 return rd.value;            
           }            
        });
        if(!isChecked){
                alert('Please select a form'); 
        }
    }
})