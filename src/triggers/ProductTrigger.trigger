trigger ProductTrigger on Product2 (after insert, after update, after delete, after undelete) {
    
    if (trigger.isAfter) {
        if (trigger.isInsert) {
            new ProductTriggerHelper(trigger.NewMap).insertAfter();
        }
        
        if (trigger.isUpdate) {
            new ProductTriggerHelper(trigger.NewMap).updateAfter();
        }
        
        if (trigger.isDelete) {
            new ProductTriggerHelper(trigger.OldMap).deleteBefore();            
        }
        
        if (trigger.isUndelete) {
            new ProductTriggerHelper(trigger.NewMap).undeleteAfter();          
        }
        
    }
        
}