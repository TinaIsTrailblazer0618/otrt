({
    decodeNoteContent : function(component, noteId) {
        //
        // Load note content (decoded as a string) from Salesforce
        //
        // Create the action (server request)
        var action = component.get("c.decodeNoteContent");
        action.setParams({
            "noteId" : noteId,
        });
        // Handle server response (Add callback behavior for when response is received)
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.content", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action (server request) off to be executed
        $A.enqueueAction(action);
    }
})