@isTest
private class ScheduledEmailTest {
	@isTest 
    private static void executeScheduleTest() {
        Test.StartTest();
		ScheduledEmail se = new ScheduledEmail();
		String sch = '0 0 23 * * ?';
		system.schedule('Test', sch, se);
		Test.stopTest();
    }
    
}