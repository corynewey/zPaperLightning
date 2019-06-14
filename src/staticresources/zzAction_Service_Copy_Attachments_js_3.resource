<!--
// Name: Service: Copy Attachments
// Committer: cory.newey@zpaper.com
// Update: Attaching to lead-derived records now
-->
<script>
//--- RULE JSON REPRESENTATION ---
var ruleJson = {"type":"rool","updated":"2017-11-17 16:55:06","active":true,"button":"","name":"Service: Copy Attachments","conditions":{"logic":"and","arguments":[{"name":"doc.X(\"X_service\")","value":"COPY_ATTACHMENTS","operation":"equals"}]},"consequence":{"doit":"YWxlcnQoIkBAQEBAIENPUFlfQVRUQUNITUVOVFMgU2VydmljZSBSZXF1ZXN0IFJlY2VpdmVkIEBAQEBAIik7CmNsZWFyRXZlbnQoZG9jLCAiWF9zZXJ2aWNlIik7CmFsZXJ0KCIjIyBYX3NlcnZpY2UgZXZlbnQgY2xlYXJlZCAjIyIpOwp2YXIgbGVhZElkID0gZG9jLnNmSUQ7CnZhciBjb250YWN0SWQgPSBYKGRvYywgIlhfY29udGFjdElkIik7CnZhciBhY2NvdW50SWQgPSBYKGRvYywgIlhfYWNjb3VudElkIik7CnZhciBvcHBvcnR1bml0eUlkID0gWChkb2MsICJYX29wcG9ydHVuaXR5SWQiKTsKdmFyIGF0dElkcyA9IGdldEF0dGFjaG1lbnRzRm9yU0ZSZWNvcmQoZG9jLCBsZWFkSWQpOwphbGVydCgiIyMgTnVtYmVyIG9mIGF0dGFjaG1lbnRzIGZvdW5kID0gIiArIGF0dElkcy5sZW5ndGgpOwpmb3IgKHZhciBpZHggaW4gYXR0SWRzKSB7CiAgICB2YXIgYXR0SWQgPSBhdHRJZHNbaWR4XTsKICAgIGFsZXJ0KCIjIyBTbmlwcGV0IElkIHRoYXQgaXMgYXR0YWNoZWQgYWxyZWFkeTogIiArIGF0dElkKTsKICAgIHNldERvY3VtZW50Q29udGV4dChkb2MsIGF0dElkKTsKICAgIGlmIChjb250YWN0SWQpIHsKICAgICAgICBhbGVydCgiIyMgQXR0YWNoaW5nIHRvIENvbnRhY3QgcmVjb3JkIHdpdGggSWQ6ICIgKyBjb250YWN0SWQpOwogICAgICAgIGF0dGFjaChkb2MsICJBdHRhY2htZW50IG1pZ3JhdGVkIGZyb20gTGVhZCByZWNvcmQ6ICIgKyBsZWFkSWQsIGNvbnRhY3RJZCk7CiAgICB9CiAgICBpZiAoYWNjb3VudElkKSB7CiAgICAgICAgYWxlcnQoIiMjIEF0dGFjaGluZyB0byBBY2NvdW50IHJlY29yZCB3aXRoIElkOiAiICsgYWNjb3VudElkKTsKICAgICAgICBhdHRhY2goZG9jLCAiQXR0YWNobWVudCBtaWdyYXRlZCBmcm9tIExlYWQgcmVjb3JkOiAiICsgbGVhZElkLCBhY2NvdW50SWQpOwogICAgfQogICAgaWYgKG9wcG9ydHVuaXR5SWQpIHsKICAgICAgICBhbGVydCgiIyMgQXR0YWNoaW5nIHRvIE9wcG9ydHVuaXR5IHJlY29yZCB3aXRoIElkOiAiICsgb3Bwb3J0dW5pdHlJZCk7CiAgICAgICAgYXR0YWNoKGRvYywgIkF0dGFjaG1lbnQgbWlncmF0ZWQgZnJvbSBMZWFkIHJlY29yZDogIiArIGxlYWRJZCwgb3Bwb3J0dW5pdHlJZCk7CiAgICB9Cn0="},"ordinal":5}

//--- RULE JSON REPRESENTATION - END ---

//--- RULE CONSEQUENCE CODE ---
alert("@@@@@ COPY_ATTACHMENTS Service Request Received @@@@@");
clearEvent(doc, "X_service");
alert("## X_service event cleared ##");
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
