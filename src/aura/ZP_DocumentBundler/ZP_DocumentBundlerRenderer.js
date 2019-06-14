({
    afterRender: function(cmp, helper) {
        this.superAfterRender();
        debugger;
        helper.expandModal(cmp, helper);
    }
})