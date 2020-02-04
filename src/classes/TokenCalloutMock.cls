@isTest
global class TokenCalloutMock implements HttpCalloutMock {    
    global HTTPResponse respond(HTTPRequest request) {        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token": "123"}');
        response.setStatusCode(200);
        return response; 
    }
}