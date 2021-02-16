public class contactTriggerHandler {
    
    public static boolean checkdlrs = false;
	public static boolean checkRun = false;
	public static void handleEvents(List<Contact> lcon,Map<ID,Contact> oldContactMap,Map<ID,Contact> newContactMap) {
		if(Trigger.isBefore){
			if(Trigger.isInsert){
             }else if(Trigger.isUpdate){
				
			}
		}else if(Trigger.isAfter){
			if(Trigger.isInsert){
				if(!CheckRun){
					
				}
			}else if(Trigger.isUpdate){
				
				}
			
				System.debug('---------------Check Run in contact before Update------------:'+CheckRun);
				
					
				
			}
		}
	
	

}