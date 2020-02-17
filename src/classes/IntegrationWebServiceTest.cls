@isTest
private class IntegrationWebServiceTest {
    @testSetup
    private static void dataFactory() {
        List<Product2> products = new List<Product2>();
        for (Integer i = 1; i<= 3; i++) {
            Product2 pr = new Product2(Name='test' + i);
            products.add(pr);
        }
        insert products;
    }
    
	@isTest
    private static void insertTest() {        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');        
        String json = '[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/01t2v00000Ci4mNAAR"},"Id":"01t2v00000Ci4mNAAR","Name":"Dada","IsDeleted":false,"LastModifiedDate":"2020-02-03T09:36:08.000+0000","CreatedDate":"2020-02-01T15:51:04.000+0000"}]';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        test.startTest();
        IntegrationWebService.getExternalData();
        test.stopTest();
		Product2 actual = [SELECT id, Name FROM Product2 WHERE Name = 'Dada' LIMIT 1];
		System.assertEquals('Dada', actual.Name);       
    }
    
    @isTest
    private static void updateTest() {        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');  
        Product2 existProduct = [SELECT Id, Name FROM Product2 WHERE Name='test1']; 
        String json = '[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/'+existProduct.Id+'"},"Id":"'+existProduct.Id+'","Name":"Test123","IsDeleted":false,"LastModifiedDate":"2020-02-03T09:36:08.000+0000","CreatedDate":"2020-02-01T15:51:04.000+0000"}]';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        test.startTest();
        IntegrationWebService.getExternalData();
        test.stopTest();
		Product2 actual = [SELECT id, Name FROM Product2 WHERE Name = 'Test123' LIMIT 1];
		System.assertEquals('Test123', actual.Name);       
    }
    
    @isTest
    private static void deleteTest() {        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');  
        Product2 existProduct = [SELECT Id, Name FROM Product2 WHERE Name='test2']; 
        String json = '[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/'+existProduct.Id+'"},"Id":"'+existProduct.Id+'","Name":"'+existProduct.Name+'","IsDeleted":true,"LastModifiedDate":"2020-02-03T09:36:08.000+0000","CreatedDate":"2020-02-01T15:51:04.000+0000"}]';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        
        IntegrationWebService.getExternalData();
               
		List<Product2> actual = new List<Product2>([SELECT id, Name FROM Product2 WHERE Name = 'test2' LIMIT 1]);
		System.assertEquals(0, actual.size());       
    }
    
    @isTest
    private static void undeleteTest() {        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/IntegrationWebService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');  
        Product2 existProduct = [SELECT Id, Name FROM Product2 WHERE Name='test3']; 
        delete existProduct;
        String json = '[{"attributes":{"type":"Product2","url":"/services/data/v47.0/sobjects/Product2/'+existProduct.Id+'"},"Id":"'+existProduct.Id+'","Name":"'+existProduct.Name+'","IsDeleted":false,"LastModifiedDate":"2020-02-03T09:36:08.000+0000","CreatedDate":"2020-02-01T15:51:04.000+0000"}]';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        
        IntegrationWebService.getExternalData();
               
		List<Product2> actual = new List<Product2>([SELECT id, Name FROM Product2 WHERE Name = 'test3' LIMIT 1]);
		System.assertEquals('test3', actual[0].Name);       
    }
}