global class futueMethods {
         
    @future
    public static void myFutureMethod(list<Id> accId){
        List<Account> accList = [Select id,name,(Select Id,LastName from Contacts) From Account WHERE id IN : accId];
        
        for(Account a:accList){
            
            a.Description = String.valueOf(a.contacts.size());
            
            
        }
        
        if(!accList.isEmpty()){
            system.debug('updating Account Description with Contact number');
            update accList;
        }
        
    }

}