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
        System.debug('Trigger.old: ' + Trigger.old);        
    }
}