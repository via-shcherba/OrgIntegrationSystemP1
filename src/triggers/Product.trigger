trigger Product on Product2 (after insert, after update, after delete, after undelete) {
    
    if (trigger.isAfter) {
        if (trigger.isInsert) {
            new ProductTriggerHelper(trigger.NewMap).afterInsert();
        }
        
        if (trigger.isUpdate) {
            new ProductTriggerHelper(trigger.NewMap).afterUpdate();
        }
        
        if (trigger.isDelete) {
            new ProductTriggerHelper(trigger.OldMap).beforeDelete();
        }
        
        if (trigger.isUndelete) {
            new ProductTriggerHelper(trigger.NewMap).afterUndelete();
        }
        
    }
        
}