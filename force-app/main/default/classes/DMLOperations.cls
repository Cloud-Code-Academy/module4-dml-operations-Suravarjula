/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account acctObject = new Account();

        // Set some fields on the Account
        acctObject.Name = 'CC Academy';
        acctObject.NumberOfEmployees = 25;

        // Insert the Account into the database
        insert acctObject;

        // Return the Id of the newly created Account
        return acctObject.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acct = new Account(Name = name, Industry = industry);

        // Insert the Account
        insert acct;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact contactObject = new Contact();

        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        contactObject.AccountId = accountId;
        contactObject.LastName = 'Test Contact';

        // Insert the Contact into the database
        insert contactObject;

        // Return the Id of the newly created Contact
        return contactObject.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact contactInfo = [SELECT Id from Contact where Id = :contactId];
        // Update the Contact's last name
        contactInfo.LastName = newLastName;
        // Update the Contact in the database
        update contactInfo;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity oppRecord = [Select Id from Opportunity where Id = :oppId];

        // Update the Opportunity's stage
        oppRecord.StageName = newStage;

        // Update the Opportunity in the database
        update oppRecord;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account acctRecord = [Select Id from Account where Id = :accountId];
        acctRecord.Name = newName;
        acctRecord.Industry = newIndustry;

        // Update the Account with the given Id with the new name and industry
        update acctRecord;

    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Iterate over the opportunities
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        for (Opportunity opportunity : opportunities) {
            opportunity.StageName = 'Qualification';
            opportunity.CloseDate = Date.today().addMonths(3);
            opportunity.Amount = 50000;
        }

        // Upsert the Opportunity
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        List<Opportunity> oppList = new List<Opportunity>();
        // Loop through each Opportunity name
        System.debug('Account Name passed : ' + accountName + ' and opportunity names : ' + oppNames);
        for (String oppName : oppNames) {
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
            Account[] acct = [select Id from Account where Name = :accountName];
            System.debug('Status of account object array is : ' + acct.size().toString());
            if(acct.size() == 0) {
                acct = new Account[1];
                System.debug('Size of acct object array : ' + acct.size().toString());
                acct[0] = new Account(Name = accountName);
                insert acct[0];
                System.debug('Size of acct object array after account creation : ' + acct.size().toString());
            }
            Opportunity newOpp = new Opportunity(Name = oppName, AccountId = acct[0].Id, StageName = 'Prospecting', CloseDate = Date.today().addMonths(4));
            oppList.add(newOpp);
        }
        System.debug('Opp List Count : ' + oppList.size());
        upsert oppList;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account acct;

		// if the Account exists, update the description
        if(accounts != null && accounts.size() > 0) {
            acct = accounts[0];
            acct.Name = accountName;
            acct.Description = 'Updated Account';
        }
        else {
		// otherwise, create a new Account and set the description
            acct = new Account(Name = accountName, Description = 'New Account');
        }

        upsert acct;
		// Upsert the Account
		return acct;
	}

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        System.debug('List of Contacts received : ' + contactsToUpsert.toString());
        for (Contact contactRecord : contactsToUpsert) {
		// Extract the Account Name from Contact's LastName
            Account[] contactAccount = [Select Id from Account where Name = :contactRecord.LastName];
        System.debug('Contact Account Array Size : ' + contactAccount.size());

		// Get the account based on the name or create one if it doesn't exist
            if(contactAccount.size() == 0 ){
                contactAccount = new Account[1];
                contactAccount[0] = upsertAccount(contactRecord.LastName);
            }
        System.debug('Contact Account Array Size - 2nd time : ' + contactAccount.size());
        // Link the Contact to its Account using the Account Id        
        contactRecord.AccountId = contactAccount[0].Id;
        
        }

		// Upsert the Contacts
        upsert contactsToUpsert;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leadList = new List<Lead>();
        // Loop through each Lead name
        for(String leadName : leadNames) {
            Lead lead = new Lead(Company = leadName, LastName = leadName);
            leadList.add(lead);
        }

        // Insert the Leads
        insert leadList;    

        // Delete the Leads
        delete leadList;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        List<Case> caseList = new List<Case>();
        for(Integer counter=1; counter <= numOfCases; counter++) {
            Case caseRecord = new Case(Subject = 'Test Case ' + counter.toString(), AccountId = accountId);
            caseList.add(caseRecord);
        }

        // Insert the cases
        insert caseList;

        // Delete the cases
        delete caseList;
    }
}