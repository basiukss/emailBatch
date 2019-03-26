public with sharing class emailConfig {
    // Form fields
    public Id selectedAccount {
        get{
    		return '001p000000kiILAAA2';      	
    	}
        set;}

    public List<Contact> contacts {
        get{
            String fieldSetName = 'email_config';
            String id = '\'001p000000kiILAAA2\'';
            Schema.FieldSet fs = Schema.SObjectType.Contact.fieldSets.getMap().get(fieldSetName);
            String fieldsQuery = '';
            for(Schema.FieldSetMember f : fs.getFields()) {
                if(fieldsQuery.length() > 0){
                    fieldsQuery += ', ' + f.getFieldPath();
                } else {
                    fieldsQuery += f.getFieldPath();    
                }
            }
            return Database.query('SELECT ' + fieldsQuery + ' FROM Contact WHERE AccountId = ' + id);      	
    	}
        set;}

    @AuraEnabled (cacheable=true)
    public static string getEmailConfig() {
        String fieldSetName = 'email_config';
        String id = '\'001p000000kiILAAA2\'';
        Schema.FieldSet fs = Schema.SObjectType.Contact.fieldSets.getMap().get(fieldSetName);
        String fieldsQuery = '';
        for(Schema.FieldSetMember f : fs.getFields()) {
            if(fieldsQuery.length() > 0){
                fieldsQuery += ', ' + f.getFieldPath();
            } else {
                fieldsQuery += f.getFieldPath();    
            }
        }
        System.debug(Database.query('SELECT ' + fieldsQuery + ' FROM Contact WHERE AccountId = ' + id));
        // ================================
        // Reference the attachment page
        PageReference pageRef = new PageReference('/apex/exportPage');
        // Take the PDF content
        Blob body;
        try {
            body = pageRef.getContent();
        }catch(VisualforceException ex){
            System.debug(ex);
        }
        // Create the email attachment  
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
	    efa.setFileName('Contacts.pdf');
	    efa.setBody(body);
        // Create the email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'cftokm@gmail.com' };        
        message.setSubject('sf test mail');         
        message.setHtmlBody('Hello, <br/><br/>Your contacts');
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{efa});
        /*
        try{
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });            
            for(Messaging.SendEmailResult rr : results){
                System.debug('Email result ' + rr.IsSuccess());
                if(!rr.IsSuccess())
                {
                    Messaging.SendEmailError[] errArr = rr.getErrors();   
                    System.debug(errArr[0].getTargetObjectId()); 
                }
            }             
            return JSON.serialize(results);
        }catch(exception e){
            System.debug(e.getMessage());
            return 'error';
        }
        */
        //
        return JSON.serialize(Database.query('SELECT ' + fieldsQuery + ' FROM Contact WHERE AccountId = ' + id));
    }
}
