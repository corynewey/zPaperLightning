({
    isDefined: function (ele) {
        return undefined !== ele && null !== ele;
    },

    isBlank: function (ele) {
        return undefined === ele || null === ele || 0 === ele.length;
    }
})