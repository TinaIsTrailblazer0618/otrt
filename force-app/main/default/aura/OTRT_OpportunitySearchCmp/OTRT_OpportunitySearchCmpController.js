({
    onFormSubmit : function(component, event, helper) {
        var formData = event.getParam("formData");
        var opptyRecordTypeId = formData.opptyRecordTypeId;
        var isShowingOpenOppties = formData.isShowingOpenOppties;
        var isShowingClosedWonOppties = formData.isShowingClosedWonOppties;
        var isShowingClosedLostOppties = formData.isShowingClosedLostOppties;
        var noteModifiedStartDate = formData.noteModifiedStartDate;
        var noteModifiedEndDate = formData.noteModifiedEndDate;
        console.info("opptyRecordTypeId in Oppty Search: " + opptyRecordTypeId);
        console.info("isShowingOpenOppties in Oppty Search: " + isShowingOpenOppties);
        console.info("isShowingClosedWonOppties in Oppty Search: " + isShowingClosedWonOppties);
        console.info("isShowingClosedLostOppties in Oppty Search: " + isShowingClosedLostOppties);
        console.info("noteModifiedStartDate in Oppty Search: " + noteModifiedStartDate);
        console.info("noteModifiedEndDate in Oppty Search: " + noteModifiedEndDate);
        //cmp.sampleMethod(param1) e.g. component.find("boatSearchResults") = cmp; search = sampleMethod; opptyRecordTypeId = param1
        var opptySearchResult = component.find("opptySearchResults").search(opptyRecordTypeId, isShowingOpenOppties, isShowingClosedWonOppties, 
            isShowingClosedLostOppties, noteModifiedStartDate, noteModifiedEndDate);
        console.info("auraMethodResult: " + opptySearchResult);
    }
})