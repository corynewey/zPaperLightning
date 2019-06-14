<!--
// Name: Service: Copy Attachments
// Committer: cory.newey@zpaper.com
// Update: uiui
-->
<script>
//--- RULE JSON REPRESENTATION ---
var ruleJson = {"type":"rool","updated":"2017-11-19 13:33:42","active":true,"button":"","name":"Service: Copy Attachments","conditions":{"logic":"and","arguments":[{"name":"doc.X(\"X_service\")","value":"COPY_ATTACHMENTS","operation":"equals"}]},"consequence":{"doit":"YWxlcnQoIkBAQEBAIENPUFlfQVRUQUNITUVOVFMgU2VydmljZSBSZXF1ZXN0IFJlY2VpdmVkIEBAQEBAIik7CmNsZWFyRXZlbnQoZG9jLCAiWF9zZXJ2aWNlIik7CmFsZXJ0KCIjIyBYX3NlcnZpY2UgZXZlbnQgY2xlYXJlZCAjIyIpOwphbGVydCgiIyMjIyBPcmlnaW5hbCBkYklEID0gIiArIGRvYy5kYklEKTsKdmFyIGxlYWRJZCA9IGRvYy5zZklEOwp2YXIgY29udGFjdElkID0gWChkb2MsICJYX2NvbnRhY3RJZCIpOwp2YXIgYWNjb3VudElkID0gWChkb2MsICJYX2FjY291bnRJZCIpOwp2YXIgb3Bwb3J0dW5pdHlJZCA9IFgoZG9jLCAiWF9vcHBvcnR1bml0eUlkIik7CnZhciBhdHRJZHMgPSBnZXRBdHRhY2htZW50c0ZvclNGUmVjb3JkKGRvYywgbGVhZElkKTsKYWxlcnQoIiMjIE51bWJlciBvZiBhdHRhY2htZW50cyBmb3VuZCA9ICIgKyBhdHRJZHMubGVuZ3RoKTsKZm9yICh2YXIgaWR4IGluIGF0dElkcykgewogICAgdmFyIGF0dElkID0gYXR0SWRzW2lkeF07CiAgICBhbGVydCgiIyMgU25pcHBldCBJZCB0aGF0IGlzIGF0dGFjaGVkIGFscmVhZHk6ICIgKyBhdHRJZCk7CiAgICBzZXREb2N1bWVudENvbnRleHQoZG9jLCBhdHRJZCk7CiAgICBpZiAoY29udGFjdElkKSB7CiAgICAgICAgYWxlcnQoIiMjIEF0dGFjaGluZyB0byBDb250YWN0IHJlY29yZCB3aXRoIElkOiAiICsgY29udGFjdElkKTsKICAgICAgICBhdHRhY2goZG9jLCAiQXR0YWNobWVudCBtaWdyYXRlZCBmcm9tIExlYWQgcmVjb3JkOiAiICsgbGVhZElkLCBjb250YWN0SWQpOwogICAgfQogICAgaWYgKGFjY291bnRJZCkgewogICAgICAgIGFsZXJ0KCIjIyBBdHRhY2hpbmcgdG8gQWNjb3VudCByZWNvcmQgd2l0aCBJZDogIiArIGFjY291bnRJZCk7CiAgICAgICAgYXR0YWNoKGRvYywgIkF0dGFjaG1lbnQgbWlncmF0ZWQgZnJvbSBMZWFkIHJlY29yZDogIiArIGxlYWRJZCwgYWNjb3VudElkKTsKICAgIH0KICAgIGlmIChvcHBvcnR1bml0eUlkKSB7CiAgICAgICAgYWxlcnQoIiMjIEF0dGFjaGluZyB0byBPcHBvcnR1bml0eSByZWNvcmQgd2l0aCBJZDogIiArIG9wcG9ydHVuaXR5SWQpOwogICAgICAgIGF0dGFjaChkb2MsICJBdHRhY2htZW50IG1pZ3JhdGVkIGZyb20gTGVhZCByZWNvcmQ6ICIgKyBsZWFkSWQsIG9wcG9ydHVuaXR5SWQpOwogICAgfQp9"},"ordinal":5}

//--- RULE JSON REPRESENTATION - END ---

//--- RULE CONSEQUENCE CODE ---
alert("@@@@@ COPY_ATTACHMENTS Service Request Received @@@@@");
clearEvent(doc, "X_service");
alert("## X_service event cleared ##");
alert("#### Original dbID = " + doc.dbID);
var leadId = doc.sfID;
var contactId = X(doc, "X_contactId");
var accountId = X(doc, "X_accountId");
var opportunityId = X(doc, "X_opportunityId");
var attIds = getAttachmentsForSFRecord(doc, leadId);
alert("## Number of attachments found = " + attIds.length);
for (var idx in attIds) {
    var attId = attIds[idx];
    alert("## Snippet Id that is attached already: " + attId);
    setDocumentContext(doc, attId);
    if (contactId) {
        alert("## Attaching to Contact record with Id: " + contactId);
        attach(doc, "Attachment migrated from Lead record: " + leadId, contactId);
    }
    if (accountId) {
        alert("## Attaching to Account record with Id: " + accountId);
        attach(doc, "Attachment migrated from Lead record: " + leadId, accountId);
    }
    if (opportunityId) {
        alert("## Attaching to Opportunity record with Id: " + opportunityId);
        attach(doc, "Attachment migrated from Lead record: " + leadId, opportunityId);
    }
}
//--- RULE CONSEQUENCE CODE - END ---

//--- RULE VALIDATION CODE ---
//--- RULE VALIDATION CODE - END ---

</script>
