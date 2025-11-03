({
    doInit : function(component, event, helper) {
        var action = component.get("c.getTasks");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.tasks", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    handleTaskChange : function(component, event, helper) {
        var selectedTaskId = component.get("v.selectedTaskId");
        if (selectedTaskId) {
            var tasks = component.get("v.tasks");
            var selectedTask = tasks.find(t => t.Id === selectedTaskId);
            component.set("v.selectedTask", selectedTask);
        } else {
            component.set("v.selectedTask", null);
        }
    }
})