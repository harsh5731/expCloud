import { LightningElement } from 'lwc';
import createCase from '@salesforce/apex/GuestCaseController.createCase';

export default class GuestCaseForm extends LightningElement {
    name;
    email;
    subject;
    description;
    caseNumber;

    handleName(event) {
        this.name = event.target.value;
    }

    handleEmail(event) {
        this.email = event.target.value;
    }

    handleSubject(event) {
        this.subject = event.target.value;
    }

    handleDescription(event) {
        this.description = event.target.value;
    }

    handleSubmit() {
        createCase({
            name: this.name,
            email: this.email,
            subject: this.subject,
            description: this.description
        })
            .then(result => {
                this.caseNumber = result;
            })
            .catch(error => {
                console.error(error);
            });
    }
}
