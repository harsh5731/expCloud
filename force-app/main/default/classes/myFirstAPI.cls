//to expose first we need to create gloablly accessible class

@RestResource(urlMapping = '/mysfdcAPI/*')
global class myFirstAPI {
    //to define get method we use this 'httpGet'
    @HttpGet
    global static list<Account> getAccount(){
        
        list<Account> accList = [select id, name from Account limit 10];
        
        system.debug('Postman called the get Method');
        
        return acclist;
        
    }
    
    //to define the post method we use 'httpPost'
    @HttpPost
    global static void createAccount() {
       	
        //to read the data that user send in request body;
        String body = RestContext.request.requestBody.toString();
        
        Map<String, Object> data =
            (Map<String, Object>) JSON.deserializeUntyped(body);
        
        Account postmanAcc = new Account(
            Name = (String)data.get('name'));
        
        Database.insert(postmanAcc);    
        system.debug(data.keySet());
        
    }
    
    @HttpDelete
    global static string deleteAccount(){
        
        Map<String, String> params = RestContext.request.params;
    	System.debug('Params --> ' + params);	
        
        String accountId = params.get('account');
        string AccName = params.get('name');
System.debug('Account Id --> ' + accountId + '' + AccName);
        
        list<Account> accList = [select id from account where id =: accountId];
        String resMess;
        if(!accList.isEmpty()){
            
            delete accList;
            
            resMess =  ' Account has been deleted ';
        }
        else{
            
              resMess =  ' Account Can not be found ';
        
        }
            
        return resMess;
            
    }
    
    @HttpPut
    global static void updateAccountPut() {
        
        String accountId = RestContext.request.params.get('accountId');
        String body = RestContext.request.requestBody.toString();
        
        System.debug('PUT body --> ' + body);
        
        if (String.isBlank(accountId)) {
            RestContext.response.statusCode = 400;
            return;
        }
        
        Map<String, Object> data =
            (Map<String, Object>) JSON.deserializeUntyped(body);
        
        Account acc = new Account(
            Id = accountId,
            Name = (String) data.get('name'),
            Phone = (String) data.get('phone')
        );
        
        upsert acc;
        
        RestContext.response.statusCode = 200;
    }
    
    @HttpPatch
global static void updateAccountPatch() {

    String accountId = RestContext.request.params.get('accountId');
    String body = RestContext.request.requestBody.toString();

    System.debug('PATCH body --> ' + body);

    if (String.isBlank(accountId)) {
        RestContext.response.statusCode = 400;
        return;
    }

    Map<String, Object> data =
        (Map<String, Object>) JSON.deserializeUntyped(body);

    Account acc = new Account(Id = accountId);


    if (data.containsKey('Phone')) {
        acc.Phone = (String) data.get('Phone');
    }

    update acc;

    RestContext.response.statusCode = 200;
}




}