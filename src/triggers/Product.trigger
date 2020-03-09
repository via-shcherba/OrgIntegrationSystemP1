trigger Product on Product2 (after insert, after update, after delete, after undelete) {
    new ProductTriggerHelper(trigger.NewMap);
}