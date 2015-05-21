public class test {

    public Boolean flg {get; set;}

    //コンストラクタ
    public test() {

        flg = true;
    }

}



test t = new test();
System.debug(loggingLevel.Error, '*** t.flg: ' + t.flg);
