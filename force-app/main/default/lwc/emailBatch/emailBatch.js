import { LightningElement, wire, track } from 'lwc';
import runBatch from '@salesforce/apex/emailConfig.runBatch';
import getStatus from '@salesforce/apex/emailConfig.getStatus';
import getBatchStatus from '@salesforce/apex/emailConfig.getBatchStatus';
import runScheduleBatch from '@salesforce/apex/emailConfig.runScheduleBatch';
import getCronStatus from '@salesforce/apex/emailConfig.getCronStatus';

export default class EmailBatch extends LightningElement {
    @track fieldSet;
    @track error;
    
    @track batchId;
    @track batchStatus;
    
    @track cronId;
    @track cronTrigger;
 
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

    handleGetBatchStatus() {
        console.log('getBatchStatus');
        getBatchStatus()
            .then(data => {   
                console.log(data);
                let result = JSON.parse(data);
                let msg ='';
                for(let i = 0; i< result.length; i++){
                        msg += '\n Status: ' + result[i].Status +
                                ' CreatedDate: ' + result[i].CreatedDate +
                                ' CompletedDate: ' + result[i].CompletedDate;
                }
                console.log(msg);
                this.batchStatus = JSON.parse(data);
            })
            .catch(error => {
                console.log('getBatchStatus error');
                this.error = error;
            });
    }

    handleRunScheduleBatch() {
        console.log('runScheduleBatch');
        runScheduleBatch()
            .then(data => {                
                console.log(data);
                this.cronId = data;
            })
            .catch(error => {
                console.log('runScheduleBatch error');
                this.error = error;
            });
    }

    handleGetCronStatus() {
        console.log('getCronStatus ' + this.cronId);
        getCronStatus({cronId : this.cronId})
            .then(data => {                
                console.log(data);                
                this.cronTrigger = data;
            })
            .catch(error => {
                console.log('getCronStatus error');
                this.error = error;
            });
    }
}