({
    loadRelatedInfo : function(component) {
        let recordId = component.get("v.recordId");

        if (!recordId) {
            component.set("v.errorMessage", "No se encontró el Id del registro de actividad.");
            return;
        }

        let action = component.get("c.getRelatedRecordInfo");
        action.setParams({ activityId: recordId });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.relatedInfo", response.getReturnValue());
            } else {
                component.set("v.errorMessage", "Error al obtener la información del registro relacionado.");
                console.error(response.getError());
            }
        });

        $A.enqueueAction(action);
    }
})