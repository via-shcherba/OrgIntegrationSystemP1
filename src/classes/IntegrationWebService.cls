@RestResource(urlMapping='/IntegrationWebService/*')
global class IntegrationWebService {
    
	@HttpPost
    global static void readExternalCommands() {
        RestRequest request = RestContext.request;
        Blob body = request.requestBody;       
        List<Product2> externalData = (List<Product2>)JSON.deserialize(body.toString(), List<Product2>.class); 
        Map<Id, Product2> ids = new Map<Id, Product2>(externalData);
        
        Map<Id, Product2> existDataWithoutDublicate = getExistDataWithoutDublicate(ids.keySet());

        List<Product2> forDelete = new List<Product2>();
        List<Product2> forInsert = new List<Product2>();
        List<Product2> forUndelete = new List<Product2>();
        List<Product2> forUpdate = new List<Product2>();
        for (Product2 product : externalData) {
            if (existDataWithoutDublicate.containsKey(product.Id)) {
                Product2 existProduct = existDataWithoutDublicate.get(product.Id);
                if (existProduct.IsDeleted) {
                	if (!product.IsDeleted) {                        
                        forUndelete.add(existProduct);
                    }                    
                } else {   
                    if (product.IsDeleted) {                        
                        forDelete.add(existProduct);
                    } else {      
                		existProduct.Description = product.Description;
                		existProduct.DisplayUrl = product.DisplayUrl;
                		existProduct.Family = product.Family;
                		existProduct.Name = product.Name;
                		existProduct.ProductCode = product.ProductCode;
                		existProduct.StockKeepingUnit = product.StockKeepingUnit;                    
                    	forUpdate.add(existProduct);
                    }                    
                }
            } else {   
                if (!product.IsDeleted) {
            		Product2 newProduct = new Product2();
                	newProduct.ExtId__c = product.Id;  
                	newProduct.Description = product.Description;
                	newProduct.DisplayUrl = product.DisplayUrl;
                	newProduct.Family = product.Family;
                	newProduct.Name = product.Name;
                	newProduct.ProductCode = product.ProductCode;
                	newProduct.StockKeepingUnit = product.StockKeepingUnit;                                	
                	forInsert.add(newProduct);    
            	}
            }
        }
        
        if (!forDelete.isEmpty()) {
            delete forDelete;        	            
        }
        if (!forInsert.isEmpty()) {
            insert forInsert;           	           
        }
        if (!forUndelete.isEmpty()) {
            undelete forUndelete;        	            
        }
        if (!forUpdate.isEmpty()) {
            update forUpdate;           	         
        }
                
    }

    private static Map<Id, Product2> getExistDataWithoutDublicate(Set<Id> keys) {
        List<Product2> existData = new List<Product2>([
                SELECT Id, Name, Description, ExtId__c, Family, ProductCode, IsDeleted, DisplayUrl
                FROM Product2
                WHERE ExtId__c IN :keys
                OR Id IN :keys
                LIMIT 10000
                ALL ROWS
        ]);
        Map<Id, Product2> existDataWithoutDublicate = new Map<Id, Product2>();
        if (!existData.isEmpty()) {
            for (Product2 product : existData) {
                if (product.ExtId__c != null) {
                    existDataWithoutDublicate.put(product.ExtId__c, product);
                } else {
                    existDataWithoutDublicate.put(product.Id, product);
                }
            }
        }
        return existDataWithoutDublicate;
    }
       
}