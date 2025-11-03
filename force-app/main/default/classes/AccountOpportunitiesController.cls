/**
 * @description   Controlador Apex para gestionar las Oportunidades relacionadas a una Cuenta.
 *                Permite consultar oportunidades por AccountId y actualizar su estado (StageName).
 * @author        Astrid Leiva
 * @date          2025-11-02
 * @version       1.0
 */
public with sharing class AccountOpportunitiesController {
    
   @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name
            FROM Account
            ORDER BY Name
            LIMIT 100
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccountId(Id accountId) {
        if (accountId == null) return new List<Opportunity>();

        return [
            SELECT Id, Name, StageName, CloseDate, Amount, Account.Name
            FROM Opportunity
            WHERE AccountId = :accountId
            ORDER BY CloseDate DESC
        ];
    }

    @AuraEnabled
    public static void updateOpportunityStage(Id oppId, String newStage) {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :oppId LIMIT 1];
        opp.StageName = newStage;
        update opp;
    }

    /**
     * @description Devuelve los valores válidos del picklist StageName del objeto Opportunity.
     */
    @AuraEnabled(cacheable=true)
    public static List<String> getStageNamePicklistValues() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getValue());
        }
        return values;
    }
}