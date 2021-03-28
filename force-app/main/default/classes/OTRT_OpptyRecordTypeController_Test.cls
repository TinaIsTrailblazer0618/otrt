@isTest
private class OTRT_OpptyRecordTypeController_Test {

    @isTest static void testGetOpptyRecordTypes() {

        Map<String, Schema.RecordTypeInfo> rtMapByDeveloperName = SObjectUtils.mapRecordTypeByDeveloperName('Opportunity');
        Integer i = 0;    
        for (String rtDevName : rtMapByDeveloperName.keySet()) {
            if (!rtMapByDeveloperName.get(rtDevName).isMaster() &&
                rtMapByDeveloperName.get(rtDevName).isActive()) {
                i ++;
            }
        }

        Test.startTest();
        List<OTRT_OpptyRecordTypeController.OpptyRecordType> ortLst = 
            OTRT_OpptyRecordTypeController.getOpptyRecordTypes();
        Test.stopTest();

        System.assert(i == ortLst.size(), 
                    'Expected to have returned the same number of record types.');

        Schema.DescribeSObjectResult d = SObjectUtils.getDescribeSObjectResult('Opportunity');
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        for (OTRT_OpptyRecordTypeController.OpptyRecordType ort : ortLst) {
            Id rtId = rtMapByName.get(ort.Name).getRecordTypeId();
            System.assertEquals(rtId, ort.Id, 
                                'Expected to have the matching record type Id.');
        }
    }
    
}