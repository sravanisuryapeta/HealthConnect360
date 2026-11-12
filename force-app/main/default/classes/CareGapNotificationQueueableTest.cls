@IsTest
private class CareGapNotificationQueueableTest {

    @IsTest
    static void testQueueableRunsSuccessfully() {

        Contact patient = new Contact(
            LastName = 'Queueable Test Patient',
            Email = 'testpatient@example.com'
        );
        insert patient;

        Preventive_Care_Plan__c plan =
            new Preventive_Care_Plan__c(
                Patient__c = patient.Id,
                Due_Date__c = Date.today().addDays(-5),
                Status__c = 'Overdue'
            );
        insert plan;

        Test.startTest();

        Id jobId = System.enqueueJob(
            new CareGapNotificationQueueable(
                new Set<Id>{ plan.Id }
            )
        );

        Test.stopTest();

        AsyncApexJob job = [
            SELECT Id, Status
            FROM AsyncApexJob
            WHERE Id = :jobId
        ];

        System.assertEquals(
            'Completed',
            job.Status,
            'The Queueable job should complete successfully.'
        );
    }
}