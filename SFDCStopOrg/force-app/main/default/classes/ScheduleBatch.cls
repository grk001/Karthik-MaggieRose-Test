global class ScheduleBatch implements Schedulable {
    
    global void execute(SchedulableContext sc  ) {
        
        ContactBatchInsert b = new ContactBatchInsert();
        Database.executeBatch(b);
        
    }
    

}