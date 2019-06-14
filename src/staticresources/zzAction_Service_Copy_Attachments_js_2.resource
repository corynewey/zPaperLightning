<!--
// Name: Service: Copy Attachments
// Committer: cory.newey@zpaper.com
// Update: Clearing event
-->
<script>
//--- RULE JSON REPRESENTATION ---
var ruleJson = {"type":"rool","updated":"2017-11-16 14:19:45","active":true,"button":"","name":"Service: Copy Attachments","conditions":{"logic":"and","arguments":[{"name":"doc.X(\"X_service\")","value":"COPY_ATTACHMENTS","operation":"equals"}]},"consequence":{"doit":"YWxlcnQoIkBAQEBAIENPUFlfQVRUQUNITUVOVFMgU2VydmljZSBSZXF1ZXN0IFJlY2VpdmVkIEBAQEBAIik7CmNsZWFyRXZlbnQoZG9jLCAiWF9zZXJ2aWNlIik7CmFsZXJ0KCIjIyBYX3NlcnZpY2UgZXZlbnQgY2xlYXJlZCAjIyIpOwo="},"ordinal":5}

//--- RULE JSON REPRESENTATION - END ---

//--- RULE CONSEQUENCE CODE ---
alert("@@@@@ COPY_ATTACHMENTS Service Request Received @@@@@");
clearEvent(doc, "X_service");
alert("## X_service event cleared ##");

//--- RULE CONSEQUENCE CODE - END ---

//--- RULE VALIDATION CODE ---
//--- RULE VALIDATION CODE - END ---

</script>
