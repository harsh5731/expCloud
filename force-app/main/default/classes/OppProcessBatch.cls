public class OppProcessBatch implements Database.Batchable<sObject> {
    
    public integer recordCount = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([select Id,name from Opportunity]);
        
    } 
    
    public void execute(Database.BatchableContext bc, List<opportunity> opp){
        
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    

}