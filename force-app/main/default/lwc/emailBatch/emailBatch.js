import { LightningElement, wire, track } from 'lwc';
import runBatch from '@salesforce/apex/emailConfig.runBatch';
import getStatus from '@salesforce/apex/emailConfig.getStatus';

export default class EmailBatch extends LightningElement {
    @track fieldSet;
    @track error;
    @track batchId;
    @track batchStatus;
 
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
                this.batchStatus = JSON.parse(data).Status;
            })
            .catch(error => {
                console.log('getStatus error');
                this.error = error;
            });
    }
}