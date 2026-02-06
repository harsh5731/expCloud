import { LightningElement,api,wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getOpportunitySummary from '@salesforce/apex/OpportunityStatsService.getOpportunitySummary';

// Fields to pull via LDS
const FIELDS = [
    'Account.Name',
    'Account.Industry',
    'Account.AnnualRevenue',
    'Account.Rating'
];
export default class AccountInsightsPanel extends LightningElement {

 @api recordId;

    // --- LDS (getRecord) state ---
    accountData = null;
    accountError = null;
    isLdsLoading = false;

    // --- Apex (Opportunity analytics) state ---
    apexData = null;
    apexError = null;
    isApexLoading = false;
    apexWireReference; // original result object for refreshApex

    // --- Wire: LDS getRecord (function form to manage loading state) ---
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount(result) {
        // result shape: { data, error }
        this.isLdsLoading = true;
        this.accountData = null;
        this.accountError = null;

        if (result.data) {
            this.accountData = result.data;
            this.accountError = null;
        } else if (result.error) {
            this.accountData = null;
            this.accountError = result.error;
            // console.error('LDS getRecord error', result.error);
        }
        this.isLdsLoading = false;
    }

    // --- Wire: Apex method for Opportunity analytics ---
    @wire(getOpportunitySummary, { accountId: '$recordId' })
    wiredOpportunity(result) {
        // keep reference for refreshApex
        this.apexWireReference = result;
        this.isApexLoading = true;
        this.apexData = null;
        this.apexError = null;

        if (result.data) {
            this.apexData = result.data;
            this.apexError = null;
        } else if (result.error) {
            this.apexData = null;
            this.apexError = result.error;
            // console.error('Apex error', result.error);
        }
        this.isApexLoading = false;
    }

    // --- Refresh handler (refreshes only the Apex wired data) ---
    handleRefreshApex() {
        if (!this.apexWireReference) {
            return;
        }
        // set loading true to show refresh spinner immediately
        this.isApexLoading = true;
        refreshApex(this.apexWireReference)
            .then(() => {
                // refreshApex completes and the wire will re-populate apexData/apexError
                // wire callback will reset isApexLoading = false, but we also ensure it here for edge cases
                // small delay allowed for wire; keep optimistic UX
            })
            .catch((err) => {
                // refreshApex error — surface it
                this.apexError = err;
                this.apexData = null;
            })
            .finally(() => {
                this.isApexLoading = false; 
            });
    }

    // --- Combined readiness ---
    get isReady() {
        return !this.isLdsLoading && !this.isApexLoading;
    }

    // --- Safe getters for account fields (returns '—' when missing) ---
    get accountName() {
        return this.accountData ? getFieldValue(this.accountData, 'Account.Name') || '—' : '—';
    }

    get accountIndustry() {
        return this.accountData ? getFieldValue(this.accountData, 'Account.Industry') || '—' : '—';
    }

    get accountAnnualRevenue() {
        const raw = this.accountData ? getFieldValue(this.accountData, 'Account.AnnualRevenue') : null;
        return (raw != null) ? new Intl.NumberFormat().format(raw) : '—';
    }

    get accountRating() {
        return this.accountData ? getFieldValue(this.accountData, 'Account.Rating') || '—' : '—';
    }

    // --- Safe getters for Apex Opportunity stats ---
    get totalOpportunityAmount() {
        return this.apexData && this.apexData.totalAmount != null
            ? Number(this.apexData.totalAmount).toLocaleString()
            : '—';
    }

    get closedWonCount() {
        return this.apexData && this.apexData.closedWonCount != null
            ? this.apexData.closedWonCount
            : '—';
    }

    get openOpportunityCount() {
        return this.apexData && this.apexData.openOpportunityCount != null
            ? this.apexData.openOpportunityCount
            : '—';
    }

    get totalOpportunityCount() {
        return this.apexData && this.apexData.totalOpportunityCount != null
            ? this.apexData.totalOpportunityCount
            : '—';
    }

    get averageDealSize() {
        return this.apexData && this.apexData.averageDealSize != null
            ? Number(this.apexData.averageDealSize).toLocaleString(undefined, { maximumFractionDigits: 2 })
            : '—';
    }

    // --- Optional Senior-Level Bonus: Deal Velocity Score ---
    // A lightweight, display-only heuristic:
    // velocity = (closedWonCount * averageDealSize) / (openOpportunityCount + 1)
    // normalized to 0..100 by using a sensible cap so the progress bar stays meaningful.
    get dealVelocityScore() {
        if (!this.apexData) return 0;

        const closed = Number(this.apexData.closedWonCount || 0);
        const open = Number(this.apexData.openOpportunityCount || 0);
        const avg = Number(this.apexData.averageDealSize || 0);

        // raw velocity
        let raw = (closed * avg) / (open + 1);

        // normalization: map raw to 0-100. Choose a cap so big accounts don't always hit 100.
        const CAP = 250000; // tweakable — treat CAP as "excellent" velocity threshold
        let scaled = Math.round((raw / CAP) * 100);

        if (scaled < 0) scaled = 0;
        if (scaled > 100) scaled = 100;
        return scaled;
    }

    // small helper to decide if we should render apex error block
    get hasApexError() {
        return !!this.apexError;
    }

    get hasLdsError() {
        return !!this.accountError;
    }
}