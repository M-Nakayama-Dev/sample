trigger EnhancedLimitExample on Invoice_Statement__c (after insert, before update) {

    System.debug(Trigger.new);
    System.debug(Trigger.newMap.KeySet());

    //List<Invoice_Statement__c> iList =
    //    [SELECT Id, Description__c, (SELECT Id, Units_Sold__c, Merchandise__c from Line_Items__r)
    //    FROM Invoice_Statement__c WHERE Id IN :Trigger.newMap.KeySet()];

    //for(Invoice_Statement__c inv: iList) {
    //    for(Line_Item__c li: inv.Line_Items__r) {
    //               System.debug(loggingLevel.Error, '*** li: ' + li);
    //    }
    //}

}