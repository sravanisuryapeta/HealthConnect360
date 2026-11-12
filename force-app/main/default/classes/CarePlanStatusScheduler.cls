global class CarePlanStatusScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CarePlanStatusBatch(), 200);
    }
}