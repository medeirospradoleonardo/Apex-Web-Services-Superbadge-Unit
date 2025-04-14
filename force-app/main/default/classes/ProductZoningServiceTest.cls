@IsTest
private class ProductZoningServiceTest {

    @TestSetup
    static void setup() {
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'GC1020', Family = 'TestFamily');
        insert product;
    }

    @IsTest
    static void testGetPermissibleFlyZone() {

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.addParameter('ProductCode', 'GC1020');
        req.httpMethod = 'GET';
        req.headers.put('CountryCode', 'US');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = ProductZoningService.getPermissibleFlyZone();
        
        Assert.areEqual('Confirm with the local authorities', response, 'Mensagem inválida');

        req.headers.put('CountryCode', 'DE');
        response = ProductZoningService.getPermissibleFlyZone();

        Assert.areEqual('Confirm with the local authorities', response, 'Mensagem inválida');

        req.headers.put('CountryCode', 'FR');
        response = ProductZoningService.getPermissibleFlyZone();

        Assert.areEqual('Confirm with the local authorities', response, 'Mensagem inválida');


        req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        response = ProductZoningService.getPermissibleFlyZone();

        Assert.areEqual('ProductCode is missing or doesn\'t exist', response, 'Mensagem inválida');


        req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.addParameter('ProductCode', 'INVALID');
        req.httpMethod = 'GET';
        RestContext.request = req;
        response = ProductZoningService.getPermissibleFlyZone();

        Assert.areEqual('ProductCode is missing or doesn\'t exist', response, 'Mensagem inválida');
    }
}