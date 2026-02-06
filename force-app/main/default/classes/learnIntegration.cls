public class learnIntegration {
    
    public static void makeRequestToApi(){
        
        Http ht = new Http(); 
        
        HttpRequest myReq = new HttpRequest();
        
        myReq.setEndpoint('callout:Global_Warming_APIs/api/temperature-api');
        myReq.setMethod('GET');
        
        HttpResponse myRes = ht.send(myReq);
        
        if(myRes.getStatusCode() == 200){
            system.debug('we make our first api call -->'+ myRes.getBody());
        }
        else{
            system.debug('Api call Failed -->'+ myRes);
        }
        
    }

}