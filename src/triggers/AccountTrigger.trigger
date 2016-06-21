trigger AccountTrigger on Account (before insert,before update,after insert,after update) {
    
    new TriggerManager(Trigger.Old,Trigger.New);

}