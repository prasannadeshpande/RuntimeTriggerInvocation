/**
 * TriggerManager Class
 * TriggerManager manages the trigger action as per the records of Trigger Definition object. Execution of class is configured in the records of Trigger Definition object,
 * Author: Prasanna
 * Date:   20-06-2016
 */
public class TriggerManager {
	
/**
 * TriggerManager Constructor
 * Constructor check for the triggers definitions configured for the particular object and as per the Execution criteria perform the class action
 * Paramters : SObject Array, new and old values.
 * Author & LastModified By: Prasanna
 * LastModifiedDate:   20-06-2016
 */
	public TriggerManager(Sobject[] oldValues, SObject[] newValues) {
  	System.debug(' Type ' + newValues[0].getSObjectType());
		String strObject = '' + newValues[0].getSObjectType();
		Trigger_Definition__c[] triggerDefs = [SELECT Active__c,Class_Name__c,Context__c,Delete__c,Object__c,Id,Insert__c,Undelete__c,Update__c FROM Trigger_Definition__c WHERE Active__c = true AND Object__c = :strObject];
		for(Trigger_Definition__c tridef : triggerDefs) {
			System.debug('Execute TriggerAction: ' + isTriggerContextValid(tridef));
			if(isTriggerContextValid(tridef)) {
				TriggerAction TrigAction = null;
				try {
					TrigAction = getInstance(tridef.Class_name__c);
				} catch(Exception ex) {
					System.debug('Exception :' + ex.getMessage());
				}
				if(TrigAction != null)
					TrigAction.ExecuteTrigger();
			}
		}
	}

/**
 * Method: IsTriggerContextValid
 * Method checks for the Trigger Definition configuration and current Trigger execution context varaible. If criteria is fulfill returns TRUE else FALSE.
 * Paramters : T
 * Author & LastModified By: Prasanna
 * LastModifiedDate:   20-06-2016
 */
	public Boolean isTriggerContextValid(Trigger_Definition__c TriggerDef) {
		if((TriggerDef.Context__c == 'Before' && Trigger.isBefore == True) 
			|| (TriggerDef.Context__c == 'After' && Trigger.isAfter == True)
		&& (
			(TriggerDef.Insert__c  && Trigger.isInsert)
				|| (TriggerDef.Delete__c  && Trigger.isDelete)
				|| (TriggerDef.Update__c  && Trigger.isUpdate)
				|| (TriggerDef.Undelete__c  && Trigger.isUndelete)
			)
		)
			return true;
		return false;
	}

/**
 * Method: getInstance
 * Method Method takes className as an input and create the instance of the class, also verifies if it typecasted in the TriggerAction interface.
 * Paramters : String ClassName
 * Author & LastModified By: Prasanna
 * LastModifiedDate:   20-06-2016
 */
	public static TriggerAction getInstance(string className) {
		Type classtype = Type.forName(className);
		if(classtype == null) {
			System.debug(LoggingLevel.Error, 'Failed to find type for ['+className+']');
			return null;
		}

		// Create an instance to confirm the type
		object classInstance = classtype.newInstance();
		if(!(classInstance instanceOf TriggerAction)) {
			return null;
		}
		//Typecasting the instance into interface so as to validate that we have correct class reference.
		TriggerAction triggerActionInstance = (TriggerAction)classInstance;
		return triggerActionInstance;
	}
}