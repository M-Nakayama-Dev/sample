/**
 * Sitesユーザ向けWCMシート画面コンポーネントコントローラ
 * 実質のコントローラークラス
 *
 */
public class s2MscSearch extends BaseComponentController {

    public string[] test {get; set;}
    public string[] sDate {get; set;}
    public string[] sShozoku {get; set;}

    public List<SelectOption> getDate() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('56期上期','56期上期'));
        options.add(new SelectOption('55期下期','55期下期'));
        options.add(new SelectOption('55期上期','55期上期'));
        return options;
    }

    public List<SelectOption> getShozoku() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('組織１','組織１'));
        options.add(new SelectOption('組織２','組織２'));
        options.add(new SelectOption('組織３','組織３'));
        return options;
    }

    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('56期上期','56期上期'));
        options.add(new SelectOption('55期下期','55期下期'));
        options.add(new SelectOption('55期上期','55期上期'));
        return options;
    }

    

    public Boolean isSFDCUser {
        get {
            return dto.isSFDCUser();
        }
        set;
    }

    private String wcmCSV = 'id, Jiki__c, AccountNumber__c, EmployeeName__c,MG__c,WorkField1__c, Version__c '
                        + ', startDate__c, endDate__c, Link__c, Status__c, LastModifiedDate, LastModifiedBy.Name '
                        + ', WCMLastModifiedDate__c, WCMLastModifiedUser__c, WCMLastModifiedUser__r.Name '
                        + ', Status2__c, FMT__c';

    // コンストラクタ
    public s2MscSearch() {
        //doSearch();
    }


    
    public Pagereference openWCMV () {
        
        Pagereference pr = null;
        
        return pr;
    }

     public PageReference doMissionUpdate() {
         //パスワード再設定ページ遷移
         PageReference pageRef = page.s2MissionSheetUpdatev;
         return pageRef;
    }   
    
}