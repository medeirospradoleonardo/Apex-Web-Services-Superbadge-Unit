global class CredentialVerificationService {

    webservice static String verifyCredential(String lastName, String certificationName) {
        String response = 'No record found';

        List<Contact> lContact = [SELECT Id FROM Contact WHERE LastName = :lastName LIMIT 1];

        if (lContact.isEmpty()) {
            return response;
        }

        Contact contact = lContact[0];

        List<Contact_Certification__c> lContactCertification = [
            SELECT Id, isActive__c 
            FROM Contact_Certification__c 
            WHERE Name = :certificationName AND Contact__c = :contact.Id 
            LIMIT 1
        ];

        if (lContactCertification.isEmpty()) {
            return response;
        }
        
        Contact_Certification__c certification = lContactCertification[0];

        response = certification.isActive__c ? 'Valid' : 'Needs Renewal';
        
        return response;
    }
}