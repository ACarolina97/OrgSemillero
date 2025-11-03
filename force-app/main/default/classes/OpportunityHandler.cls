/**
 * @description   Clase que maneja la lógica cuando cambia el estado (StageName) de una oportunidad.
 * @author        Astrid Leiva
 * @date          2025-11-02
 * @version       1.0
 */
public with sharing class  OpportunityHandler {

    public static void onBeforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        String currentUser = [SELECT Name FROM User WHERE Id = :UserInfo.getUserId()].Name;
        DateTime now = System.now();

        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);

            if (opp.StageName != oldOpp.StageName) {
                String previousStage = oldOpp.StageName != null ? oldOpp.StageName : 'N/A';
                String newStage = opp.StageName != null ? opp.StageName : 'N/A';

                String changeLog = 'Estado actualizado de "' + previousStage + '" a "' + newStage + '" por ' + currentUser + ' el ' + now.format('yyyy-MM-dd HH:mm') + '.';

                if (String.isNotBlank(oldOpp.Description)) {
                    opp.Description = oldOpp.Description + '\n' + changeLog;
                } else {
                    opp.Description = changeLog;
                }
            }
        }
    }
}