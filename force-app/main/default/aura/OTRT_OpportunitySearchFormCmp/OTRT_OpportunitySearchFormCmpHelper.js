({
    newButtonDisplaySetting : function(component) {
        // The The OTRT_OpptySearchFormCmp helper checks 
        // whether the event.force:createRecord event is supported by a standalone app 
        // and either shows or hides the New button according to best practices. 
        component.set('v.showButton', $A.get('e.force:createRecord'));
    }
})