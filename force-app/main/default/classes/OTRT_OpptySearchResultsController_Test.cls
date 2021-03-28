@isTest
private class OTRT_OpptySearchResultsController_Test {

    static final String PROFILE_NAME = ConstantsSelector.TEST_PROFILE_CEB_LEAD;
    static final String RECORD_TYPE = ConstantsSelector.RECORD_TYPE_CEB; 
    static final String ROLE_NAME = 'BD_Sales';
    static final String LAST_NAME = 'GenericLastName';
  
    @TestSetup
    static void makeData() {
        TestDataFactory.constructUser(PROFILE_NAME, ROLE_NAME, LAST_NAME);
        TestDataFactory.insertTestDataForOppNotes(3, 3, 5, 
            'Qualification', RECORD_TYPE, true);
        TestDataFactory.insertTestDataForOppNotes(3, 3, 5, 
            'Closed Won', RECORD_TYPE, true);
        TestDataFactory.insertTestDataForOppNotes(3, 3, 5, 
            'Closed Lost', RECORD_TYPE, true);
    }
  
    @isTest static void testGetOpportunitiesNone() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');       
        Boolean isShowingOpenOppties = false;
        Boolean isShowingClosedWonOppties = false;
        Boolean isShowingClosedLostOppties = false;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.debug(OTRT_OpptySearchResultsController.strSOQLOppty);
        // Database.query(OTRT_OpptySearchResultsController.strSOQLOppty);
        System.assertEquals(0, oppLst.size(), 'Expected to have returned 0 opportunities.');                                             
    }

    @isTest static void testGetOpportunitiesAll() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = true;
        Boolean isShowingClosedWonOppties = true;
        Boolean isShowingClosedLostOppties = true;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(45, oppLst.size(), 'Expected to have returned 45 opportunities.');                                                              
    }

    @isTest static void testGetOpportunitiesOpenAndClosedWon() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = true;
        Boolean isShowingClosedWonOppties = true;
        Boolean isShowingClosedLostOppties = false;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(30, oppLst.size(), 'Expected to have returned 30 opportunities.');    
    }

    @isTest static void testGetOpportunitiesOpenAndClosedLost() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = true;
        Boolean isShowingClosedWonOppties = false;
        Boolean isShowingClosedLostOppties = true;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(30, oppLst.size(), 'Expected to have returned 30 opportunities.');                                                             
    }

    @isTest static void testGetOpportunitiesClosedWonAndClosedLost() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = false;
        Boolean isShowingClosedWonOppties = true;
        Boolean isShowingClosedLostOppties = true;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(30, oppLst.size(), 'Expected to have returned 30 opportunities.');                                                              
    }

    @isTest static void testGetOpportunitiesOpen() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = true;
        Boolean isShowingClosedWonOppties = false;
        Boolean isShowingClosedLostOppties = false;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();                                                                                            
        System.assertEquals(15, oppLst.size(), 'Expected to have returned 15 opportunities.');
    }

    @isTest static void testGetOpportunitiesClosedWon() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = false;
        Boolean isShowingClosedWonOppties = true;
        Boolean isShowingClosedLostOppties = false;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(15, oppLst.size(), 'Expected to have returned 15 opportunities.');    
    }

    @isTest static void testGetOpportunitiesClosedLost() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing the tested method.
        System.assert(sanityCheckListOfNotes.size() > 0, 'You need a note to continue.');          
        Boolean isShowingOpenOppties = false;
        Boolean isShowingClosedWonOppties = false;
        Boolean isShowingClosedLostOppties = true;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(15, oppLst.size(), 'Expected to have returned 15 opportunities.');  
    }


    @isTest static void testGetOpportunitiesWithoutNotes() {
        List<Opportunity> sanityCheckListOfOpps = [SELECT Id FROM Opportunity 
                                                    WHERE Name LIKE :ConstantsSelector.TEST_OPP_NAME_CEB + '%'];        
        // Sanity check asserting that there are opportunities before executing the tested method.
        System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue.');
        List<ContentNote> sanityCheckListOfNotes = [SELECT Id FROM ContentNote 
                                                    WHERE Title LIKE :ConstantsSelector.TEST_CONTENT_NOTE_TITLE + '%'];
        // Sanity check asserting that there are notes before executing note delete operation.
        System.assert(sanityCheckListOfNotes.size() > 0, 'There is no note to be deleted.');
        delete sanityCheckListOfNotes;       
        Boolean isShowingOpenOppties = false;
        Boolean isShowingClosedWonOppties = false;
        Boolean isShowingClosedLostOppties = true;
        Test.startTest();
        List<Opportunity> oppLst = OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                                            isShowingOpenOppties, 
                                                                                            isShowingClosedWonOppties,
                                                                                            isShowingClosedLostOppties,
                                                                                            ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                                            ConstantsSelector.NOTE_MODIFIED_End_DATE);
        Test.stopTest();
        System.assertEquals(0, oppLst.size(), 'Expected to have returned an empty oppLst.');    
    }
    
    @isTest static void testGetOpportunitiesWithoutAccess() {
        List<Boolean> exceptions = new List<Boolean>();
        Boolean isShowingOpenOppties = false;
        Boolean isShowingClosedWonOppties = false;
        Boolean isShowingClosedLostOppties = true;
        
        User u = [SELECT Id FROM User WHERE LastName = :LAST_NAME];
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
            try {
                OTRT_OpptySearchResultsController.getOpportunities(ConstantsSelector.RT_ID_OPP_CEB, 
                                                                        isShowingOpenOppties, 
                                                                        isShowingClosedWonOppties,
                                                                        isShowingClosedLostOppties,
                                                                        ConstantsSelector.NOTE_MODIFIED_START_DATE,
                                                                        ConstantsSelector.NOTE_MODIFIED_End_DATE);
            } catch (NoAccessException e) {
                exceptions.add(true);                
            }
        }
        Test.stopTest();

        system.assertNotEquals(null, exceptions, 'Expected at least one exception to have occured.');
        for (Boolean b : exceptions) {
            system.assert(b, 'Access check should have thrown an exception.');
        }            
    }     

}