public with sharing class AccountDataController {
    public Id selectedAccountId { get; set; }
    public Account selectedAccount { get; set; }
    public List<Account> accounts { get; set; }
    public List<Contact> contacts { get; set; }
    public List<Case> cases { get; set; }

    public AccountDataController() {
        accounts = [SELECT Id, Name FROM Account ORDER BY Name LIMIT 50];
    }

    public List<SelectOption> getAccountOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Selecciona una cuenta--')); // opción vacía
        for (Account a : accounts) {
            options.add(new SelectOption(a.Id, a.Name));
        }
        return options;
    }

    public void loadData() {

        // Solo ejecutar SOQL si el Id es válido
        if (selectedAccountId != null ) {
            selectedAccount = [
                SELECT Id, Name, Phone, Type, Industry
                FROM Account
                WHERE Id = :selectedAccountId
                LIMIT 1
            ];
            contacts = [
                SELECT Id, Name, Email, Phone
                FROM Contact
                WHERE AccountId = :selectedAccountId
            ];
            cases = [
                SELECT Id, CaseNumber, Subject, Status
                FROM Case
                WHERE AccountId = :selectedAccountId
            ];
        } else {
            selectedAccount = new Account();
            contacts = new List<Contact>();
            cases = new List<Case>();
        }
    }
}