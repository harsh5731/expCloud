@isTest
public class futueMethodsTest {
    @isTest
    private static void countContacts(){
        list<account> acList = new List<account>();
        
        for(Integer i=0; i<100;i++){
            acList.add(new Account(name='Test'+i));
        }
        insert acList;
        
        list<Contact> conList = new List<contact>();
        List<id> accIds = new List<id>();
        For(Account acc: acList){
            conList.add(New Contact(LastName='Test',AccountId=acc.Id));
            accIds.add(acc.Id);
        }
        
        insert conList;
        
        Test.startTest();
        futueMethods.myFutureMethod(accIds);
    }

}