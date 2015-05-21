//削除前に処理を中断するトリガー
trigger RestrictInvoiceDeletion on Invoice_Statement__c (before delete) {

    for (Invoice_Statement__c invoice :
         [SELECT Id
            FROM Invoice_Statement__c
           WHERE ID IN (SELECT Invoice_Statement__c FROM Line_Item__c) AND Id IN :Trigger.old])
    {

        Trigger.oldMap.get(invoice.Id).addError('Line_Itemにデータが登録されています。これは削除できませんよ。');

    }
}