@IsTest
public class CareGapAnalyticsServiceTest {

    @IsTest
    static void testGetSummary() {

        Contact patient = new Contact(
            LastName = 'Test Patient'
        );
        insert patient;

        Care_Case__c careCase = new Care_Case__c(
            Patient__c = patient.Id,
            Case_Type__c = 'Routine Check-up',
            Status__c = 'New',
            Region__c = 'South'
        );
        insert careCase;

        List<Preventive_Care_Plan__c> plans =
            new List<Preventive_Care_Plan__c>();

        plans.add(new Preventive_Care_Plan__c(
            Patient__c = patient.Id,
            Care_Case__c = careCase.Id,
            Care_Type__c = 'Routine Check-up',
            Due_Date__c = Date.today().addDays(-5),
            Status__c = 'Overdue',
            Region__c = 'South'
        ));

        plans.add(new Preventive_Care_Plan__c(
            Patient__c = patient.Id,
            Care_Case__c = careCase.Id,
            Care_Type__c = 'Routine Check-up',
            Due_Date__c = Date.today().addDays(3),
            Status__c = 'Due Soon',
            Region__c = 'South'
        ));

        plans.add(new Preventive_Care_Plan__c(
            Patient__c = patient.Id,
            Care_Case__c = careCase.Id,
            Care_Type__c = 'Routine Check-up',
            Due_Date__c = Date.today().addDays(30),
            Status__c = 'Scheduled',
            Region__c = 'South'
        ));

        plans.add(new Preventive_Care_Plan__c(
            Patient__c = patient.Id,
            Care_Case__c = careCase.Id,
            Care_Type__c = 'Routine Check-up',
            Due_Date__c = Date.today(),
            Completion_Date__c = Date.today(),
            Status__c = 'Completed',
            Region__c = 'South'
        ));

        insert plans;

        List<Outreach_Visit__c> visits =
            new List<Outreach_Visit__c>();

        visits.add(new Outreach_Visit__c(
            Patient__c = patient.Id,
            Preventive_Care_Plan__c = plans[0].Id,
            Contact_Method__c = 'Phone Call',
            Outcome__c = 'Completed',
            Visit_Date__c = Date.today(),
            Region__c = 'South'
        ));

        visits.add(new Outreach_Visit__c(
            Patient__c = patient.Id,
            Preventive_Care_Plan__c = plans[1].Id,
            Contact_Method__c = 'Phone Call',
            Outcome__c = 'Reached - Scheduled',
            Visit_Date__c = Date.today(),
            Region__c = 'South'
        ));

        insert visits;

        Test.startTest();
        Map<String, Integer> result =
            CareGapAnalyticsService.getSummary();
        Test.stopTest();

        System.assertEquals(4, result.get('totalPlans'));
        System.assertEquals(1, result.get('overduePlans'));
        System.assertEquals(1, result.get('dueSoonPlans'));
        System.assertEquals(1, result.get('completedPlans'));
        System.assertEquals(2, result.get('totalVisits'));
        System.assertEquals(1, result.get('completedVisits'));
    }
}