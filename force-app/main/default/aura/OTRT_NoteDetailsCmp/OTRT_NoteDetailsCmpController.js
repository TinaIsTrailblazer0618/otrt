({
    onOpptySelected : function(component, event, helper) {
        // Set oppty Id from OTRT_OpportunitySearchResultsCmp
        var oppty = event.getParam("oppty");
        var noteModifiedStartDate = event.getParam("noteModifiedStartDate");
        var noteModifiedEndDate = event.getParam("noteModifiedEndDate");
        component.set("v.oppty", oppty);
        console.log("oppty in NoteDetails: " + JSON.stringify(oppty));
        console.log("noteModifiedStartDate in NoteDetails: " + noteModifiedStartDate);
        console.log("noteModifiedEndDate in NoteDetails: " + noteModifiedEndDate);
        var opptyId = oppty.Id;
        helper.onNoteSearch(component, opptyId, 
            noteModifiedStartDate, noteModifiedEndDate);
    },

    handleActive : function (component, event, helper) {
        console.info("current tab: " + component.get("v.selectedTabId") );		
		const selectedTabId = event.getSource().get('v.id');
		console.info("tab clicked: " + selectedTabId + " in NoteDetails");
		// Set tab id
        component.find("tabs").set("v.selectedTabId", selectedTabId);
    }
})