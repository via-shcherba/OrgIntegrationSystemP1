@isTest
private class CreatorProductsTest {
	@isTest
    private static void batchTest() {
        Test.startTest();
		Database.executeBatch(new CreatorProducts(200));     
        Integer actual = [SELECT COUNT() FROM Product2];
        Test.stopTest();        
        System.assertEquals(200, actual);
    }
    
}