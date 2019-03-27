import { LightningElement, track, wire } from 'lwc';
import getBatchStatus from '@salesforce/apex/emailConfig.getBatchStatus';
import getState from '@salesforce/apex/emailConfig.getState';
import getTime from '@salesforce/apex/emailConfig.getTime';
import setTime from '@salesforce/apex/emailConfig.setTime';

export default class EmailSettings extends LightningElement {
    @track state;
    @track time;
    @track error;

    handleState(event){
        console.log(`handleState`);
        this.state = event.target.checked;
    }

    handleGetStatus() {
        console.log('getStatus');
    }



    @wire(getState, {})
    getState({ error, data }) {
        if (data) {
            console.log('getState');
            console.log(data);
            this.state = data;
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getTime)
    getTime({ error, data }) {
        if (data) {
            console.log('getTime');
            console.log(data);            
            this.time = data;
        } else if (error) {
            this.error = error;
        }
    }

    handleKeyChange(event){
        this.time = event.target.value;    
    }

    handleSetTime(){
        console.log('set time: ' + this.time);
        setTime({newTime : this.time})
        .then(data => {                
            console.log(data);
        })
        .catch(error => {
            console.log('setStartTime error');
            this.error = error;
        });
    }

    renderedCallback() {
        console.log('rendered');
        getTime();
    }

    handleGetBatchStatus() {
        console.log('getBatchStatus');
        getBatchStatus()
            .then(data => {   
                this.batchStatus = JSON.parse(data);
            })
            .catch(error => {
                console.log('getBatchStatus error');
                this.error = error;
            });
    }
}