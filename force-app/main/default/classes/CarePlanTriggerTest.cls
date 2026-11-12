@IsTest
private class CarePlanTriggerTest {

    @IsTest
    static void testTriggerSetsCarePlanStatuses() {
        Contact patient = new Contact(
            LastName = 'Trigger Test Patient'
        );
        insert patient;

        Date todayDate = Date.today();

        List<Preventive_Care_Plan__c> plans =
            new List<Preventive_Care_Plan__c>{
                new Preventive_Care_Plan__c(
                    Patient__c = patient.Id,
                    Due_Date__c = todayDate.addDays(-2)
                ),
                new Preventive_Care_Plan__c(
                    Patient__c = patient.Id,
                    Due_Date__c = todayDate.addDays(3)
                ),
                new Preventive_Care_Plan__c(
                    Patient__c = patient.Id,
                    Due_Date__c = todayDate.addDays(15)
                )
            };

        Test.startTest();
        insert plans;
        Test.stopTest();

        Map<Id, Preventive_Care_Plan__c> savedPlans =
            new Map<Id, Preventive_Care_Plan__c>([
                SELECT Id, Status__c
                FROM Preventive_Care_Plan__c
                WHERE Id IN :plans
            ]);

        System.assertEquals(
            'Overdue',
            savedPlans.get(plans[0].Id).Status__c
        );
        System.assertEquals(
            'Due Soon',
            savedPlans.get(plans[1].Id).Status__c
        );
        System.assertEquals(
            'Scheduled',
            savedPlans.get(plans[2].Id).Status__c
        );
    }
}