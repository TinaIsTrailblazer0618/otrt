@isTest
private class OTRT_NoteContentDecoder_Test {

    static final String PROFILE_NAME = ConstantsSelector.TEST_PROFILE_CEB_LEAD;
    static final String ROLE_NAME = 'BD_Sales';
    static final String LAST_NAME = 'GenericLastName';    
   
    @TestSetup
    static void makeData() {  
        Test.startTest();
        TestDataFactory.constructUser(PROFILE_NAME, ROLE_NAME, LAST_NAME);
        Test.stopTest();
        Id userId = [SELECT Id FROM User WHERE LastName = :LAST_NAME LIMIT 1].Id;
        List<ContentNote> notes = 
            TestDataFactory.constructContentNotesOfUser(3, userId, true);
        TestDataFactory.contentDocumentLinkedToCurrentUser(notes, true);
    }

    @isTest static void decodeNoteContent() {
        ContentNote note = [SELECT Id FROM ContentNote WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'].get(0);
        String noteContent = OTRT_NoteContentDecoder.decodeNoteContent(note.Id);
        System.assertEquals('Unit Test Note Body', noteContent, 'Expected note content: \'Unit Test Note Body\'');
    }
    
}