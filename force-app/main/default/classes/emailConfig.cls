public with sharing class emailConfig {
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
        return JSON.serialize([SELECT Id, CreatedDate, CompletedDate, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems FROM AsyncApexJob WHERE ApexClassId IN (Select Id FROM ApexClass WHERE Name =: name)]);
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
            CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE Id = :cronId];
            System.debug('Next fire time: ' + ct.NextFireTime); 
            return JSON.serialize(ct);
        } else return cronId;
    }
}
