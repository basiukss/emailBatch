public with sharing class emailConfig {
    private static String settings_name='email_report';

    @AuraEnabled
    public static string runBatch(){
        emailBatch emailReport = new emailBatch();
        return Database.executeBatch(emailReport);
    }

    @AuraEnabled
    public static string getStatus(String jobId){
        System.debug('Get Status id:' + jobId);
        if(jobId != null){
            AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob
                WHERE Id = :jobId];
                System.debug(job);
            return JSON.serialize(job);
        } else return jobId;
    }

    @AuraEnabled
    public static string getBatchStatus(){
        String name = 'emailBatch';
        return JSON.serialize([SELECT Id, CreatedDate, CompletedDate, Status, JobType FROM AsyncApexJob WHERE ApexClassId IN (Select Id FROM ApexClass WHERE Name =: name) AND CreatedDate > YESTERDAY ORDER BY CreatedDate ASC]);
    }

    @AuraEnabled
    public static string runScheduleBatch(){
        Integer runAt = 1;
        emailBatch emailReport = new emailBatch();
        return System.scheduleBatch(emailReport, 'email_report', runAt);
    }

    @AuraEnabled
    public static string getCronStatus(String cronId){
        System.debug('Get CronTrigger id:' + cronId);
        if(cronId != null){
            CronTrigger ct = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType, NextFireTime, PreviousFireTime,State,StartTime,EndTime,CronExpression
                            FROM CronTrigger WHERE Id = :cronId ORDER BY CreatedDate DESC];   
            System.debug('ct.CronJobDetail.Id: ' +ct.CronJobDetail.Id);
            System.Debug([SELECT Id, CreatedDate, CompletedDate, Status, JobType FROM AsyncApexJob WHERE Id =: ct.CronJobDetail.Id]);
            return JSON.serialize(ct);
        } else return cronId;
    }

    // Batch custom settings
    @AuraEnabled (cacheable=true)
    public static String getSettings(){        
        batch_email_report__c er = batch_email_report__c.getInstance(settings_name);
        System.debug('getSettings' + er);
        return JSON.serialize(er);
    }

    @AuraEnabled
    public static String setSettings(String settings){
        System.debug('setSettings ' + settings);
        batch_email_report__c er = batch_email_report__c.getInstance(settings_name);
        batch_email_report__c erNew = (batch_email_report__c) JSON.deserialize(settings, batch_email_report__c.class);
        er.state__c = erNew.state__c;
        er.time__c = erNew.time__c;
        upsert er;
        return JSON.serialize(batch_email_report__c.getInstance(settings_name));
    }
}
