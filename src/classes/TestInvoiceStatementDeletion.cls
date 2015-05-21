@isTest
public with sharing class TestInvoiceStatementDeletion {

	public TestInvoiceStatementDeletion() {
	}


    //トリガが本来の機能を実行しているかどうか、
    //つまり、品目名を含む請求書明細が削除されないようにしているかどうかを確認します
    static testmethod void TestDeleteInvoiceWithLineItem() {

        //テストファクトリメソッドを使用して品目名を含む請求書明細を作成(品目名)
        Invoice_Statement__c inv = TestDataFactory.createOneInvoiceStatement(true);

        //Database.delete Apex メソッドを使用して請求書を削除します。
        //このメソッドが返す Database.DeleteResultオブジェクトは操作が正常に終了したかどうか
        Test.startTest();
        Database.DeleteResult result = Database.delete(inv, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
    }


    //トリガが品目名を含まない請求書明細の削除を阻止しないことを確認します
    static testmethod void TestDeleteInvoiceWithoutLineItems() {

        //テストファクトリメソッドを使用して品目名を含む請求書明細を作成(品目名含まない)
        Invoice_Statement__c inv = TestDataFactory.createOneInvoiceStatement(false);

        //Database.delete Apex メソッドを使用して請求書を削除します。
        Test.startTest();
        Database.DeleteResult result = Database.delete(inv, false);
        Test.stopTest();

        System.assert(result.isSuccess());

    }

    //トリガが品目名を含まない請求書明細の削除を阻止しないことを確認します
    static testmethod void TestBulkDeleteInvoices() {

        //テストファクトリメソッドを使用して品目名を含む請求書明細を作成(品目名含むものと、含まない)
        List<Invoice_Statement__c> invList = new List<Invoice_Statement__c>();
        invList.add(TestDataFactory.createOneInvoiceStatement(true));
        invList.add(TestDataFactory.createOneInvoiceStatement(false));

        test.startTest();
        Database.DeleteResult[] results = Database.delete(invList, false);
        test.stopTest();

        System.assert(!results[0].isSuccess());
        System.assert(results[1].isSuccess());

    }


}