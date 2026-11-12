# HealthConnect 360 — Salesforce Care Gap Management System

## 1. Project Overview

HealthConnect 360 is a Salesforce-based preventive healthcare management solution designed to help care teams track preventive care plans, identify care gaps, manage patient outreach, and monitor follow-up activities.

The system uses Salesforce automation, Apex business logic, approval workflows, and a Lightning Web Component (LWC) dashboard to help care managers monitor overdue and upcoming care plans and manage preventive care activities.

## 2. Problem Statement

Healthcare teams need a reliable way to identify overdue preventive care, organize patient follow-ups, and track outreach activities. Manual tracking can make it difficult to prioritize care gaps and maintain consistent follow-up.

HealthConnect 360 addresses this problem by centralizing care plan information, automating status updates, supporting approval workflows, and providing dashboard-based visibility into care gaps.

## 3. Key Features

- **Care Plan Management:** Track preventive care plans, due dates, completion dates, priorities, and statuses.
- **Care Gap Dashboard:** Display total care plans, overdue plans, plans due soon, completed plans, total outreach visits, and completed visits.
- **Automated Status Updates:** Use Apex triggers, batch processing, and scheduled Apex to manage care plan statuses.
- **Outreach Task Automation:** Use a scheduled Flow to identify overdue or soon-due plans and create outreach tasks when an existing task is not found.
- **Care Case Management:** Manage care cases and update their status through record-triggered Flow automation.
- **Approval Workflow:** Submit eligible overdue care plans for review and record approval decisions.
- **Validation Rules:** Prevent invalid completion dates, past follow-up dates, and future outreach visit dates.
- **Notification Processing:** Use Queueable Apex to process notifications for overdue care plans.
- **Access Management:** Configure a Care Manager permission set with selected object and field permissions.

## 4. Technology Stack

| Technology | Purpose |
|---|---|
| Salesforce Platform | Application platform and data management |
| Apex | Server-side business logic |
| Apex Triggers | Care plan status processing |
| Batch Apex | Bulk care plan status processing |
| Scheduled Apex | Scheduled status updates |
| Queueable Apex | Asynchronous notification processing |
| Lightning Web Components | Dashboard user interface |
| Salesforce Flows | Record-triggered and scheduled automation |
| Approval Processes | Care plan review and approval |
| SOQL | Querying Salesforce records |
| Salesforce CLI | Deployment, retrieval, and test execution |
| Visual Studio Code | Development environment |

## 5. System Architecture

The solution follows a Salesforce-native architecture.

1. **Data Layer:** Stores preventive care plans, care cases, contacts, and outreach visit records.
2. **Business Logic Layer:** Apex classes, triggers, batch jobs, scheduled jobs, and Queueable Apex handle business processing.
3. **Automation Layer:** Scheduled and record-triggered Flows automate outreach and care case updates. Validation rules enforce data quality.
4. **Approval Layer:** The Care Plan Approval process supports review and approval of eligible overdue care plans.
5. **Presentation Layer:** The HealthConnect 360 Care Gap Dashboard Lightning Web Component presents care gap metrics to users.

## 6. Data Model

The solution uses Salesforce objects and relationships to organize preventive care activities.

- **Preventive Care Plan (`Preventive_Care_Plan__c`):** Stores care plan information, patient relationship, due date, completion date, status, assigned worker, and related care case.
- **Care Case (`Care_Case__c`):** Supports care case management, recommendations, priority, and follow-up activities.
- **Contact:** Represents the patient associated with a preventive care plan.
- **Outreach Visit:** Stores outreach activity information, including visit date, contact method, outcome, notes, and next action date.

The Preventive Care Plan object includes formula fields for care gap priority and days overdue.

## 7. Automation and Business Rules

### Apex Components

- `CarePlanTrigger` — invokes care plan status processing before insert and update.
- `CarePlanTriggerHandler` — evaluates due dates and updates care plan statuses.
- `CarePlanStatusBatch` — processes care plan status updates in bulk.
- `CarePlanStatusScheduler` — schedules daily care plan status processing.
- `CareGapAnalyticsService` — provides care gap metrics for the dashboard.
- `CareGapNotificationQueueable` — processes notifications for overdue care plans.

### Salesforce Flows

- **CareGap Radar - Daily Outreach:** Scheduled Flow that checks eligible care plans and creates outreach tasks when no existing task is found.
- **Care Case - Set Status on Recommendation:** Record-triggered Flow that updates a care case status when its configured conditions are met.

### Approval Process

The **Care Plan Approval** process allows eligible overdue care plans to be submitted for review. The approval process was tested successfully using a demonstration care plan.

### Validation Rules

- `Completion_Date_After_Due_Date`
- `Next_Follow_Up_Date_Validation`
- `Outreach_Visit_Date_Validation`

These rules help maintain consistent and valid care management data.

## 8. Dashboard

The HealthConnect 360 Care Gap Dashboard provides a summary of care plan and outreach activity.

The last verified dashboard displayed:

| Metric | Value |
|---|---:|
| Total Care Plans | 4 |
| Overdue Plans | 1 |
| Due Soon | 2 |
| Completed Plans | 0 |
| Total Outreach Visits | 1 |
| Completed Visits | 0 |

These values represent the demonstration dataset at the time of verification and may change as records are updated.

## 9. Testing and Code Coverage

The following Apex test classes passed in the connected development org:

- `CareGapAnalyticsServiceTest`
- `CarePlanStatusBatchTest`
- `CarePlanStatusSchedulerTest`
- `CareGapNotificationQueueableTest`
- `CarePlanTriggerTest`

**Last verified test results:**
- Tests passed: 5
- Test failures: 0
- Org-wide Apex code coverage: 97%

The notification Queueable completed without reported asynchronous job errors. Actual email delivery has not been independently confirmed.

## 10. Prerequisites

- A Salesforce Developer Edition org or another appropriately configured Salesforce org.
- Salesforce CLI installed.
- Visual Studio Code with the Salesforce Extension Pack.
- Access to the relevant Salesforce objects, fields, Apex classes, Flows, and Lightning pages.

## 11. Working with the Project

Open the project directory in Visual Studio Code and authorize your Salesforce development org.

Check the current org connection:

```powershell
sf org list
```

Open the connected org:

```powershell
sf org open --target-org HealthConnect360
```

Run the local-org Apex tests and collect code coverage:

```powershell
sf apex run test --test-level RunLocalTests --code-coverage --target-org HealthConnect360 --wait 10
```

Deploy project metadata when required:

```powershell
sf project deploy start --target-org HealthConnect360
```

**Important:** Review pending source changes and confirm the target org before deploying. The project already contains configured metadata and scheduled jobs; avoid unintentionally duplicating scheduled automation.

## 12. Future Enhancements

- Confirm notification delivery through a valid test recipient and Salesforce email logs.
- Add more detailed dashboard filters and trend reporting.
- Expand test coverage for edge cases and bulk record processing.
- Validate the Care Manager permission set using a non-administrator test user.
- Improve deployment documentation and provide screenshots of key workflows.

## 13. Conclusion

HealthConnect 360 demonstrates how Salesforce can be used to coordinate preventive care plans, identify care gaps, automate follow-up activities, manage approvals, and present operational metrics through a dashboard.

The project combines declarative Salesforce tools with Apex development to demonstrate an integrated care management workflow.