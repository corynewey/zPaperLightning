<!--
// Name: Non-barcoded Fax Received
// Committer: cory.newey@zpaper.com
// Update: aslkfjlksf
-->
<script>
//--- RULE JSON REPRESENTATION ---
var ruleJson = {"type":"rool","updated":"2017-11-19 01:42:40","active":true,"button":"","name":"Non-barcoded Fax Received","conditions":{"logic":"and","arguments":[{"name":"doc.X(\"X_field0\")","value":"","operation":"equals"}]},"consequence":{"doit":"Ly9FUlMxNzAzMjggZG9jVHlwZSBieSBPQ1IKekRhdGEuZG9jVHlwZU9DUiA9IHpEYXRhLmRvY1R5cGVyKGRvYywgeyJQQVBQIjoiUGF0aWVudH4gQXNzaXN0YW5jZX4iLCAiUEFVVEgiOiJQcmlvcn4gQXV0aG9yaXphdGlvbn4iLCAiRU5STCI6IkVucm9sbG1lbnR+IiwgIkZBWCI6IiJ9KTsKYWxlcnQoImRvY1R5cGUgd2FzICIgKyBkb2MuZG9jVHlwZSArICIgbm93ICIgKyB6RGF0YS5kb2NUeXBlT0NSKTsKdmFyIHpUeXBlID0gZG9jLlgoIlhfZG9jVHlwZSIpOwppZiAoZG9jLmRvY1R5cGUgIT0gekRhdGEuZG9jVHlwZU9DUikgewogICAgdmFyIGFyck9mUGFpcnMwID0gW107CiAgICBhcnJPZlBhaXJzMC5wdXNoKCJYX2RvY1R5cGVPQ1IiLCB6RGF0YS5kb2NUeXBlT0NSKTsKICAgIGFyck9mUGFpcnMwLnB1c2goIlhfZG9jVHlwZSIsIHpEYXRhLmRvY1R5cGVPQ1IpOwogICAgelR5cGUgPSB6RGF0YS5kb2NUeXBlT0NSOyAvL0VSUzE3MDMzMCBzYXZlZCBiZWxvdyBpbnRvIFNGIGZheFR5cGVfX2MgZmllbGQKICAgIHVwZGF0ZURCKGRvYywgYXJyT2ZQYWlyczApOwp9Cgp2YXIgZm9ybWF0Tm93ID0gZ2V0Q3VyRGF0ZUFuZFRpbWUoZG9jKTsKdmFyIGNoYW5uZWwgPSAiRmF4IgppZiAoaXNOYU4oZG9jLmRlbGl2ZXJlZEZyb20pKSB7IC8vIE5vdCBhIE51bWJlciBpcyB0cnVlCiAgICBjaGFubmVsID0gIkVtYWlsIjsKfQp2YXIgYXJyT2ZQYWlycyA9IFtdOwp2YXIgenAgPSAiWlBBUEVSX18iOyAvL0VSUzE3MDYyNiBub3cgaW4gdGhlIHBhY2thZ2UKdmFyIHpTdGFjayA9IHpwICsgInpTdGFja19fYyI7CmFyck9mUGFpcnMucHVzaCh6cCArICJmYXhUeXBlX19jIiwgelR5cGUpOwphcnJPZlBhaXJzLnB1c2goenAgKyAiUHJpb3JpdHlfX2MiLCAiTWVkaXVtIik7CmFyck9mUGFpcnMucHVzaCh6cCArICJTdGF0dXNfX2MiLCAiTmV3IFN0YWNrIik7CmFyck9mUGFpcnMucHVzaCh6cCArICJDaGFubmVsX19jIiwgY2hhbm5lbCk7Ci8qIE1TSDE3MTExNiB1c2luZyB6U3RhY2tfUmVjZWl2ZWRfX2MgaW5zdGVhZCBvZiBsYXRlc3RGYXhfX2MKICAgICAgICBiZWNhdXNlIGxhdGVzdEZheF9fYyBnZXRzIHVwZGF0ZWQgYnkgc2F2ZS5qc3AgZXZlcnkgdGltZQogICAgICAgIHRoZSByZWNvcmQgaXMgdXBkYXRlZAogKi8KLyogYXJyT2ZQYWlycy5wdXNoKHpwICsgImxhdGVzdEZheF9fYyIsIGZvcm1hdE5vdyk7ICovCmFyck9mUGFpcnMucHVzaCgiWlBBUEVSX19sYXRlc3RGYXhfX2MiLCBmb3JtYXROb3cpOwphcnJPZlBhaXJzLnB1c2goenAgKyAicmVjZWl2ZWRJZF9fYyIsIGRvYy5kYklEKTsKYXJyT2ZQYWlycy5wdXNoKHpwICsgIm5ld0ZheF9fYyIsICJ0cnVlIik7CmFyck9mUGFpcnMucHVzaCh6cCArICJQYWdlc19fYyIsIFgoZG9jLCAiWF9wYWdlcyIpKTsKLy9hcnJPZlBhaXJzLnB1c2goenAgKyAiUHJvZ3JhbV9OYW1lX19jIiwgekRhdGEuY2xhc3NpZmljYXRpb24pOwovL2Fyck9mUGFpcnMucHVzaCh6cCArICJzZW50RmF4VG9fX2MiLCBkb2MuZGVsaXZlcmVkVG8pOyAvL0VSUzE3MDYyOCBjYWxsZXIgaWQKYXJyT2ZQYWlycy5wdXNoKHpwICsgIkZyb21fX2MiLCBkb2MuZGVsaXZlcmVkRnJvbSk7Ci8vYXJyT2ZQYWlycy5wdXNoKCJ6Q2FsbGVyX0lEX19jIiwgZG9jLmRlbGl2ZXJlZEZyb20pOyAvL01TSDE3MDgxNyBhZGRlZAphcnJPZlBhaXJzLnB1c2goenAgKyAiU3RhZ2VfX2MiLCAiUmVjZWl2ZWQiKTsgLy9FUlMxNzA3MzEgIzQwNTkzCi8vYXJyT2ZQYWlycy5wdXNoKHpwICsgIkNsYXNzaWZpY2F0aW9uX19jIiwgekRhdGEuY2xhc3NpZmljYXRpb24pOwoKdmFyIHNmSWQgPSBjcmVhdGVBbmRBdHRhY2goZG9jLCB6U3RhY2ssICJOZXcgU3RhY2sgcmVjZWl2ZWQgb24gIiArIGZvcm1hdE5vdywgYXJyT2ZQYWlycyk7CmFsZXJ0KCIjIyMjIFN0YWNrIFJlY2VpdmVkLiBBdHRhY2hlZCB0bzogIiArIHNmSWQpOwphcnJPZlBhaXJzID0gW107CmFyck9mUGFpcnMucHVzaCgiZGItbGFiZWwiLCAiTmV3IFN0YWNrIHJlY2VpdmVkIG9uICIgKyBmb3JtYXROb3cpOwphcnJPZlBhaXJzLnB1c2goImRiLUJBVEVTIiwgc2ZJZCArICItU1RBQ0siKTsKYXJyT2ZQYWlycy5wdXNoKCJYX3NmU3RhY2tJZCIsIHNmSWQpOyAvL0VSUzE3MDcyNyAjNDA0NDcKdXBkYXRlREIoZG9jLCBhcnJPZlBhaXJzKTsKLyogRU5EICovCg=="},"ordinal":8}

