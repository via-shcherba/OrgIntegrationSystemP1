/**
 * Created by vshcherba on 3/9/2020.
 */

public with sharing class ProductTriggerService {

    public static void afterInsert(Id syncUserId, Map<Id, Product2> records) {
        if (String.isNotBlank(syncUserId)) {
            List<Product2> productsForSend = new List<Product2>();
            for (Product2 product : records.values()) {
                if (product.LastModifiedById != syncUserId) {
                    productsForSend.add(product);
                }
            }
            if (!productsForSend.isEmpty()) {
                sendData('insert', productsForSend);
            }
        }
    }

    public static void afterUpdate(Id syncUserId, Map<Id, Product2> records) {
        if (String.isNotBlank(syncUserId)) {
            List<Product2> productsForSend = new List<Product2>();
            for (Product2 product : records.values()) {
                if (product.LastModifiedById != syncUserId) {
                    Product2 newProduct = new Product2();
                    if (String.isNotBlank(product.ExtId__c)) {
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
                sendData('update', productsForSend);
            }
        }
    }

    public static void beforeDelete(Id syncUserId, Map<Id, Product2> records) {
        if (String.isNotBlank(syncUserId)) {
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
                sendData('delete', productsForSend);
            }
        }
    }

    public static void afterUndelete(Id syncUserId, Map<Id, Product2> records) {
        if (String.isNotBlank(syncUserId)) {
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
                sendData('undelete', productsForSend);
            }
        }
    }

    private static void sendData(String flag, List<Product2> data) {
        Map<String, List<Product2>> dataForSend = new Map<String, List<Product2>>();
        dataForSend.put(flag, data);
        String json = JSON.serialize(data);
        WebServiceConnection.sendData(json);
    }
}