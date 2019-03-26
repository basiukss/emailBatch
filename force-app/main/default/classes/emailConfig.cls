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
        // get accounts
        List <Account> acc = [SELECT id, name from Account];
            System.debug('Accounts');
        // get contacts
        String result = '';
        for(Account a: acc){
            System.debug(a.Name);
            result = generateAccountPDF(a);
        }
/*
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
*/
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
        return result;
    }

    public static String generateAccountPDF(Account account){
        String FORM_HTML_START = '<HTML><BODY>';
        String FORM_HTML_END = '</BODY></HTML>';
        String pdfContent = '' + FORM_HTML_START;
        try
        {
            pdfContent = '' + FORM_HTML_START;
            pdfContent = pdfContent + '<H2>' + account.Name + '</H2>';            
            // get fieldset
            String fieldSetName = 'email_config';
            // get contact fieldset
            Schema.FieldSet fs = Schema.SObjectType.Contact.fieldSets.getMap().get(fieldSetName);
            String fieldsQuery = '';
            for(Schema.FieldSetMember f : fs.getFields()) {
                if(fieldsQuery.length() > 0){
                    fieldsQuery += ', ' + f.getFieldPath();
                } else {
                    fieldsQuery += f.getFieldPath();    
                }
            }
            // get contacts            
            List <Contact> ct = Database.query('SELECT ' + fieldsQuery + ', Account.Name FROM Contact WHERE AccountId = \'' + account.id+ '\'');
            pdfContent += '<table>';
            for(Contact c: ct){
                pdfContent +=   '<tr><td>' + c.FirstName + 
                                '</td><td>' + c.LastName + 
                                '</td><td>' + c.Title + 
                                '</td><td>' + c.Email + 
                                '</td><td>' + c.Phone + 
                                '</td><td>' + c.MailingCity + 
                                '</td></tr>';
            }
            pdfContent += '</table>';
            pdfContent = pdfContent + FORM_HTML_END;
        }catch(Exception e)
        {
            pdfContent = '' + FORM_HTML_START;
            pdfContent = pdfContent + '<P>THERE WAS AN ERROR GENERATING PDF: ' + e.getMessage() + '</P>';
            pdfContent = pdfContent + FORM_HTML_END;
        }
        return pdfContent;
    }

        
    public static void attachPDF(Account account, String pdfContent)
    {
        try
        {
            Attachment attachmentPDF = new Attachment();
            attachmentPDF.parentId = account.Id;
            attachmentPDF.Name = account.Name + '.pdf';
            attachmentPDF.body = Blob.toPDF(pdfContent); //This creates the PDF content
            insert attachmentPDF;
        }catch(Exception e)
        {
            account.addError(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static string runBatch(){
        emailBatch emailReport = new emailBatch();
        return(Database.executeBatch(emailReport));
    }

    @AuraEnabled (cacheable=true)
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
