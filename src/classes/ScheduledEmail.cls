global class ScheduledEmail implements Schedulable {
	global void execute(SchedulableContext sc) {
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE Name ='RecordCounter'];
        List<String> toAddress = new List<String>();           
        User admin = [SELECT Id, Email FROM User WHERE Profile.Name='System Administrator' LIMIT 1];
        toAddress.add(admin.Email);                  
        if (!toAddress.isEmpty() && admin != null) {
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    		email.setTemplateId(template.Id);
    		email.setToAddresses(toAddress);
    		email.setTargetObjectId(admin.Id);
    		email.setSaveAsActivity(false);
    		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}