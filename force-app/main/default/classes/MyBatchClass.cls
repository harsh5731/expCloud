/*creating my first batch in this we are updating the account description*/


public class MyBatchClass implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name FROM Account'
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            acc.Description = 'Running My First Batch';
        }

        Database.update(scope, false);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Apex Finished Successfully');
    }
}