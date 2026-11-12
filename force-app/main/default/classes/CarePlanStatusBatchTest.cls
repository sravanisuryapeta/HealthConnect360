@IsTest
private class CarePlanStatusBatchTest {

    @IsTest
    static void testBatchUpdatesStatuses() {
        Date todayDate = Date.today();

        Contact patient = new Contact(
            LastName = 'Batch Test Patient'
        );
        insert patient;

        List<Preventive_Care_Plan__c> plans =
            new List<Preventive_Care_Plan__c>{
                new Preventive_Care_Plan__c(
                    Patient__c = patient.Id,
                    Due_Date__c = todayDate.addDays(-2),
                    Status__c = 'Scheduled'
                ),
                new Preventive_Care_Plan__c(
                    Patient__c = patient.Id,
                    Due_Date__c = todayDate.addDays(3),
                    Status__c = 'Scheduled'
                ),
                new Preventive_Care_Plan__c(
                    Patient__c = patient.Id,
                    Due_Date__c = todayDate.addDays(15),
                    Status__c = 'Due Soon'
                )
            };

        insert plans;

        Test.startTest();
        Database.executeBatch(
            new CarePlanStatusBatch(),
            200
        );
        Test.stopTest();

        Map<Id, Preventive_Care_Plan__c> updatedPlans =
            new Map<Id, Preventive_Care_Plan__c>([
                SELECT Id, Status__c
                FROM Preventive_Care_Plan__c
                WHERE Id IN :plans
            ]);

        System.assertEquals(
            'Overdue',
            updatedPlans.get(plans[0].Id).Status__c,
            'Past-due plans should become Overdue.'
        );

        System.assertEquals(
            'Due Soon',
            updatedPlans.get(plans[1].Id).Status__c,
            'Plans due within seven days should become Due Soon.'
        );

        System.assertEquals(
            'Scheduled',
            updatedPlans.get(plans[2].Id).Status__c,
            'Plans due later should become Scheduled.'
        );
    }
}