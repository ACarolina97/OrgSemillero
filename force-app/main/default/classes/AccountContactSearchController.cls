public with sharing class AccountContactSearchController {

    @AuraEnabled(cacheable=true)
    public static Map<String, List<sObject>> searchRecords(String searchKey) {
        // Validar entrada
        if (String.isBlank(searchKey)) {
            return new Map<String, List<sObject>>{
                'accounts' => new List<Account>(),
                'contacts' => new List<Contact>()
            };
        }

        String likeKey = '%' + searchKey + '%';

        // Consultar cuentas
        List<Account> accounts = [
            SELECT Id, Name, Phone, Industry
            FROM Account
            WHERE Name LIKE :likeKey
            LIMIT 20
        ];

        // Consultar contactos
        List<Contact> contacts = [
            SELECT Id, Name, Email, Phone, Account.Name
            FROM Contact
            WHERE Name LIKE :likeKey
            LIMIT 20
        ];

        // Retornar en un solo mapa
        return new Map<String, List<sObject>>{
            'accounts' => accounts,
            'contacts' => contacts
        };
    }
}