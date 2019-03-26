public with sharing class emailConfig {
    @AuraEnabled (cacheable=true)
    public static string runBatch(){
        emailBatch emailReport = new emailBatch();
        return(Database.executeBatch(emailReport));
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
}
