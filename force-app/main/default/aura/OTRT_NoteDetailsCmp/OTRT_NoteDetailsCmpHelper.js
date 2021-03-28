({
    onNoteSearch : function(component, opptyId, noteModifiedStartDate, noteModifiedEndDate) {
        //
        // Load note search results from Salesforce
        //
        // Create the action (server request)
        var action = component.get("c.getNote");
        action.setParams({
            "opptyId" : opptyId,
            "modifiedStartDate" : noteModifiedStartDate,
            "modifiedEndDate" : noteModifiedEndDate
        });
        // Handle server response (Add callback behavior for when response is received)
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.note", response.getReturnValue());
                var noteId = component.get("v.note").Id;
                console.log("noteId: " + noteId);
                component.set("v.noteId", noteId);                
                // Reload record using Lightning Data Service 
                var serviceRecordData = component.find("service");        
                serviceRecordData.set("v.recordId", noteId);
                serviceRecordData.reloadRecord();
                if (component.find("noteDetail")) {
                    console.log("Note Detail has been initialized. Call the method in OTRT_NoteDetailCmp component.");
                    // Call a method in OTRT_NoteDetailCmp component and update note content every time note Id is changed
                    var OTRT_NoteDetailCmp = component.find("noteDetail").refresh();                    
                } else {
                    console.log("Note Detail has not been initialized. Do nothing.");
                    // The doInit in OTRT_NoteDetailCmp client-side controller will initialize the note content
                }
            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action (server request) off to be executed
        $A.enqueueAction(action);
    },
})