import { LightningElement, track, wire } from 'lwc';
import getSettings from '@salesforce/apex/emailConfig.getSettings';
import setSettings from '@salesforce/apex/emailConfig.setSettings';

export default class EmailSettings extends LightningElement {
    @track settings = {};    
    @track state;
    @track time;
    @track error;

    @wire (getSettings)
    wiredGetSettings({ data, error }){
        console.log('wired getSettings');
        if (data) {
            console.log(data);
            this.settings = JSON.parse(data);
            this.state = this.settings.state__c;
            this.time = this.settings.time__c;
        } else if (error) {
            console.log('wired getSettings error');
            this.error = error;
        }        
    }

    handleChangeState(event){
        this.state = event.target.checked;
    } 

    handleChangeTime(event){
        this.time = event.target.value;
    } 

    handleSetSettings(){
        console.log(`set settings`);
        setSettings({settings : JSON.stringify({state__c : this.state, time__c : this.time})})
        .then(data => {                
            console.log(data);                
        })
        .catch(error => {
            console.log('setSettings error');
            this.error = error;
        });
    }
}