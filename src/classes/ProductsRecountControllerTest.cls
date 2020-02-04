@isTest
private class ProductsRecountControllerTest {
	@isTest
    private static void ProductsRecountControllerTest() {
        Product2 newProduct = new Product2(Name='test');
        insert newProduct;
        Test.startTest();
        ProductsRecountController prc = new ProductsRecountController();        
        Test.stopTest();
        Integer actual = [SELECT COUNT() FROM Product2];
        System.assertEquals(1, actual);
    }
    
}