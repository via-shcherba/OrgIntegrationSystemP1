@isTest
private class ProductTriggerTest {
    @testSetup
    private static void dataFactory() {
        Org2Data__c data = new Org2Data__c();
        data.password__c = '29051983Slash';
        data.clientId__c = '3MVG9G9pzCUSkzZuZWE2jBYYNYm7LTV1azlORo19Kyyti.In0cJhcb1Rr_2f7mGMxe4TCLYpNFarYKnDJOHTJ';
        data.authUrl__c = 'https://login.salesforce.com/services/oauth2/token';
        data.clientSecret__c = '69E03B52FFC729A5532241B5ACD016A49BF45CDE69CC08C74768EA95073AC68B';
        data.operateUrl__c = 'https://ap15.salesforce.com/services/apexrest/IntegrationWebService/';
        data.securityToken__c = 'FUG3Kb363zoipxMm8kXOVvazI';
        data.userName__c = 'orgintegration@part2.com';
        insert data;
    }
    
	@isTest
    private static void insertTest() {
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenCalloutMock());        
        Boolean result = false;
        try {
            insert newProduct;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        Test.stopTest();
        System.assert(result);
    }
    
    @isTest
    private static void updateTest() {
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        insert newProduct;
        Product2 existProduct = [SELECT Name FROM Product2 LIMIT 1];
        existProduct.Name = 'Test2';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenCalloutMock());
        Boolean result = false;
        try {
            update existProduct;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        Test.stopTest();
        System.assert(result);
    }
    
    @isTest
    private static void deleteTest() {
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        insert newProduct;
        Product2 existProduct = [SELECT Id, Name FROM Product2 LIMIT 1];        
        Test.startTest();
        Boolean result = false;
        Test.setMock(HttpCalloutMock.class, new TokenCalloutMock());
        try {
            delete existProduct;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        Test.stopTest();
        System.assert(result);
    }
    
    @isTest
    private static void undeleteTest() {
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        insert newProduct;
        Product2 existProduct = [SELECT Id, Name FROM Product2 LIMIT 1];  
        delete existProduct;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TokenCalloutMock());
        Boolean result = false;
        try {
            undelete existProduct;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        Test.stopTest();
        System.assert(result);
    }
    
}