@isTest
private class OTRT_NoteSearchController_Test {

    static final String PROFILE_NAME_1 = 'Minimum Access - Salesforce';
    static final String PROFILE_NAME_2 = ConstantsSelector.TEST_PROFILE_CEB_LEAD;
    static final String ROLE_NAME = 'BD_Sales';
    static final String LAST_NAME = 'GenericLastName';
    static final String LAST_NAME_MIN_ACCESS = 'GenericLastNameMinAccess';
    static final String RECORD_TYPE = ConstantsSelector.RECORD_TYPE_CEB;
    static final String STAGE_NAME = 'Qualification';
    
    @TestSetup
    static void dataCreation() {
        Test.startTest();
        TestDataFactory.constructUser(PROFILE_NAME_1, ROLE_NAME, LAST_NAME_MIN_ACCESS); // Future method.
        TestDataFactory.constructUser(PROFILE_NAME_2, ROLE_NAME, LAST_NAME); // Future method.
		Test.stopTest();
        // Create a test user.
        Id userId = [SELECT Id FROM User WHERE LastName = :LAST_NAME LIMIT 1].Id;
        // Make the created user the owner of the following notes.
        List<ContentNote> notes = 
            TestDataFactory.constructContentNotesOfUser(3, userId, true);
        TestDataFactory.contentDocumentLinkedToCurrentUser(notes, true);
 		List<Opportunity> opps = 
            TestDataFactory.constructOpportunities(1, 5, STAGE_NAME, RECORD_TYPE, true);
        // Create links to relate notes to opportunities.
        TestDataFactory.contentDocumentLinkedToSObject(opps, notes, true);
    }

    @isTest static void testPositiveGetNote() {     
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity WHERE Name 
                                                    LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');   
        DateTime d1 = ConstantsSelector.NOTE_MODIFIED_START_DATE;
        DateTime d2 = ConstantsSelector.NOTE_MODIFIED_END_DATE;
        Test.startTest();
        for (Opportunity opp : sanityCheckListOfOpps) {
            OTRT_NoteSearchController.getNote(opp.Id, d1, d2);
            System.assertEquals(1, OTRT_NoteSearchController.noteList.size(), 
                                'Expected at least one note record to have returned');
        }
        Test.stopTest();
    }

    @isTest static void testNegativeGetNote() {     
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing note delete operation.
        System.assert(sanityCheckListOfNotes.size() > 0, 'There is no note to be deleted.');
        delete sanityCheckListOfNotes;
        DateTime d1 = ConstantsSelector.NOTE_MODIFIED_START_DATE;
        DateTime d2 = ConstantsSelector.NOTE_MODIFIED_END_DATE;
        Test.startTest();
        for (Opportunity opp : sanityCheckListOfOpps) {
            OTRT_NoteSearchController.getNote(opp.Id, d1, d2);
            System.assert(OTRT_NoteSearchController.noteList.isEmpty(), 
                            'Expected empty note list to have returned');
        }
        Test.stopTest();
    }

    @isTest static void testGetNoteWithoutAccess() {   
        List<Boolean> exceptions = new List<Boolean>();
        DateTime d1 = ConstantsSelector.NOTE_MODIFIED_START_DATE;
        DateTime d2 = ConstantsSelector.NOTE_MODIFIED_END_DATE;
        
        User u = [SELECT Id FROM User WHERE LastName = :LAST_NAME_MIN_ACCESS LIMIT 1];
        // Sanity check asserting that there is a user before starting System.runAs(user) block.
        System.assert(u != null, 'You need a user to continue.');                  
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');

        Test.startTest();
        System.runAs(u) {         
            for (Opportunity opp : sanityCheckListOfOpps) {
                try {
                    OTRT_NoteSearchController.getNote(opp.Id, d1, d2);
                } catch (NoAccessException e) {
                    exceptions.add(true);
                }
            }
        }
        Test.stopTest();

        system.assertNotEquals(null, exceptions, 'Expected at least one exception to have occured.');
        for (Boolean b : exceptions) {
            system.assert(b, 'Access check should have thrown an exception.');
        }         
    }

}