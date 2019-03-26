import { LightningElement, wire, track } from 'lwc';
//import getRecordList from '@salesforce/apex/RecordController.getRecordList';
import getEmailConfig from '@salesforce/apex/emailConfig.getEmailConfig';
import getPDF from '@salesforce/apex/emailConfig.getPDF';

export default class EmailBatch extends LightningElement {
    @track fieldSet;
    @track error;

    @wire(getEmailConfig, {})
    getEmailConfig({ error, data }) {
        if (data) {
            console.log('getEmailConfig');
            console.log(data);
            this.fieldSet = data;
        } else if (error) {
            this.error = error;
            console.log('getEmailConfig error');
            console.log(error);
        }
    }

    @wire(getPDF, {})
    getPDF({ error, data }) {
        if (data) {            
            console.log('getPDF');
            let pdfbase64 = JSON.parse(data);
            let byteCharacters = atob(pdfbase64);
            let byteNumbers = new Array(pdfbase64.length);
            for (let i = 0; i < byteCharacters.length; i++) {
                byteNumbers[i] = byteCharacters.charCodeAt(i);
            }
            let byteArray = new Uint8Array(byteNumbers);
            let blob = new Blob([byteArray], {type: "application/pdf"});
            console.log(blob);
        } else if (error) {
            this.error = error;
            console.log('getPDF error');
        }
    }
}