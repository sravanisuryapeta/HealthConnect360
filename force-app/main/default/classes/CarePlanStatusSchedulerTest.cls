@IsTest
private class CarePlanStatusSchedulerTest {

    @IsTest
    static void testSchedulerRunsBatch() {

        Test.startTest();

        String cronExpression = '0 0 2 * * ?';

        System.schedule(
            'Care Plan Status Scheduler Test',
            cronExpression,
            new CarePlanStatusScheduler()
        );

        Test.stopTest();

        List<CronTrigger> jobs = [
            SELECT Id, State, CronExpression
            FROM CronTrigger
            WHERE CronExpression = :cronExpression
        ];
        System.assert(
            !jobs.isEmpty(),
            'The care plan scheduler should be registered.'
        );
    }
}