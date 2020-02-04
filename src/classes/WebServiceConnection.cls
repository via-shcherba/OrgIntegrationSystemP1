public class WebServiceConnection {
    @future(callout=true)
    public static void sendData(String json) {
               
        try {                   
            Org2Data__c customData = Org2Data__c.getOrgDefaults();
            String token = getToken(customData);
            String operateUrl = customData.operateUrl__c;            
            Httprequest request = new HttpRequest();  
            request.setEndpoint(operateUrl);  
            request.setMethod('POST');    
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization','Bearer '+ token);   
            request.setBody(json);            
            HttpResponse response = new Http().send(request);            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }    
    
    private static String getToken(Org2Data__c customData) {
        String token = '';                                                                   
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customData.authUrl__c);
        request.setMethod('POST');
		request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(
            'grant_type=password' + 
      		'&client_id=' + customData.clientId__c + 
      		'&client_secret=' + customData.clientSecret__c + 
      		'&username=' + customData.userName__c +
      		'&password=' + customData.password__c + customData.securityToken__c
   		);  
                
		HttpResponse res = new Http().send(request);   
        JSONParser parser = JSON.createParser(res.getBody());
        
    	while (parser.nextToken() != null) {
        	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                parser.nextToken();
                token = parser.getText();    
        	} 
    	}       
        		       
        return token;
    }
    
}