trigger AccountTrigger on Account (before insert, after insert) {

    if (Trigger.isBefore && Trigger.isInsert) {     
    
        for (Account acc : Trigger.new) {

            // Question 1 solution
            if (acc.Type == null) { acc.Type = 'Prospect'; }

            // Question 2 solution
            if (!String.isBlank(acc.ShippingStreet)) { acc.BillingStreet = acc.ShippingStreet; }
            if (!String.isBlank(acc.ShippingCity)) { acc.BillingCity = acc.ShippingCity; }
            if (!String.isBlank(acc.ShippingState)) { acc.BillingState = acc.ShippingState; }
            if (!String.isBlank(acc.ShippingPostalCode)) { acc.BillingPostalCode = acc.ShippingPostalCode; }
            if (!String.isBlank(acc.ShippingCountry)) { acc.BillingCountry = acc.ShippingCountry; }

            // Question 3 solution
            if (acc.Fax != null && acc.Phone != null && acc.Website != null) {acc.Rating = 'Hot'; }
        }
    } else if (trigger.isAfter && trigger.isInsert) {
        // Question 4 solution
        List<Contact> newContacts = new List<Contact>();
        for (Account acc : Trigger.new) {
            Contact con = new Contact();
            con.LastName = 'DefaultContact';
            con.Email = 'default@email.com';
            con.AccountId = acc.Id;            
            newContacts.add(con);
        }
        insert newContacts;
    }
}