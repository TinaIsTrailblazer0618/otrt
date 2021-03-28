({
    /*
     * This function will build table data
     * by loading oppty search results from Salesforce
     */     
    onSearch : function(component, helper, opptyRecordTypeId, isShowingOpenOppties, 
        isShowingClosedWonOppties, isShowingClosedLostOppties, 
        noteModifiedStartDate, noteModifiedEndDate) {
        console.log("onSearch is called!");
        // Create the action (server request)
        var action = component.get("c.getOpportunities");
        action.setParams({
            "opptyRecordTypeId" : opptyRecordTypeId,
            "isShowingOpenOppties" : isShowingOpenOppties,
            "isShowingClosedWonOppties" : isShowingClosedWonOppties,
            "isShowingClosedLostOppties" : isShowingClosedLostOppties,
            "noteModifiedStartDate" : noteModifiedStartDate,
            "noteModifiedEndDate" : noteModifiedEndDate,
        });
        // Handle server response (Add callback behavior for when response is received)
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                console.log("OTRT_OpportunitySearchResultsCmpHelper -- search results: " + rows.length);
                if (rows) {
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        // Check if any Owner related data in row
                        if (row.Owner) {
                            row.OpportunityOwner = row.Owner.Name;
                        } 
                    }
                    // Set formatted data to the datatable
                    component.set("v.oppties", rows);
                    component.set("v.totalPages", Math.ceil(rows.length/component.get("v.pageSize")));
                    // Check to see if it's a refresh request
                    var doRefresh = component.get("v.doRefresh");
                    console.log("Keep the current page number if it's a refresh request: " + doRefresh);
                    if (!doRefresh) {
                        component.set("v.currentPageNumber", 1);
                    }
                    if (doRefresh) {
                        // Reset component attribute doRefresh to its default value, which is [false]
                        component.set("v.doRefresh", false);
                    }
                    helper.buildData(component, helper);
                }
            } else {
                console.log("OTRT_OpportunitySearchResultsCmpHelper -- failed with state: " + state);
            }
        });
        // Send action (server request) off to be executed
        $A.enqueueAction(action);
    },

    /*
     * This function will update the table with the new column index and sort direction
     */    
    sortData : function (component, helper, fieldName, sortDirection) {
        var cloneData = component.get("v.oppties");
        var reverse = sortDirection !== 'asc';
        // Sorts the rows based on the column header that's clicked
        cloneData.sort((this.sortBy(fieldName, reverse)));        
        component.set("v.oppties", cloneData);
        helper.buildData(component, helper);
    },
    
    // Used to sort the columns
    sortBy : function (field, reverse, primer) {
        var key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };
		// checks if the two rows should switch places
		reverse = !reverse ? 1 : -1;
        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },
    
    /*
     * This function will build table data
     * based on current page selection
     */
    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.oppties");
        var x = (pageNumber - 1) * pageSize;
        
        // Creating data-table data
        for (; x <= (pageNumber) * pageSize; x++) {
            if (allData[x]) {
            	data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * This function generates page list
     */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if (totalPages > 1) {
            if (totalPages <= 10) {
                var counter = 2;
                for (; counter < (totalPages); counter++) {
                    pageList.push(counter);
                } 
            } else {
                if (pageNumber < 5) {
                    pageList.push(2, 3, 4, 5, 6);
                } else {
                    if (pageNumber > (totalPages - 5)) {
                        pageList.push(totalPages - 5, totalPages - 4, totalPages - 3, totalPages - 2, totalPages-1);
                    } else { 
                        pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },

    /*
     * This function will convert table data to CSV format string for download
     */    
    convertArrayOfObjectsToCSV : function(component, objectRecords) {
        // Declare variables
        var csvStringResult, counter, labels, keys, columnDivider, lineDivider;
        
        // Check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }

        // Store ,[comma] in columnDivider variable for sparate CSV values and, 
        // for starting a new line, use '\n' [new line] in lineDivider variable  
        columnDivider = ',';
        lineDivider = '\n';
        // These labels are used in CSV file header  
        labels = ['Opportunity Owner', 'Opportunity Name', 'Stage', 'Business Volume', 'Employee No.', 
            'Condor', 'Industry', 'Region', 'Competitor'];
        // In the keys variables, store fields API Names as a key 
        keys = ['OpportunityOwner', 'Name', 'StageName', 'Amount', 'Employee_No__c', 
            'Condor__c', 'Industry__c', 'Region__c', 'Competitor__c'];
        
        csvStringResult = '';
        csvStringResult += labels.join(columnDivider);
        csvStringResult += lineDivider;

        for (var i = 0; i < objectRecords.length; i++) {   
            counter = 0;
            for (var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                // Add , [comma] after every String value,. [except first]
                if (counter > 0) { 
                    csvStringResult += columnDivider; 
                }   
                csvStringResult += '"' + objectRecords[i][skey] + '"';     
                counter++;
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV format String 
        return csvStringResult;        
    },    
})