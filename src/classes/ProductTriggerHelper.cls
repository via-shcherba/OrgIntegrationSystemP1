public class ProductTriggerHelper {
    private Map<Id, Product2> records;
    private Id syncUserId;
    
    public ProductTriggerHelper(Map<Id, Product2> records) {
        this.records = records;
        this.syncUserId = [SELECT Id FROM User WHERE LastName='SynchroElement'].Id;
    }
            
    public void insertAfter() { 
        if (syncUserId != null) {
        	List<Product2> productsForSend = new List<Product2>();       
        	for (Product2 product : records.values()) {
            	if (product.LastModifiedById != syncUserId) {
                	productsForSend.add(product);
            	} 
        	}
        
        	if (!productsForSend.isEmpty()) {
        		Map<String, List<Product2>> data = new Map<String, List<Product2>>();	
        		data.put('insert', productsForSend);
        		String json = JSON.serialize(data);        
        		WebServiceConnection.sendData(json);
        	}
        }
    }
    
    public void updateAfter() {
        if (syncUserId != null) {
            List<Product2> productsForSend = new List<Product2>();       
            for (Product2 product : records.values()) {
                if (product.LastModifiedById != syncUserId) {
                    Product2 newProduct = new Product2();
                    if (product.ExtId__c != null) {
                        newProduct.Id = product.ExtId__c;
                    } else {
                        newProduct.Id = product.Id;
                    }
                    newProduct.Description = product.Description;
                    newProduct.DisplayUrl = product.DisplayUrl;
                    newProduct.Family = product.Family;
                    newProduct.Name = product.Name;
                    newProduct.ProductCode = product.ProductCode;
                    newProduct.StockKeepingUnit = product.StockKeepingUnit;
                    productsForSend.add(newProduct);                    
                }                 
            }
            
            if (!productsForSend.isEmpty()) {                           
                Map<String, List<Product2>> data = new Map<String, List<Product2>>();
                data.put('update', productsForSend);
                String json = JSON.serialize(data);
                WebServiceConnection.sendData(json);
            }
        }
    }
    
    public void deleteBefore() { 
        if (syncUserId != null) {
            List<Product2> productsForSend = new List<Product2>();       
            for (Product2 product : records.values()) {
                if (product.LastModifiedById != syncUserId) {
                    Product2 newProduct = new Product2();
                    if (product.ExtId__c != null) {
                        newProduct.Id = product.ExtId__c;
                    } else {
                        newProduct.Id = product.Id;
                    }                
                    productsForSend.add(newProduct);
                } 
            }
            
            if (!productsForSend.isEmpty()) {
                Map<String, List<Product2>> data = new Map<String, List<Product2>>();
                data.put('delete', productsForSend);
                String json = JSON.serialize(data);
                WebServiceConnection.sendData(json);
            }
        }
    }
    
    public void undeleteAfter() {   
        if (syncUserId != null) {
            List<Product2> productsForSend = new List<Product2>();       
            for (Product2 product : records.values()) {
                if (product.LastModifiedById != syncUserId) {
                    Product2 newProduct = new Product2();
                    if (product.ExtId__c != null) {
                        newProduct.Id = product.ExtId__c;
                    } else {
                        newProduct.Id = product.Id;
                    }                
                    productsForSend.add(newProduct);
                } 
            }
            
            if (!productsForSend.isEmpty()) {
                Map<String, List<Product2>> data = new Map<String, List<Product2>>();
                data.put('undelete', productsForSend);
                String json = JSON.serialize(data);
                WebServiceConnection.sendData(json);
            }
        }
    }
}