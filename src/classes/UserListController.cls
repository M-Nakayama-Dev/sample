public with sharing class UserListController {

    public List<User__c> qhUser {get; set;}
    
    public UserListController() {
    
        //正社員のみ取得
        qhUser = UserDao.getUserDate(System.Today());
        
        if (qhUser.isempty()) {
            apexpages.addmessage(new apexpages.message(apexPages.severity.warning, '正社員のデータは存在しませんでした'));
        }
        
    }
    
    public boolean isRenderedList {
    
        get{
        
            if (qhUser.isempty()) {
            
                return false;
            } else {
            
               return true;
            }
        
        }
    }    
    
    public pagereference titleLinkHandler() {
    
        string Id = apexpages.currentpage().getparameters().get('Id');
        
        pagereference pr = page.UserEntry;
        
        pr.setredirect(true);
        
        pr.getparameters().put('Id', Id);
        return pr;

    }
}