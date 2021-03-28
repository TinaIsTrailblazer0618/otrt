({
    doInit : function(component, event, helper) {
        // Retrieve static labels
        var staticLabel1 = $A.get("$Label.c.Missing_Record_Type");
        var staticLabel2 = $A.get("$Label.c.Missing_Date_Range");
        var staticLabel3 = $A.get("$Label.c.Incorrect_Date_Range");
        component.set("v.missingRecordTypeError", staticLabel1);
        component.set("v.missingDateRangeError", staticLabel2);
        component.set("v.incorrectDateRangeError", staticLabel3);
        // Load oppty record types from Salesforce
        // Create the action
        var action = component.get("c.getOpptyRecordTypes");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                component.set("v.opptyRecordTypeOptions", response.getReturnValue());          
            } else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        // Call helper method
        helper.newButtonDisplaySetting(component);
    },

    handleCreateOppty : function(component, event, helper) {
        var selectedOption = component.get("v.selectedOpptyRecordType");
        console.info("create new function starts with: " + selectedOption);
        if (selectedOption) {
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId": selectedOption,
                "defaultFieldValues": { 
                    'StageName': 'Qualification'
                }            
            });
            createRecordEvent.fire();
        } else {
            alert(component.get("v.missingRecordTypeError"));        
        } 
    },

    handleToggleChange_one : function(component, event, helper) {
        var toggleVal1 = component.find("inputToggle1").get("v.checked");
        component.set("v.isShowingOpenOppties", toggleVal1);
        console.log('isShowingOpenOppties value: ' + toggleVal1);
    },

    handleToggleChange_two : function(component, event, helper) {
        var toggleVal2 = component.find("inputToggle2").get("v.checked");
        component.set("v.isShowingClosedWonOppties", toggleVal2);
        console.log('isShowingClosedWonOppties value: ' + toggleVal2);
    },

    handleToggleChange_three : function(component, event, helper) {
        var toggleVal3 = component.find("inputToggle3").get("v.checked");
        component.set("v.isShowingClosedLostOppties", toggleVal3);
        console.log('isShowingClosedLostOppties value: ' + toggleVal3);
    },

    onFormSubmit : function(component, event, helper) {
        var noteModifiedStartDate = component.get("v.selectedNoteModifiedStartDate");
        var noteModifiedEndDate = component.get("v.selectedNoteModifiedEndDate");
        var opptyRecordTypeId = component.get("v.selectedOpptyRecordType");
        if (opptyRecordTypeId) {
            if (noteModifiedStartDate && noteModifiedEndDate) {
                var startDate = new Date(noteModifiedStartDate);
                var endDate = new Date(noteModifiedEndDate);
                if (startDate.getTime() <= endDate.getTime()) {
                    var isShowingOpenOppties = component.get("v.isShowingOpenOppties");          
                    var isShowingClosedWonOppties = component.get("v.isShowingClosedWonOppties");            
                    var isShowingClosedLostOppties = component.get("v.isShowingClosedLostOppties");                           
                    // Create event for OTRT_OpportunitySearchCmp to listen to
                    var createEvent = component.getEvent("formSubmit");
                    console.log('createEvent: ' + createEvent);
                    createEvent.setParams({"formData" : {"opptyRecordTypeId" : opptyRecordTypeId,
                                                        "isShowingOpenOppties" : isShowingOpenOppties,
                                                        "isShowingClosedWonOppties" : isShowingClosedWonOppties,
                                                        "isShowingClosedLostOppties" : isShowingClosedLostOppties,
                                                        "noteModifiedStartDate" : noteModifiedStartDate,
                                                        "noteModifiedEndDate" : noteModifiedEndDate,
                                                        "renderedOnce" : true}});
                    // When the event is fired, the OTRT_OpportunitySearchCmp action in the client-side controller of the handler component is invoked
                    createEvent.fire();
                } else {
                    alert(component.get("v.incorrectDateRangeError"));
                }
            } else {
                alert(component.get("v.missingDateRangeError"));
            }
        } else {
            alert(component.get("v.missingRecordTypeError"));
        }
    },
})