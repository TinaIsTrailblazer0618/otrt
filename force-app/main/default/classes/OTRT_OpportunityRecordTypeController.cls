/**
 * @author Tina Chang
 * @name OTRT_OpptyRecordTypeController
 * @builtDate 8th July, 2020
 * @description Controller for OTRT_OpportunitySearchFormCmp
**/
public with sharing class OTRT_OpptyRecordTypeController {

    @AuraEnabled
    public static List<OpptyRecordType> getOpptyRecordTypes() {
        Map<Id, Schema.RecordTypeInfo> rtMapById = SObjectUtils.mapRecordTypeById('Opportunity');
        List<OpptyRecordType> ortList = new List<OpptyRecordType>();
        for (String recordTypeId : rtMapById.keySet()) {
            Boolean isMaster = rtMapById.get(recordTypeId).isMaster();
            Boolean isActive = rtMapById.get(recordTypeId).isActive();
            if (!isMaster && isActive) {
                String recordTypeName = rtMapById.get(recordTypeId).getName();
                OpptyRecordType ort = new OpptyRecordType(recordTypeName, recordTypeId);
                ortList.add(ort);
            }
        }
        System.debug('OpptyRecordType list:' + ortList);
        return ortList;
    }

    public class OpptyRecordType {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String name { get; set; }

        public OpptyRecordType(String name, String id) {
            this.name = name;
            this.id = id;
        }
    }   

}