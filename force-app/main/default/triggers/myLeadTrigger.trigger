trigger myLeadTrigger on Lead (before insert, before update) {
    // Collect normalized incoming Lead emails
    Set<String> leadEmails = new Set<String>();
    for (Lead l : Trigger.new) {
        if (l.Email != null && !String.isBlank(l.Email)) {
            leadEmails.add(l.Email.trim().toLowerCase());
        }
    }

    // If no emails to check, skip the query and logic
    if (leadEmails.isEmpty()) return;

    // Query Contacts once for any matching emails
    List<Contact> existingContacts = [
        SELECT Id, Email
        FROM Contact
        WHERE Email IN :leadEmails
    ];

    // Normalize contact emails into a set for fast lookup
    Set<String> conEmails = new Set<String>();
    for (Contact c : existingContacts) {
        if (c.Email != null && !String.isBlank(c.Email)) {
            conEmails.add(c.Email.trim().toLowerCase());
        }
    }

    // Mark matching Leads with addError
    for (Lead l : Trigger.new) {
        if (l.Email == null) continue;
        String norm = l.Email.trim().toLowerCase();
        if (conEmails.contains(norm)) {
            l.addError('A Contact with this email already exists. Please use a different email or convert that Contact.');
        }
    }
}