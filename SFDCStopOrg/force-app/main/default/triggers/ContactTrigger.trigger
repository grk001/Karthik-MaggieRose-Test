trigger ContactTrigger on Contact (before delete, before insert, before update, after delete, after insert, after undelete, after update) {
 
    
 By_Pass_Settings__c bypass = By_Pass_Settings__c.getInstance(UserInfo.getUserId());
    if(bypass == NULL || !bypass.No_Triggers__c){
        
      contactTriggerHandler.handleEvents(Trigger.new, Trigger.oldMap, Trigger.newMap);
        
    
   }

}