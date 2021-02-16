global class ContactBatchInsert implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
	
    global string status = 'Success';
    
    	global ContactBatchInsert() {}
    
        global Database.QueryLocator start(Database.BatchableContext BC) {
            String jsonquery = 'Select ID,FirstName,LastName,External_ID__c,AccountId,Account.External_ID__c from Contact';
            return Database.getQueryLocator(jsonquery);
        }
        global void execute(Database.BatchableContext BC, List<Contact> lcont) {
            
            HttpRequest request = new HttpRequest();
			request.setEndpoint('https://jsonplaceholder.typicode.com/users');
			request.setMethod('GET');
			Http http = new Http();
			HttpResponse response = http.send(request);
			String responseBody = response.getBody();
            
            Map<String,Object> contactData = new Map<String,Object>();
            Map<String,Object> companyData = new Map<String,Object>();
            
            List<Account> addaccounts = new List<Account>();
            List<Contact> addcontacts = new List<Contact>();
            
            if(responseBody != Null){
            List<Object> jsonParsed = (List<Object>) JSON.deserializeUntyped(responseBody);
                     
                for(Object obj:jsonParsed){
                    contactData = (Map<String,Object>) Obj;
                    companyData = (Map<String,Object>) contactData.get('company');
                    
                    String fullname = String.ValueOf(contactData.get('name'));
                    String firstname = fullname.SubStringBefore(' ');
                    String lastname = fullname.SubStringAfter(' ');
                    String externalId = String.ValueOf(contactData.get('id'));
                    String email = String.ValueOf(contactData.get('email'));
                   
                    Account accountReference = new Account(External_ID__c=externalId);
                    Account newaccount = new Account(Name = String.valueOf(companyData.get('name')), External_ID__c =String.ValueOf(contactData.get('id')));
                    	addaccounts.add(newaccount);
                    Contact con = new Contact(LastName=lastname,FirstName=firstname,Account=accountReference,Email=email,External_ID__c =String.ValueOf(contactData.get('id')));
                    	addcontacts.add(con);
                }
                try{
                if(!addaccounts.isEmpty()){  
                    Schema.SObjectField accfieldID = Account.Fields.External_ID__c;
                    Database.upsert(addaccounts,accfieldID);
                    
                    Schema.SObjectField confieldID = Contact.Fields.External_ID__c;
                    Database.upsert(addcontacts,confieldID);
                	}
            	} catch(Exception ex){
               	 status = 'Fail';
            	}
            }
         }
    
        global void finish(Database.BatchableContext BC) {
            
            HttpRequest req = new HttpRequest();
			req.setEndpoint('https://jsonplaceholder.typicode.com/albums');
			req.setMethod('GET');

			Http http = new Http();
			HttpResponse resp = http.send(req);
			String respBody = resp.getBody();
            System.debug('---------------Album results------------:'+respBody);
            
            Map<String,Object> albumData = new Map<String,Object>();
            Map<String,Id> contactmap = new Map<String,Id>();
            List<Contact> contactlist = [Select ID, External_ID__c from Contact];
            List<Album__c> albmnew = new List<Album__c>();
            
            for(Contact cts: contactlist){
                if(cts.External_ID__c != NULL){
                    contactmap.put(cts.External_ID__c,cts.Id);
                }
            }
            
            if(respBody != Null && contactlist!= NULL){
            List<Object> jsonParsedalbm = (List<Object>) JSON.deserializeUntyped(respBody);
                     
                for(Object objt:jsonParsedalbm){
                    albumData = (Map<String,Object>) Objt;
                    
                    String externalId = String.valueOf(albumData.get('id'));
                    String name = String.valueOf(albumData.get('title'));
                    
                    Album__c albmReference = new Album__c(External_ID__c=externalId);
                    Album__c newalbm = new Album__c(Name=String.valueOf(albumData.get('title')),External_ID__c=externalId,
                                                    Contact__c=contactmap.get(String.valueOf(albumData.get('userId'))));
                    albmnew.add(newalbm);
                }
            }
            try{
            if(!albmnew.isEmpty()){
                	Schema.SObjectField albmfieldID = Album__c.Fields.External_ID__c;
                    Database.upsert(albmnew,albmfieldID);
            	}
            } catch(Exception exp){
                Status = 'Fail';
            }
        }
}