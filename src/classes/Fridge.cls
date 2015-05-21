//
//冷蔵庫クラス
//- モデル番号
//- ストック数
//
public class Fridge implements KitchenUtility {

    public String modelNumber;
    public Integer numberInStock;

    //静的変数
    public static Integer stockThreshoId = 5;
    //静的変数（変数への値の割り当てが１回限り）
    public static final Integer fstockThereshoId = 10;


    //コンストラクタ
    public Fridge() {
        modelNumber = 'XX';
        numberInStock = 0;
    }
    public Fridge(String theModelNumber, Integer theNumberInStock) {
        this.modelNumber = theModelNumber;
        this.numberInStock = theNumberInStock;
    }

    //メンバ変数
    public void updateStock(Integer justSold) {
        numberInStock = numberInStock - justSold;
    }

    //private 変数へのアクセス
    public void setModelNumber(String str) {
        this.modelNumber = str;
    }
    public String getModelNumber() {
        return this.modelNumber;
    }

    //静的クラスメソッド
    public static void toDebug(Fridge aFridge) {
        System.Debug('Fridge.modelNumber:' + aFridge.modelNumber);
        System.Debug('Fridge.numberInStock:' + aFridge.numberInStock);
    }

    //プロパティ構文
    public Integer ecoRating {
        get { return ecoRating;}
        set {
            ecoRating = value; //valueは自動変数
            if (ecoRating < 0) ecoRating = 0;
        }
    }

}