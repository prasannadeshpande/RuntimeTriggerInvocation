/**
 * AccountTriggerAction class
 * Implements "TriggerAction" interface. Contains logic for the Account trigger
 * Author: Prasanna
 * Date:   20-06-2016
 */
public class AccountTriggerAction implements TriggerAction{
	
	/**
	 * Creates a follow up task for newly created account
	 */
	public void ExecuteTrigger() {
		List<Task> lstNewTasks = new List<Task>();
		for(SObject acc : Trigger.New) {
			Task tskObj = new Task();
			tskObj.Priority = 'High';
			tskObj.Subject = 'Contact Account';
			tskObj.WhatId = (Id)acc.get('Id');
			lstNewTasks.add(tskObj);
		}
		insert lstNewTasks;
	}
}