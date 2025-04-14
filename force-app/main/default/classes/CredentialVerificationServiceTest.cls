@isTest
private class CredentialVerificationServiceTest {

    @isTest
    static void testVerifyCredential_Valid() {
        Contact contact = new Contact(LastName = 'Doe');
        insert contact;

		Certification__c certification = new Certification__c(Name = 'SalesforceCertification');
        insert certification;

        Date issueDate = Date.today();

        Contact_Certification__c contactCertification = new Contact_Certification__c(
            isActive__c = true,
            Certification__c = certification.Id,
            Issue_Date__c = issueDate,
            Contact__c = contact.Id
        );
        insert contactCertification;

        contactCertification = [SELECT Name FROM Contact_Certification__c WHERE Id = :contactCertification.Id];

        Test.startTest();
            String result = CredentialVerificationService.verifyCredential(contact.LastName, contactCertification.Name);
        Test.stopTest();

        System.assertEquals('Valid', result, 'O result deveria ser "Valid"');
    }

    @isTest
    static void testVerifyCredential_InactiveCertification() {

        Contact contact = new Contact(LastName = 'Smith');
        insert contact;
        
		Certification__c certification = new Certification__c(Name = 'Pilot Certification');
        insert certification;


        Date issueDate = Date.today().addYears(-2);

        Contact_Certification__c contactCertification = new Contact_Certification__c(
            isActive__c = false,
            Certification__c = certification.Id,
            Issue_Date__c = issueDate,
            Contact__c = contact.Id
        );
        insert contactCertification;

        contactCertification = [SELECT Name FROM Contact_Certification__c WHERE Id = :contactCertification.Id];

        Test.startTest();
            String result = CredentialVerificationService.verifyCredential(contact.LastName, contactCertification.Name);
        Test.stopTest();

        System.assertEquals('Needs Renewal', result, 'O result deveria ser "Needs Renewal"');
    }

    @isTest
    static void testVerifyCredential_NoContact() {

        Test.startTest();
            String result = CredentialVerificationService.verifyCredential('NonExistentLastName', 'Some Certification');
        Test.stopTest();

        System.assertEquals('No record found', result, 'O result deveria ser "No record found"');
    }

    @isTest
    static void testVerifyCredential_NoCertification() {
        Contact contact = new Contact(LastName = 'Johnson');
        insert contact;


        Test.startTest();
            String result = CredentialVerificationService.verifyCredential(contact.LastName, 'NonExistentCertification');
        Test.stopTest();

        System.assertEquals('No record found', result, 'O result deveria ser "No record found"');
    }
}