public with sharing class UserDao {



    public static List<User__c> 
        getUserDate(Date baseDate)
    {
    
        List<User__c> lstUser = 
            [
                select Id, Name, fulltime__c
                from User__c
                where fulltime__c = true
            ];
        return lstUser;
    }
    
    //担当者レコードをIDで取得する
    public static User__c getUserById(String id) {
    
        User__c qhUser;
        
        List<User__c> lstUser = 
            [
                select Id, Name, fulltime__c, mail__c
                from User__c
                where id = :id
            ];
        
        //取得できたら１件返す
        if (!lstUser.isempty()) {
            qhUser = lstUser.get(0);
        }
        return qhUser;
    }

}