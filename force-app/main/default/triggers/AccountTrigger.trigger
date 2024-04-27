trigger AccountTrigger on Account (before insert) {
    for (Account acc : Trigger.new) {
        if (acc.Type == null) {
            acc.Type = 'Prospect';
        }
    }

    if (trigger.isInsert) {
        for (Account acc : Trigger.new) {           
            if (!String.isBlank(acc.ShippingStreet)) { acc.BillingStreet = acc.ShippingStreet; }
            if (!String.isBlank(acc.ShippingCity)) { acc.BillingCity = acc.ShippingCity; }
            if (!String.isBlank(acc.ShippingState)) { acc.BillingState = acc.ShippingState; }
            if (!String.isBlank(acc.ShippingPostalCode)) { acc.BillingPostalCode = acc.ShippingPostalCode; }
            if (!String.isBlank(acc.ShippingCountry)) { acc.BillingCountry = acc.ShippingCountry; }
        }
    }
}