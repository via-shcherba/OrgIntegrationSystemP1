public class ProductsRecountController {
    public Integer numberRecords {get;set;}
    
    public ProductsRecountController() {
        numberRecords = [SELECT COUNT() FROM Product2];
    }
}