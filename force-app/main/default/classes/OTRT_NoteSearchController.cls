/**
 * @author Tina Chang
 * @name OTRT_NoteSearchController
 * @builtDate 8th July, 2020
 * @description Controller for OTRT_NoteDetailsCmp
**/
public with sharing class OTRT_NoteSearchController {
    
    @TestVisible static List<ContentNote> noteList;

    @AuraEnabled
	public static ContentNote getNote(String opptyId, DateTime modifiedStartDate, DateTime modifiedEndDate) {
        /** 
         * @what Enforce CRUD/FLS 
         * @description Query for Custom Metadata Type Field__mdt, a centralized place for fields used by lightning data table
         *  And where admin or developer can manage (add/edit/remove) fields for display.
         */
        Set<String> opptyAccessFields = new Set<String>();
        Set<String> opptySetFields = new Set<String>();        
        for (Field__mdt opptyField : [SELECT Field_API_Name__c, Entity__c FROM Field__mdt]) {
            if (opptyField.Entity__c == 'Opportunity') {
                opptyAccessFields.add(opptyField.Field_API_Name__c);
            }
        }
        System.debug('opptyAccessFields include: ' + opptyAccessFields);

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
         * @description Query for the most recent modified note
         */
        String sNOTE = ConstantsSelector.FILE_TYPE_SNOTE;
        Set<Id> contentDocumentIds = new Set<Id>();
        List<ContentDocumentLink> cdls = [SELECT ContentDocumentId FROM ContentDocumentLink
                                            WHERE ContentDocument.FileType = :sNOTE
                                            AND LinkedEntityId = :opptyId
                                            WITH SECURITY_ENFORCED];
        if (cdls.size() > 0) {
            for (ContentDocumentLink cdl : cdls) {
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
        }
        System.debug('contentDocumentIds in OTRT_NoteSearchController: ' + contentDocumentIds);
        System.debug('modifiedStartDate in OTRT_NoteSearchController: ' + modifiedStartDate);
        System.debug('modifiedEndDate in OTRT_NoteSearchController: ' + modifiedEndDate);
        DateTime newDateTime = OTRT_OpptySearchResultsController.convertDateToEndOfDay(modifiedEndDate);
        System.debug('converted modifiedEndDate in OTRT_NoteSearchController: ' + newDateTime);
        noteList = [SELECT Id, Title, ContentModifiedDate, Owner.Name
                    FROM ContentNote
                    WHERE ContentModifiedDate > :modifiedStartDate
                    AND ContentModifiedDate < :newDateTime
                    AND Id IN :contentDocumentIds
                    ORDER BY ContentModifiedDate DESC LIMIT 1];
        if (noteList.size() > 0) {
            return noteList[0]; 
        } else {
            return null;
        }                                                      
    }                                           

}