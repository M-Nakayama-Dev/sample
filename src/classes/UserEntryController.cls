public with sharing class UserEntryController {

    public User__c qhUser {get; set;}
    
    //コンストラクタ
    public UserEntryController() {
    
        //クエリパラメータからIDを取得
        string id = apexpages.currentpage().getparameters().get('id');
        
        //IDと一致する担当者レコードを取得
        qhUser = UserDao.getUserById(id);
        
        if (qhUser == null) {
        
            apexpages.message msg = 
                new apexpages.message(
                    apexpages.severity.error,
                    '担当者レコードがありません');
            apexpages.addmessage(msg);        
            return;    
        
        }
        
        
        
    }
}