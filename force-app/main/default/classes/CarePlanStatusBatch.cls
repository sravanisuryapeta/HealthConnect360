global class CarePlanStatusBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Due_Date__c, Completion_Date__c, Status__c
            FROM Preventive_Care_Plan__c
            WHERE Completion_Date__c = NULL
        ]);
    }

    global void execute(
        Database.BatchableContext bc,
        List<Preventive_Care_Plan__c> scope
    ) {
        Date todayDate = Date.today();

        for (Preventive_Care_Plan__c plan : scope) {
            if (plan.Due_Date__c == NULL) {
                plan.Status__c = 'Scheduled';
            } else if (plan.Due_Date__c < todayDate) {
                plan.Status__c = 'Overdue';
            } else if (plan.Due_Date__c <= todayDate.addDays(7)) {
                plan.Status__c = 'Due Soon';
            } else {
                plan.Status__c = 'Scheduled';
            }
        }

        if (!scope.isEmpty()) {
            update scope;
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Care plan status batch completed.');
    }
}