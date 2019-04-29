@isTest
private class CaseCloseControllerTest {
    
    @testSetup
    public static void testSetupData() {
        Case c = new Case();
        c.Status ='New';
        c.Type ='Other';
        c.Origin ='Email';
        insert c;
	}

	private static testMethod void testCaseCloseController() {
        Case c = [SELECT Id FROM Case LIMIT 1];
        Map<String,String> statusMap = CaseCloseController.getCloseCaseStatus();
        System.assertNotEquals(0,statusMap.keySet().size());
        CaseCloseController.closeCaseRecord(c.Id,statusMap.values().get(0),'Case Close Reason');
        c = [SELECT Id,Status,isClosed FROM Case LIMIT 1];
        System.assertEquals(true,c.isClosed);
	}

}