public class CareGapNotificationQueueable
    implements Queueable {

    private Set<Id> carePlanIds;

    public CareGapNotificationQueueable(Set<Id> carePlanIds) {
        this.carePlanIds = carePlanIds;
    }

    public void execute(QueueableContext context) {

        List<Preventive_Care_Plan__c> plans = [
            SELECT Id, Name, Due_Date__c, Status__c,
                   Patient__r.Name, Patient__r.Email
            FROM Preventive_Care_Plan__c
            WHERE Id IN :carePlanIds
            AND Status__c = 'Overdue'
        ];

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for (Preventive_Care_Plan__c plan : plans) {

            if (plan.Patient__r != null &&
                String.isNotBlank(plan.Patient__r.Email)) {

                Messaging.SingleEmailMessage email =
                    new Messaging.SingleEmailMessage();

                email.setToAddresses(
                    new List<String>{ plan.Patient__r.Email }
                );

                email.setSubject(
                    'HealthConnect 360: Overdue Care Plan'
                );

                email.setPlainTextBody(
                    'Hello ' + plan.Patient__r.Name + ',\n\n' +
                    'Our records show that your care plan (' +
                    plan.Name + ') is overdue.\n' +
                    'Due date: ' + String.valueOf(plan.Due_Date__c) +
                    '\n\nPlease contact your healthcare provider ' +
                    'to discuss the next steps.\n\n' +
                    'HealthConnect 360'
                );

                emails.add(email);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}