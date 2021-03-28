/**
 * @author Tina Chang
 * @name OTRT_OpptySearchResultsController
 * @builtDate 8th July, 2020
 * @description Controller for OTRT_OpportunitySearchResultsCmp
**/
public with sharing class OTRT_OpptySearchResultsController {
    
    @TestVisible static String strSOQLOppty;
    static DateTime contentModifiedStartDate;
    static DateTime contentModifiedEndDate;
    static Set<String> opptyAccessFields;
    static Set<String> opptySetFields;

    @AuraEnabled
    public static List<Opportunity> getOpportunities(String opptyRecordTypeId, 
                                                    Boolean isShowingOpenOppties,
                                                    Boolean isShowingClosedWonOppties,
                                                    Boolean isShowingClosedLostOppties,
                                                    DateTime noteModifiedStartDate,
                                                    DateTime noteModifiedEndDate) {
        /** 
         * @what Enforce CRUD/FLS 
         * @description Query for Custom Metadata Type Field__mdt, a centralized place for fields used by lightning data table
         *  And where admin or developer can manage (add/edit/remove) fields for display.
         */
        opptyAccessFields = new Set<String>();
        opptySetFields = new Set<String>();        
        for (Field__mdt opptyField : [SELECT Field_API_Name__c, Entity__c FROM Field__mdt]) {
            if (opptyField.Entity__c == 'Opportunity') {
                opptyAccessFields.add(opptyField.Field_API_Name__c);
                opptySetFields.add(opptyField.Field_API_Name__c);
            }
        }
        System.debug('opptyAccessFields include: ' + opptyAccessFields);
        System.debug('opptySetFields include: ' + opptySetFields);

        // Obtain the field name/token map for the Opportunity object
        Map<String, Schema.SObjectField> fieldDescribeTokens = Schema.SObjectType.Opportunity.fields.getMap();
        for (String fieldToCheck : opptyAccessFields) {
            // Check if the user has access to view field
            if (!fieldDescribeTokens.get(fieldToCheck).getDescribe().isAccessible()) {
                // Also pass error to client
                throw new System.NoAccessException();
            }
        }

        /** 
         * @what Now it is safe to proceed with call
         * @description Generate SOQL string
         */
        System.debug('isShowingOpenOppties: ' + isShowingOpenOppties);
        System.debug('isShowingClosedWonOppties: ' + isShowingClosedWonOppties);
        System.debug('isShowingClosedLostOppties: ' + isShowingClosedLostOppties);

        contentModifiedStartDate = noteModifiedStartDate;
        contentModifiedEndDate = noteModifiedEndDate;
        System.debug('contentModifiedStartDate: ' + contentModifiedStartDate);
        System.debug('contentModifiedEndDate: ' + contentModifiedEndDate);

        strSOQLOppty = 'SELECT Id, Owner.Name';
        for (String opptyField : opptySetFields) {
            strSOQLOppty += ', ' + opptyField;
        }
        System.debug('opptyRecordTypeId: ' + opptyRecordTypeId);
        strSOQLOppty += ' FROM Opportunity' +
                        ' WHERE (RecordTypeId = :opptyRecordTypeId';

        // Query for notes based on "noteModifiedStartDate" and "contentModifiedEndDate"
        if (queryNote().isEmpty()) {
            // If there are no notes modified per "noteModifiedStartDate" and "contentModifiedEndDate", 
            // return empty oppty list
            return new List<Opportunity>();                
        } else {
            // If notes found modified per "noteModifiedStartDate" and "contentModifiedEndDate", 
            // query for related opps using opptyIds
            Set<Id> opptyIds = queryOpportunity();
            strSOQLOppty += ' AND Id IN :opptyIds';      
        }

        /** Condition 1: Show NONE of the oppties, return empty oppty list */
        if (!isShowingOpenOppties && 
            !isShowingClosedWonOppties && 
            !isShowingClosedLostOppties) {
            return new List<Opportunity>();
        /** Condition 2: Show ALL of the oppties; set no other filters/where clauses */
        } else if (isShowingOpenOppties && 
                    isShowingClosedWonOppties && 
                    isShowingClosedLostOppties) {
            strSOQLOppty += ')';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        /** Condition 3: Show Open & ClosedWon oppties */
        } else if (isShowingOpenOppties && 
                    isShowingClosedWonOppties && 
                    !isShowingClosedLostOppties) {
            strSOQLOppty += ' AND IsClosed = FALSE)';
            strSOQLOppty += ' OR (RecordTypeId = :opptyRecordTypeId AND Id IN :opptyIds AND' +
                            ' IsWon = TRUE)';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        /** Condition 4: Show Open & ClosedLost oppties */
        } else if (isShowingOpenOppties &&
                    !isShowingClosedWonOppties && 
                    isShowingClosedLostOppties) {
            strSOQLOppty += ' AND IsClosed = FALSE)';
            strSOQLOppty += ' OR (RecordTypeId = :opptyRecordTypeId AND Id IN :opptyIds AND' + 
                            ' IsClosed = TRUE AND IsWon = FALSE)';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        /** Condition 5: Show ClosedWon & ClosedLost oppties */
        } else if (!isShowingOpenOppties && 
                    isShowingClosedWonOppties && 
                    isShowingClosedLostOppties) {
            strSOQLOppty += ' AND IsClosed = TRUE)';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        /** Condition 6: Show only Open oppties */
        } else if (isShowingOpenOppties && 
                    !isShowingClosedWonOppties && 
                    !isShowingClosedLostOppties) {
            strSOQLOppty += ' AND IsClosed = FALSE)';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        /** Condition 7: Show only ClosedWon oppties */
        } else if (!isShowingOpenOppties && 
                    isShowingClosedWonOppties && 
                    !isShowingClosedLostOppties) {
            strSOQLOppty += ' AND IsClosed = TRUE' + ' AND IsWon = TRUE)';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        /** Condition 8: Show only ClosedLost oppties */
        } else if (!isShowingOpenOppties &&
                    !isShowingClosedWonOppties && 
                    isShowingClosedLostOppties) {
            strSOQLOppty += ' AND IsClosed = TRUE' + ' AND IsWon = FALSE)';
            System.debug('strSOQLOppty: ' + strSOQLOppty);
        }

        strSOQLOppty += ' ORDER BY Probability DESC';
        System.debug('strSOQLOppty: ' + strSOQLOppty);

        System.debug('Database query result size: ' + Database.query(strSOQLOppty).size());
        return Database.query(strSOQLOppty);               
    }

    /**
     * @name queryNote
     * @description Private static helper Method
    **/
    static Set<Id> queryNote() {
        Set<Id> noteIds;
        DateTime modifiedStartDate = contentModifiedStartDate;
        DateTime modifiedEndDate = contentModifiedEndDate;
        DateTime newDateTime = convertDateToEndOfDay(modifiedEndDate);
        System.debug('modifiedStartDate in OTRT_OpptySearchResultsController: ' + modifiedStartDate);
        System.debug('modifiedEndDate in OTRT_OpptySearchResultsController: ' + newDateTime);
        // Instantiate a map with content notes revised greater or equal "noteModifiedStartDate"
        Map<Id, ContentNote> noteMap = new Map<Id, ContentNote> ([SELECT Id, Title, ContentModifiedDate 
                                                                    FROM ContentNote 
                                                                    WHERE ContentModifiedDate > :modifiedStartDate
                                                                    AND ContentModifiedDate < :newDateTime]);
        // Get the Ids of the notes
        noteIds = new Set<Id>(noteMap.keySet());
        System.debug('noteIds: ' + noteIds);
        return noteIds;
    }

    /**
     * @name queryOpportunity
     * @description Private static helper Method
    **/
    static Set<Id> queryOpportunity() {
        Set<Id> opptyIds;
        // Instantiate a list with related content document links and store each associated link entity Id
        List<ContentDocumentLink> cdls = [SELECT ContentDocumentId, LinkedEntityId 
                                            FROM ContentDocumentLink 
                                            WHERE ContentDocumentId IN :queryNote()
                                            WITH SECURITY_ENFORCED];
        // Loop through the content document links list to search for oppty Ids
        // Those oppty records will be passed into the lightning component data table
        opptyIds = new Set<Id>();     
        for (ContentDocumentLink cdl : cdls) {
            if (String.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(ConstantsSelector.OPPORTUNITY_PREFIX)) {
                opptyIds.add(cdl.LinkedEntityId);
            }
        }
        System.debug('opptyIds: ' + opptyIds);
        return opptyIds;
    }
    
    /**
     * @name convertDateToEndOfDay
     * @description Helper Method: Convert existing modifiedEndDate to end of day in Taipei time zone
     */
    public static DateTime convertDateToEndOfDay(DateTime dateToBeConverted) {
        // Convert modifiedEndDate to end of day
        Integer year = dateToBeConverted.year();
        Integer month = dateToBeConverted.month();
        Integer day = dateToBeConverted.day();
        // The returned date is in the GMT time zone
        DateTime gmtDateTime = DateTime.newInstance(year, month, day, 23, 59, 59);
        // Get the Taipei time zone and returns the time zone offset, in milliseconds
        Timezone tz = Timezone.getTimeZone('Asia/Taipei');
        Integer tzOffset = tz.getOffset(gmtDateTime);
        Integer tzOffsetToSec = Integer.valueOf(tzOffset * 0.001);
        // Convert modifiedEndDate to the Taipei time zone
        DateTime localDateTime = gmtDateTime.addSeconds(tzOffsetToSec);
        return localDateTime;
    }

}