//--- RULE JSON REPRESENTATION - END ---

//--- RULE CONSEQUENCE CODE ---
//ERS170328 docType by OCR
zData.docTypeOCR = zData.docTyper(doc, {"PAPP":"Patient~ Assistance~", "PAUTH":"Prior~ Authorization~", "ENRL":"Enrollment~", "FAX":""});
alert("docType was " + doc.docType + " now " + zData.docTypeOCR);
var zType = doc.X("X_docType");
if (doc.docType != zData.docTypeOCR) {
    var arrOfPairs0 = [];
    arrOfPairs0.push("X_docTypeOCR", zData.docTypeOCR);
    arrOfPairs0.push("X_docType", zData.docTypeOCR);
    zType = zData.docTypeOCR; //ERS170330 saved below into SF faxType__c field
    updateDB(doc, arrOfPairs0);
}

var formatNow = getCurDateAndTime(doc);
var channel = "Fax"
if (isNaN(doc.deliveredFrom)) { // Not a Number is true
    channel = "Email";
}
var arrOfPairs = [];
var zp = "ZPAPER__"; //ERS170626 now in the package
var zStack = zp + "zStack__c";
arrOfPairs.push(zp + "faxType__c", zType);
arrOfPairs.push(zp + "Priority__c", "Medium");
arrOfPairs.push(zp + "Status__c", "New Stack");
arrOfPairs.push(zp + "Channel__c", channel);
/* MSH171116 using zStack_Received__c instead of latestFax__c
        because latestFax__c gets updated by save.jsp every time
        the record is updated
 */
/* arrOfPairs.push(zp + "latestFax__c", formatNow); */
arrOfPairs.push("ZPAPER__latestFax__c", formatNow);
arrOfPairs.push(zp + "receivedId__c", doc.dbID);
arrOfPairs.push(zp + "newFax__c", "true");
arrOfPairs.push(zp + "Pages__c", X(doc, "X_pages"));
//arrOfPairs.push(zp + "Program_Name__c", zData.classification);
//arrOfPairs.push(zp + "sentFaxTo__c", doc.deliveredTo); //ERS170628 caller id
arrOfPairs.push(zp + "From__c", doc.deliveredFrom);
//arrOfPairs.push("zCaller_ID__c", doc.deliveredFrom); //MSH170817 added
arrOfPairs.push(zp + "Stage__c", "Received"); //ERS170731 #40593
//arrOfPairs.push(zp + "Classification__c", zData.classification);

var sfId = createAndAttach(doc, zStack, "New Stack received on " + formatNow, arrOfPairs);
alert("#### Stack Received. Attached to: " + sfId);
arrOfPairs = [];
arrOfPairs.push("db-label", "New Stack received on " + formatNow);
arrOfPairs.push("db-BATES", sfId + "-STACK");
arrOfPairs.push("X_sfStackId", sfId); //ERS170727 #40447
updateDB(doc, arrOfPairs);
/* END */

//--- RULE CONSEQUENCE CODE - END ---

//--- RULE VALIDATION CODE ---
//--- RULE VALIDATION CODE - END ---

</script>
