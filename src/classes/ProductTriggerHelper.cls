public class ProductTriggerHelper {
    private Map<Id, Product2> records;
    private Id syncUserId;
    
    public ProductTriggerHelper(Map<Id, Product2> records) {
        this.records = records;
        this.syncUserId = [SELECT Id FROM User WHERE LastName='SynchroElement'].Id;
        if (trigger.isAfter) {
            if (trigger.isInsert) {
                ProductTriggerService.afterInsert(syncUserId, records);
            }
            if (trigger.isUpdate) {
                ProductTriggerService.afterUpdate(syncUserId, records);
            }
            if (trigger.isDelete) {
                ProductTriggerService.beforeDelete(syncUserId, records);
            }
            if (trigger.isUndelete) {
                ProductTriggerService.afterUndelete(syncUserId, records);
            }
        }
    }
}