@IsTest
public class myFirstAPITest {

    // Utility method to create an Account for reuse
    private static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    @IsTest
    static void testGetAccount() {

        createTestAccount();

        Test.startTest();
        List<Account> result = myFirstAPI.getAccount();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.size() > 0, 'Should return at least one account');
    }

    @IsTest
    static void testCreateAccount() {

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/mysfdcAPI/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"name":"Postman Test Account"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        myFirstAPI.createAccount();
        Test.stopTest();

        Account acc =
            [SELECT Id, Name FROM Account WHERE Name = 'Postman Test Account' LIMIT 1];

        System.assertEquals(
            'Postman Test Account',
            acc.Name,
            'Account should be created from POST'
        );
    }

    @IsTest
    static void testDeleteAccount() {

        Account acc = createTestAccount();

        RestRequest req = new RestRequest();
        req.requestUri =
            '/services/apexrest/mysfdcAPI/?account=' + acc.Id;
        req.httpMethod = 'DELETE';

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String response = myFirstAPI.deleteAccount();
        Test.stopTest();

        Integer countAcc =
            [SELECT COUNT() FROM Account WHERE Id = :acc.Id];

        System.assertEquals(0, countAcc, 'Account should be deleted');
        System.assert(response.contains('deleted'),
            'Response message should confirm deletion');
    }

    @IsTest
    static void testUpdateAccountPut() {

        Account acc = createTestAccount();

        RestRequest req = new RestRequest();
        req.requestUri =
            '/services/apexrest/mysfdcAPI/?accountId=' + acc.Id;
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(
            '{"name":"Updated Name","phone":"1234567890"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        myFirstAPI.updateAccountPut();
        Test.stopTest();

        Account updated =
            [SELECT Name, Phone FROM Account WHERE Id = :acc.Id];

        System.assertEquals('Updated Name', updated.Name);
        System.assertEquals('1234567890', updated.Phone);
    }

    @IsTest
    static void testUpdateAccountPatch() {

        Account acc = createTestAccount();

        RestRequest req = new RestRequest();
        req.requestUri =
            '/services/apexrest/mysfdcAPI/?accountId=' + acc.Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(
            '{"Phone":"9999999999"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        myFirstAPI.updateAccountPatch();
        Test.stopTest();

        Account updated =
            [SELECT Phone FROM Account WHERE Id = :acc.Id];

        System.assertEquals('9999999999', updated.Phone);
    }
}