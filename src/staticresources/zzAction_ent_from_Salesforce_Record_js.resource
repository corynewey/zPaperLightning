<!--
// Name: Detach Document from Salesforce Record
// Committer: cory.newey@zpaper.com
// Update: creation
-->
<script>
//--- RULE JSON REPRESENTATION ---
var ruleJson = {"type":"rool","updated":"2018-04-05 18:57:02","active":true,"button":"","name":"Detach Document from Salesforce Record","conditions":{"logic":"and","arguments":[{"name":"doc.X(\"X_buttonAction\")","value":"DETACH_DOCUMENT","operation":"equals"}]},"consequence":{"doit":"YWxlcnQoIkBAQEBAIERFVEFDSF9ET0NVTUVOVCBldmVudCBoYW5kbGVkIEBAQEBAIik7CnZhciBhcnJPZlBhaXJzID0gW107CmFyck9mUGFpcnMucHVzaCgiWF9idXR0b25BY3Rpb24iLCAiIik7CnVwZGF0ZURCKGRvYywgYXJyT2ZQYWlycyk7CgphbGVydCgiJCQkIGRldGFjaCBsZWF2aW5nIHJ1bGUgJCQkIik7Cg=="},"ordinal":10}

//--- RULE JSON REPRESENTATION - END ---

//--- RULE CONSEQUENCE CODE ---
alert("@@@@@ DETACH_DOCUMENT event handled @@@@@");
var arrOfPairs = [];
arrOfPairs.push("X_buttonAction", "");
updateDB(doc, arrOfPairs);

alert("$$$ detach leaving rule $$$");

//--- RULE CONSEQUENCE CODE - END ---

//--- RULE VALIDATION CODE ---
//--- RULE VALIDATION CODE - END ---

</script>
