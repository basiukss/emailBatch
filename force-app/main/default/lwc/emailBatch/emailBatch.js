import { LightningElement, wire, track } from 'lwc';
//import getRecordList from '@salesforce/apex/RecordController.getRecordList';
//import getEmailConfig from '@salesforce/apex/emailConfig.getEmailConfig';
import runBatch from '@salesforce/apex/emailConfig.runBatch';
import getStatus from '@salesforce/apex/emailConfig.getStatus';

export default class EmailBatch extends LightningElement {
    @track fieldSet;
    @track error;
    @track batchId;
    @track batchStatus;
/*
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
*/   
    handleRunBatch() {
        console.log('runBatch');
        runBatch()
            .then(data => {                
                console.log(data);
                this.batchId = data;
            })
            .catch(error => {
                console.log('runBatch error');
                this.error = error;
            });
    }
    handleGetStatus() {
        console.log('getStatus');
        getStatus({jobId : this.batchId})
            .then(data => {                
                console.log(data);
                this.batchStatus = data.status;
            })
            .catch(error => {
                console.log('getStatus error');
                this.error = error;
            });
    }
}