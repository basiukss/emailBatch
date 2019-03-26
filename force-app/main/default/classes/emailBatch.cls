global class emailBatch implements Database.Batchable<sObject> {
    global List<Account> start(Database.BatchableContext bc) {
        System.debug('BATCH START');
        return [SELECT Id, Name from Account];
    }
    global void execute(Database.BatchableContext bc, List<Account> accounts){
        System.debug('BATCH EXECUTE');
        List<String> messages = new List<String>();
        for(Account acc : accounts){            
            String msg = generateContactsPDF(acc);
            System.debug(msg);
            messages.add(msg);
        }
    }    
    global void finish(Database.BatchableContext bc){
        System.debug('BATCH FINISH');
    }    
    
    public static String generateContactsPDF(Account account){
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
            pdfContent += '<span>' + system.today().format() + '</span>';
            pdfContent += FORM_HTML_END;
        }catch(Exception e)
        {
            pdfContent += FORM_HTML_START;
            pdfContent += '<P>ERROR GENERATING PDF: ' + e.getMessage() + '</P>';
            pdfContent += FORM_HTML_END;
        }
        return pdfContent;
    }
}