trigger OpportunityTrigger on Opportunity (before update, after update, before delete, after delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Question 5 solution
        for (Opportunity opp : Trigger.new) {
            if (opp.Amount < 5000) {                
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    } else if (Trigger.isBefore && Trigger.isDelete) {

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
}