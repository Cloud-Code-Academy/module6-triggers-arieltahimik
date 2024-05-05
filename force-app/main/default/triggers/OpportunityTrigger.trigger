trigger OpportunityTrigger on Opportunity (before delete, before update) {
    if (Trigger.isBefore && Trigger.isDelete) {
        // Question 6 solution               
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : Trigger.old) {
            if (opp.AccountId != null) {
                accIds.add(opp.AccountId);
            }
        }
        
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accIds]);

        for (Opportunity opp : Trigger.old) {            
            if (opp.StageName == 'Closed Won') {
                Account acc = accMap.get(opp.AccountId);                
                if (acc != null && acc.Industry == 'Banking') {
                    opp.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
        }
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        // Question 5 solution
        for (Opportunity opp : Trigger.new) {
            if (opp.Amount < 5000) {                
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }

        // Question 7 solution
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : Trigger.new) {
            accIds.add(opp.AccountId);
        }

        Map<Id, Contact> conIdMap = new Map<Id, Contact>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accIds AND Title = 'CEO']) {
            conIdMap.put(con.AccountId, con);
        }
        
        for (Opportunity opp : Trigger.new) {
            Contact ceoCon = conIdMap.get(opp.AccountId);
            if (ceoCon != null) {
                opp.Primary_Contact__c = ceoCon.Id;
            }
        }        
    } 
}