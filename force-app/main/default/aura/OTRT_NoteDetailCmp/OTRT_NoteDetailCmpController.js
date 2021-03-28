({
    doInit : function(component, event, helper) {
        component.set('v.showButton', $A.get('e.force:navigateToSObject'));
        var noteId = component.get("v.note").Id;
        helper.decodeNoteContent(component, noteId);
    },

    onFullDetails : function(component, event, helper) {
        var recordId = component.get("v.note.Id"); 
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": recordId,
          "slideDevName": "detail" // You can set a specific slide in the Salesforce app, but not in Lightning Experience.
        });
        navEvt.fire();
    },
})