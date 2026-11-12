public class CarePlanTriggerHandler {

    public static void updateCarePlanStatuses(
        List<Preventive_Care_Plan__c> plans
    ) {
        Date todayDate = Date.today();

        for (Preventive_Care_Plan__c plan : plans) {
            if (plan.Completion_Date__c != null) {
                continue;
            }

            if (plan.Due_Date__c == null) {
                plan.Status__c = 'Scheduled';
            } else if (plan.Due_Date__c < todayDate) {
                plan.Status__c = 'Overdue';
            } else if (plan.Due_Date__c <= todayDate.addDays(7)) {
                plan.Status__c = 'Due Soon';
            } else {
                plan.Status__c = 'Scheduled';
            }
        }
    }
}