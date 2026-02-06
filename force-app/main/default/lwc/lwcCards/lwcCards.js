import { LightningElement, api, wire } from 'lwc';
import { getRecord, getRecordUi } from 'lightning/uiRecordApi';

// Change to your object / fields
const FIELDS = ['Account.Name', 'Account.Phone'];

export default class LwcCards extends LightningElement {
    @api recordId; // populated automatically on a record page
    showNewCard = false;

    handleClick() {
        this.showNewCard = !this.showNewCard;
    }

    // --- getRecord: just the record data ---
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data, error }) {
        if (data) {
            // Look at this in browser console to see the structure
            console.log('getRecord data 👉', (JSON.stringify(data)));
            this._record = data;
        } else if (error) {
            console.error('getRecord error 👉', error);
        }
    }

    // --- getRecordUi: record + layouts + metadata ---
    @wire(getRecordUi, {
        recordIds: '$recordId',
        layoutTypes: ['Full'],
        modes: ['View']
    })
    wiredRecordUi({ data, error }) {
        if (data) {
            console.log('getRecordUi data 👉', (JSON.stringify(data)));
            this._recordUi = data;
        } else if (error) {
            console.error('getRecordUi error 👉', error);
        }
    }

    // Getter: simple field from getRecord
    get recordName() {
        return this._record?.fields?.Name?.value;
    }

    // Getter: object label from getRecordUi
    get uiLabel() {
        if (!this._recordUi || !this.recordId) return undefined;

        // Get the record from records map
        const rec = this._recordUi.records[this.recordId];
        const apiName = rec.apiName; // e.g. 'Account'

        // Use objectInfos from getRecordUi
        const objInfo = this._recordUi.objectInfos[apiName];
        return objInfo?.label; // e.g. 'Account'
    }
}