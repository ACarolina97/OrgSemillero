/**
 * @description Trigger que detecta cambios en la Opportunity
 * @author        Astrid Leiva
 * @date          2025-11-02
 * @version       1.0
 */
trigger OpptTrigger on Opportunity (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}