({
    doInit : function(component, event, helper) {
        var actions = [
            {label: 'Edit Details', name: 'edit_details'},
            {label: 'Show Details', name: 'show_details'},
            {label: 'Show Notes', name: 'show_notes'}
        ];
        component.set('v.columnsCEB', [
            {type: 'action', typeAttributes: {rowActions: actions}},
            {label: 'Opportunity Owner', fieldName: 'OpportunityOwner', type: 'text', sortable: true, initialWidth: 150},
            {label: 'Opportunity Name', fieldName: 'Name', type: 'text', initialWidth: 130, wrapText: true},
            {label: 'Stage', fieldName: 'StageName', type: 'text', sortable: true, initialWidth: 80},
            // {label: 'Close Date', fieldName: 'CloseDate', type: 'date', sortable: true, initialWidth: 120},
            {label: 'Business Volume', fieldName: 'Amount', type: 'currency', initialWidth: 100},
            // {label: 'Tier', fieldName: 'Opportunity_Tier__c', type: 'text', sortable: true, initialWidth: 80},
            // {label: 'Finance Type', fieldName: 'Finance_Type__c', type: 'text', initialWidth: 140},
            // {label: 'Business Type', fieldName: 'Business_Type__c', type: 'text', initialWidth: 140},            
            // {label: 'C4 KA', fieldName: 'C4_KA__c', type: 'text', initialWidth: 80},
            // {label: 'Super KA', fieldName: 'Super_KA__c', type: 'text', initialWidth: 80},
            {label: 'Employee No.', fieldName: 'Employee_No__c', type: 'number', initialWidth: 100},
            {label: 'Condor', fieldName: 'Condor__c', type: 'text', initialWidth: 80},
            {label: 'Industry', fieldName: 'Industry__c', type: 'text', initialWidth: 100, wrapText: true},
            {label: 'Region', fieldName: 'Region__c', type: 'text', initialWidth: 80, wrapText: true},
            {label: 'Competitor', fieldName: 'Competitor__c', type: 'text', initialWidth: 100, wrapText: true},
        ]);
        component.set('v.columnsCIR', [
            {type: 'action', typeAttributes: {rowActions: actions}},
            {label: 'Opportunity Owner', fieldName: 'OpportunityOwner', type: 'text', sortable: true, initialWidth: 150},
            {label: 'Opportunity Name', fieldName: 'Name', type: 'text', initialWidth: 130, wrapText: true},
            {label: 'Stage', fieldName: 'StageName', type: 'text', sortable: true, initialWidth: 80},
            {label: 'Business Volume', fieldName: 'Amount', type: 'currency', initialWidth: 100},
            {label: 'Employee No.', fieldName: 'Employee_No__c', type: 'number', initialWidth: 100},
            {label: 'Condor', fieldName: 'Condor__c', type: 'text', initialWidth: 80},
            {label: 'Industry', fieldName: 'Industry__c', type: 'text', initialWidth: 100, wrapText: true},
            {label: 'Region', fieldName: 'Region__c', type: 'text', initialWidth: 80, wrapText: true},
            {label: 'Competitor', fieldName: 'Competitor__c', type: 'text', initialWidth: 100, wrapText: true},
        ]);
        component.set('v.columnsM', [
            {type: 'action', typeAttributes: {rowActions: actions}},
            {label: 'Opportunity Owner', fieldName: 'OpportunityOwner', type: 'text', sortable: true},
            {label: 'Opportunity Name', fieldName: 'Name', type: 'text', wrapText: true},
            {label: 'Stage', fieldName: 'StageName', type: 'text', sortable: true},
            {label: 'Competitor', fieldName: 'Competitor__c', type: 'text', wrapText: true},
        ]);               
    },

    doSearch : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var opptyRecordTypeId = params.opptyRecordTypeId;
            var isShowingOpenOppties = params.isShowingOpenOppties;
            var isShowingClosedWonOppties = params.isShowingClosedWonOppties;
            var isShowingClosedLostOppties = params.isShowingClosedLostOppties;
            var noteModifiedStartDate = params.noteModifiedStartDate;
            var noteModifiedEndDate = params.noteModifiedEndDate;
            component.set('v.opptyRecordTypeId', opptyRecordTypeId);
            component.set('v.isShowingOpenOppties', isShowingOpenOppties);
            component.set('v.isShowingClosedWonOppties', isShowingClosedWonOppties);
            component.set('v.isShowingClosedLostOppties', isShowingClosedLostOppties);           
            component.set('v.noteModifiedStartDate', noteModifiedStartDate);
            component.set('v.noteModifiedEndDate', noteModifiedEndDate);
            helper.onSearch(component, helper, opptyRecordTypeId, isShowingOpenOppties,
                isShowingClosedWonOppties, isShowingClosedLostOppties, 
                noteModifiedStartDate, noteModifiedEndDate);
        }
    },
            
	// Called by the onsort event handler
    handleSort : function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');     
        // Assign the latest attribute with the sorted column fieldName and sorted direction
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', fieldName);
        helper.sortData(component, helper, fieldName, sortDirection);
    },        

    handleRowAction : function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'edit_details':
                component.set('v.recordId', row.Id);
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                        "recordId": component.get("v.recordId")
                });
                editRecordEvent.fire();
                /*component.set("v.currentView","RecordView");
                var evt = $A.get("e.c:eventShowContactClicked");
                evt.setParams({
                    "isOpen" : true
                });
                evt.fire();*/
                break;
            case 'show_details':
                component.set('v.recordId', row.Id);
                var navEvent = $A.get("e.force:navigateToSObject");
                navEvent.setParams({
                  "recordId": component.get("v.recordId")
                });
                navEvent.fire();
                /*component.set("v.currentView","RecordView");
                var evt = $A.get("e.c:eventShowContactClicked");
                evt.setParams({
                    "isOpen" : true
                });
                evt.fire();*/
                break;            
            case 'show_notes':
                // Fire oppty object for NoteDetails to handle
                var selectedOppty = row;
                var noteRevisedStartDate = component.get("v.noteModifiedStartDate");
                var noteRevisedEndDate = component.get("v.noteModifiedEndDate");
                var createEvent = $A.get("e.c:OTRT_OpportunitySelectedEvt"); // Application Event
                createEvent.setParams({"oppty" : selectedOppty,
                                        "noteModifiedStartDate" : noteRevisedStartDate,
                                        "noteModifiedEndDate" : noteRevisedEndDate});
                console.log("createEvent - oppty in OTRT_OpportunitySearchResultsCmp: " + JSON.stringify(selectedOppty));
                console.log("createEvent - noteModifiedStartDate in OTRT_OpportunitySearchResultsCmp: " + noteRevisedStartDate);
                console.log("createEvent - noteModifiedEndDate in OTRT_OpportunitySearchResultsCmp: " + noteRevisedEndDate);
                createEvent.fire();
                /*component.set('v.recordId', row.Id);
                component.set("v.currentView","RecordEdit");
                var evt = $A.get("e.c:eventShowNotesContactClicked");
                evt.setParams({
                    "isOpen" : true
                });
                evt.fire();*/
                break;
        }
    },

    refresh : function(component, event, helper) {
        var eventMsg = event.getParam("message").toUpperCase();
        console.log("eventMsg in OTRT_OpportunitySearchResultsCmp: " + eventMsg);
        if (eventMsg && eventMsg.includes("OPPORTUNITY") && eventMsg.includes("WAS SAVED")) {
            component.set("v.doRefresh", true);
            var opptyRecordTypeId = component.get('v.opptyRecordTypeId');
            var isShowingOpenOppties = component.get('v.isShowingOpenOppties');
            var isShowingClosedWonOppties = component.get('v.isShowingClosedWonOppties');
            var isShowingClosedLostOppties = component.get('v.isShowingClosedLostOppties');            
            var noteModifiedStartDate = component.get('v.noteModifiedStartDate');
            var noteModifiedEndDate = component.get('v.noteModifiedEndDate');
            helper.onSearch(component, helper, opptyRecordTypeId, isShowingOpenOppties,
                isShowingClosedWonOppties, isShowingClosedLostOppties, 
                noteModifiedStartDate, noteModifiedEndDate);
        }
    },

    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },

    /*
     * This function is called on click on the "Download as CSV" Button
     */      
    downloadCsv : function(component, event, helper) {
        // Get the records [Opportunity] list from 'oppties' attribute 
        var csvData = component.get("v.oppties");
        
        // Call the helper function which "returns" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, csvData);   
            if (csv == null) {
                return;
            } 
        
        // Convert UI display of data export date format from 7_5_2020 to 07052020
        var fileDate = new Date().toLocaleDateString('en-US', { timeZone: 'Asia/Taipei' })
        var arr = fileDate.split("/");
        var day = (arr[0].length === 2) ? arr[0] : "0" + arr[0];
        var month = (arr[1].length === 2) ? arr[1] : "0" + arr[1];
        var year = arr[2];

        // Code for create a temp. <a> html tag [link tag] for download the CSV file
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,%EF%BB%BF' + encodeURI(csv);
        hiddenElement.target = '_self'; // where to open the linked document
        hiddenElement.download = 'OTRT_DataExport_' + day + month + year + '.csv'; // CSV file name
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },     
})