public with sharing class CareGapAnalyticsService {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getSummary() {

        Date todayDate = Date.today();
        Date sevenDaysFromNow = todayDate.addDays(7);

        Integer totalPlans = [
            SELECT COUNT()
            FROM Preventive_Care_Plan__c
        ];

        Integer overduePlans = [
            SELECT COUNT()
            FROM Preventive_Care_Plan__c
            WHERE Completion_Date__c = NULL
            AND Due_Date__c < :todayDate
        ];

        Integer dueSoonPlans = [
            SELECT COUNT()
            FROM Preventive_Care_Plan__c
            WHERE Completion_Date__c = NULL
            AND Due_Date__c >= :todayDate
            AND Due_Date__c <= :sevenDaysFromNow
        ];

        Integer completedPlans = [
            SELECT COUNT()
            FROM Preventive_Care_Plan__c
            WHERE Completion_Date__c != NULL
        ];

        Integer totalVisits = [
            SELECT COUNT()
            FROM Outreach_Visit__c
        ];

        Integer completedVisits = [
            SELECT COUNT()
            FROM Outreach_Visit__c
            WHERE Outcome__c IN ('Completed', 'Visit Completed')
        ];

        Map<String, Integer> summary = new Map<String, Integer>();

        summary.put('totalPlans', totalPlans);
        summary.put('overduePlans', overduePlans);
        summary.put('dueSoonPlans', dueSoonPlans);
        summary.put('completedPlans', completedPlans);
        summary.put('totalVisits', totalVisits);
        summary.put('completedVisits', completedVisits);

        return summary;
    }
}