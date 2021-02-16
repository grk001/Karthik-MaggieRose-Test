@isTest(SeeAllData=true)
private class contactInsertTest {
        
    static testMethod void testMethod1() {
         
        String endPoint = 'https://jsonplaceholder.typicode.com/users';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        req.setHeader('Content-type', 'application/json');

        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(200);
        
        // Create test Contact Data
        
        List<Contact> conList = new List<Contact>();
        for(Integer i=1; i<11; i++){
            Contact cont = new Contact();
			 cont.FirstName = 'Andy' +i;
             cont.LastName = 'Young' +i;
             cont.Email = 'test@contact1.com';
             cont.External_Id__c = '' + i;  
            conList.add(cont);
         }
        insert conList;
        
        // Create test Album data
        List<Album__c>ListAlb = new List<Album__c>();
        
        
        for(Integer i=1; i<11; i++){
             Album__c alb = new Album__c();
             alb.Name = 'Alan Fry' + i;
             alb.External_Id__c = '' + i;  
            ListAlb.add(alb);
         }
        insert ListAlb;
        
        String endPoint1 = 'https://jsonplaceholder.typicode.com/albums';
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setEndpoint(endPoint);
        req1.setHeader('Content-type', 'application/json');

        Http http1 = new Http();
        HTTPResponse res1 = new HTTPResponse();
        res1.setStatusCode(200);
        
        System.debug('----------res ------------------' + res);
        
		Test.startTest();
        ContactBatchInsert b = new ContactBatchInsert();
        Database.executeBatch(b);
        
        List<Contact> contUpdatedList = [Select Id, Name, Email,External_Id__c  from Contact];
       
        
        List<Album__c> albUpdatedList = [Select Id, Name,External_Id__c from Album__c];
        
        Test.stopTest();
        
        
            
    }

}