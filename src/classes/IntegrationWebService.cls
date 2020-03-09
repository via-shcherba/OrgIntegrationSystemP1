@RestResource(urlMapping='/IntegrationWebService/*')
global class IntegrationWebService {
    
	@HttpPost
    global static void getExternalData() {
        RestRequest request = RestContext.request;
        Blob body = request.requestBody;       
        List<Product2> externalData = (List<Product2>)JSON.deserialize(body.toString(), List<Product2>.class); 
        Map<Id, Product2> products = new Map<Id, Product2>(externalData);
        Map<Id, Product2> existDataWithoutDublicate = getExistDataWithoutDublicate(products.keySet());
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

        try {
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
        } catch (DmlException e) {
            ErrorLog__c error = new ErrorLog__c(Name = (String)e.getMessage());
            insert error;
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
        for (Product2 product : existData) {
            if (String.isNotBlank(product.ExtId__c)) {
                existDataWithoutDublicate.put(product.ExtId__c, product);
            } else {
                existDataWithoutDublicate.put(product.Id, product);
            }
        }
        return existDataWithoutDublicate;
    }
       
}