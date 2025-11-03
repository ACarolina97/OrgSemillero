public with sharing class ActivityRelatedRecordController {

    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks() {
        return [
            SELECT Id, Subject, Status, ActivityDate, WhoId, WhatId, 
                   Who.Name, What.Name
            FROM Task
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Task getTaskDetails(Id taskId) {
        return [
            SELECT Id, Subject, Status, ActivityDate, WhoId, WhatId,
                   Who.Name, What.Name
            FROM Task
            WHERE Id = :taskId
            LIMIT 1
        ];
    }
}