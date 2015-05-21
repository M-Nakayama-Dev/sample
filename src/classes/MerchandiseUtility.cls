public  class MerchandiseUtility {
    public static void mainProcessing() {

        try {

            insertUser();

        } catch(MerchandiseException me) {
            System.debug(loggingLevel.Error, '*** me.getMessage(): ' + me.getMessage());
            System.debug(loggingLevel.Error, '*** me.getCause(): ' + me.getCause());

        }
    }

    public static void insertUser() {

        try {
            User__c u = new User__c();
            insert u;
        } catch(DmlException e) {

            //ここでカスタム例外を呼び出し
            throw new MerchandiseException ('MerchandiseExceptionをthrow.', e);

        }
    }
}