@isTest
public class TestDataFactory {

    //コンストラクタ
	public TestDataFactory() {
	}

    /**
     * @description publicメソッドがある、テストデータとして請求書明細と商品品目を作成
     * @param Boolean withLineItem
     * @param
     * @return Invoice_Statement__c テスト用メソッド
     **/
    public static Invoice_Statement__c createOneInvoiceStatement(Boolean withLineItem) {

        Invoice_Statement__c testInvoice = createInvoiceStatement();

        if (withLineItem == true) {
            //商品レコード
            Merchandise__c m = createMerchandiseItem('Orange juice');
            AddLineItem(testInvoice, m);
        }

        return testInvoice;

    }

    /**
     * @description 請求書明細レコード
     * @param none
     * @return Invoice_Statement__c 請求書明細レコード
     **/
    private static Invoice_Statement__c createInvoiceStatement() {

        Invoice_Statement__c inv = new Invoice_Statement__c(Description__c = 'Test Invoice');
        insert inv;
        return inv;
    }


    /**
     * @description 商品レコードの作成
     * @param merchName 商品名
     * @return Merchandise__c 商品レコード
     **/
    private static Merchandise__c createMerchandiseItem(String merchName) {

        //名前、説明、価格、総在庫
        Merchandise__c m = new Merchandise__c(
            Name = merchName,
            Description__c = 'Fresh juice',
            Price__c = 2,
            Total_Inventory__c = 1000);
        insert m;
        return m;
    }


    /**
     * @description 請求書明細レコードと商品レコードのリスト化
     * @param
     * @param
     * @return Line_Item__c 商品リスト
     **/
    private static Line_Item__c AddLineItem(Invoice_Statement__c inv,
                                            Merchandise__c m) {

        Line_Item__c lineItem = new Line_Item__c(
                                    Invoice_Statement__c = inv.Id,
                                    Merchandise__c = m.Id,
                                    Unit_Price__c = m.Price__c,
                                    Units_Sold__c = (Double)(10*Math.random()+1));
            insert lineItem;
            return lineItem;
       }

}