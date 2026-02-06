trigger PreventDuplicateContactUpdate on Contact (before insert, before update) {
    Set<String> uniqueKeys = new Set<String>();
    Map<Id, String> newContactKeys = new Map<Id, String>();
    Set<Id> accIds = new Set<Id>();

    // Step 1: Gather new composite keys
    for(Contact con : Trigger.new) {
        if(con.FirstName != null && con.LastName != null && con.AccountId != null) {
            String key = con.AccountId + '_' + con.FirstName.trim().toLowerCase() + '_' + con.LastName.trim().toLowerCase();
            uniqueKeys.add(key);
            newContactKeys.put(con.Id, key);
            accIds.add(con.AccountId);
        }
    }

    // Step 2: Query existing contacts – exclude those currently being updated
    List<Contact> existingContacts = [
        SELECT Id, AccountId, FirstName, LastName
        FROM Contact
        WHERE AccountId IN :accIds 
          AND FirstName != null AND LastName != null
          AND Id NOT IN :newContactKeys.keySet()
    ];

    // Build map for fast lookup
    Map<String, Contact> existingContactsMap = new Map<String, Contact>();
    for(Contact ec : existingContacts) {
        String key = ec.AccountId + '_' + ec.FirstName.trim().toLowerCase() + '_' + ec.LastName.trim().toLowerCase();
        existingContactsMap.put(key, ec);
    }

    // Step 3: Check for duplicate – don’t let self-updates throw errors
    for(Contact con : Trigger.new) {
        String key = newContactKeys.get(con.Id);
        if(existingContactsMap.containsKey(key)) {
            con.addError('A contact with the same first name and last name already exists for this Account.');
        }
    }
}