({
    isBlank: function (ele) {
        return undefined === ele || null === ele || 0 === ele.length;
    },
    getReplaceProperty: function (str, objName) {
        objName += '.';
        var idx = str.indexOf(objName);
        if (idx >= 0) {
            return str.substring(idx + objName.length);
        }
    },
    removeActionFromList: function (actionArr, action) {
        var idx = actionArr.indexOf(action);
        if (idx >= 0) {
            actionArr.splice(idx, 1);
        }
    }
})