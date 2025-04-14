@isTest
private class AssetServiceTest {

    @isTest 
    static void testReportLostDevice_assetNotFound() {
        Test.startTest();

            String result = AssetService.reportLostDevice('NonExistentAsset');

        Test.stopTest();

        Assert.areEqual('No device found.', result, 'Mensagem inválida');
    }

    @isTest 
    static void testReportLostDevice_noInsuranceCoverage() {
        Account account = new Account(Name = 'Test Account1');
        insert account;

        Contact contact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = account.Id);
        insert contact;

        Asset asset = new Asset(Name = 'Test Asset', AccountId = account.Id, ContactId = contact.id, Asset_Identifier__c = 'Asset', Status='Available');
        insert asset;

        Test.startTest();
            String result = AssetService.reportLostDevice(asset.Asset_Identifier__c);
        Test.stopTest();

        Assert.areEqual('No coverage. Asset status adjusted to Lost.', result, 'Mensagem inválida');
    }

    @isTest 
    static void testReportLostDevice_claimAlreadyFiled() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = account.Id);
        insert contact;

        Asset asset = new Asset(Name='Test Asset', AccountId = account.Id, ContactId = contact.id, Asset_Identifier__c = 'Asset', Status = 'Available');
        insert asset;

        Insurance__c insurance = new Insurance__c(Asset__c = asset.Id, Coverage__c = 'Comprehensive', Active__c = true);
        insert insurance;

        Test.startTest();
            String result = AssetService.reportLostDevice(asset.Asset_Identifier__c);
        Test.stopTest();

		List<Claim__c> claims = [SELECT Id, Name FROM Claim__c WHERE Insurance__c = :insurance.Id AND Type__c = 'Loss' LIMIT 1];

        Assert.areEqual(claims[0].Name, result, 'Mensagem inválida');
    }
}