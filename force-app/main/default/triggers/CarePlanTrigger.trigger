trigger CarePlanTrigger on Preventive_Care_Plan__c (
    before insert,
    before update
) {
    CarePlanTriggerHandler.updateCarePlanStatuses(Trigger.new);
}