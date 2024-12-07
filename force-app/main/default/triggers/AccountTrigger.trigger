trigger AccountTrigger on Account (before insert, after insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            for (Account acc : Trigger.new) {
                //Solution 1
                if (acc.Type == null) {
                    acc.Type = 'Prospect';
                }

                //Solution 2
                acc.BillingStreet = acc.ShippingStreet ?? '';
                acc.BillingCity = acc.ShippingCity ?? '';
                acc.BillingState = acc.ShippingState ?? '';
                acc.BillingPostalCode = acc.ShippingPostalCode ?? '';
                acc.BillingCountry = acc.ShippingCountry ?? '';

                //Solution 3
                if (acc.Fax != null && acc.Phone != null && acc.Website != null) {
                    acc.Rating = 'Hot'; 
                }
            }            
        }
        when AFTER_INSERT {
            //Solution 4
            List<Contact> contactsToInsert = new List<Contact>();
            for (Account acc : Trigger.new) {
                Contact con = new Contact();
                con.LastName = 'DefaultContact';
                con.Email = 'default@email.com';
                con.AccountId = acc.Id;
                contactsToInsert.add(con);
            }
            if (contactsToInsert.size() > 0) {
                insert contactsToInsert;
            }
        }
        when else {
            System.debug('AccountTrigger WHEN ELSE ACTIVATED');
        }
    }
}