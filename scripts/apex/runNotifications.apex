
List<Preventive_Care_Plan__c> overduePlans = [
    SELECT Id
    FROM Preventive_Care_Plan__c
    WHERE Status__c = 'Overdue'
];

Set<Id> carePlanIds = new Set<Id>();

for (Preventive_Care_Plan__c plan : overduePlans) {
    carePlanIds.add(plan.Id);
}

if (!carePlanIds.isEmpty()) {
    System.enqueueJob(
        new CareGapNotificationQueueable(carePlanIds)
    );
    System.debug('Queued notifications for ' + carePlanIds.size() + ' overdue care plans.');
} else {
    System.debug('No overdue care plans found.');
}
