trigger OpportunityTrigger on Opportunity (before update, before delete) {

    switch on Trigger.operationType {

        when BEFORE_DELETE {

            //Solution 6
            //Get account ids of opportunities to be deleted
            Set<Id> accountIds = new Set<Id>();
            for (Opportunity opp : Trigger.old) {
                if (opp.StageName == 'Closed Won') {
                    accountIds.add(opp.AccountId);
                }
            }

            //Create a map of accounts based on the accountIds
            Map<Id, Account> accountToIdMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accountIds]);

            for (Opportunity opp : Trigger.old) {
                if (opp.StageName == 'Closed Won') {
                    Account acc = accountToIdMap.get(opp.AccountId);
                    if (acc.Industry == 'Banking') {
                        opp.addError('Cannot delete closed opportunity for a banking account that is won');
                    }
                }
            }
        }

        when BEFORE_UPDATE {
            //Solution 5
            for (Opportunity opp : Trigger.new) {
                if (opp.Amount == null || opp.Amount <= 5000) {
                    opp.Amount.addError('Opportunity amount must be greater than 5000');
                }
            }

            //Solution 7
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

        when else {
            System.debug('OpportunityTrigger WHEN ELSE ACTIVATED.');     
        }
    }
}