global class CreatorProducts implements Database.Batchable<sObject>, Database.Stateful {
    
    private Integer counter = 200;
    private Integer count;
    public CreatorProducts(Integer count) {
        this.count = count;
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 200; i++) {
            Product2 product = new Product2();
            product.Name = 'Prod-' + generateWorld() + '-' + i; 
            products.add(product);
        }
        insert products;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name FROM Product2 WHERE ExtId__c != null LIMIT 200');
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> objlist) {
        List<Product2> products = new List<Product2>();
        Integer size = (count > 200) ? (count - 200) / 200 : 1;
        for (Integer i = 0; i< size; i++) {
            Product2 product = new Product2();
            product.Name = 'Prod-' + generateWorld() + '-' + i; 
            products.add(product);
            counter ++;
        }
        insert products;
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('batch counter: ' + counter);
    }
    
    global String generateWorld() {
        Blob key = crypto.generateAesKey(128);
        return EncodingUtil.convertToHex(key).substring(0, 5);      
    }    
}