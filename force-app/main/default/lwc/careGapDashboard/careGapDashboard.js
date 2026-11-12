import { LightningElement, wire } from 'lwc';
import getSummary from '@salesforce/apex/CareGapAnalyticsService.getSummary';

export default class CareGapDashboard extends LightningElement {
    summary;
    error;

    @wire(getSummary)
    wiredSummary({ data, error }) {
        if (data) {
            this.summary = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.summary = undefined;
        }
    }

    get metrics() {
        if (!this.summary) {
            return [];
        }

        return [
            { label: 'Total Care Plans', value: this.summary.totalPlans },
            { label: 'Overdue Plans', value: this.summary.overduePlans },
            { label: 'Due Soon', value: this.summary.dueSoonPlans },
            { label: 'Completed Plans', value: this.summary.completedPlans },
            { label: 'Total Outreach Visits', value: this.summary.totalVisits },
            { label: 'Completed Visits', value: this.summary.completedVisits }
        ];
    }
}