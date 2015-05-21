/**
 * Sitesユーザ向けWCMシート画面コンポーネントコントローラ
 * 実質のコントローラークラス
 *
 */
public class s2Msc extends BaseComponentController {

    /*
    public WCMSheet__c[] wcmList { get; set; }
    public boolean getIswcmList() {
        if (wcmList!= null && wcmList.size() > 0) {
            return true;
        } else {
            return false;
        }
    }
    */
    
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
    public s2Msc() {
        //doSearch();
    }

    public PageReference doSearch() {
        
        /*
System.debug('DTOありますか：' + dto);
        wcmList = new List<WCMSheet__c>();
        if (dto != null && dto.getIsLogin()) {
            List<WCMSheet__c> wList  = Database.query(
                'Select ' + wcmCSV +
                ' From WCMSheet__c ' +
                'Where Account__c = \'' + dto.loginUser.Id + '\'' +
                ' AND Status__c != \'対象外\' ' +
                ' AND Status__c != \'上司作成中\' ' +
                'Order By endDate__c DESC ' // 終了日の降順
            );
            for (WCMSheet__c w : wList) {
System.debug('WCM@@@:' + w.LastModifiedBy.Name + ' ログインユーザ:' + UserInfo.getLastName());
                // サイトユーザの場合はディスプレイの間に本人がいる。
                if (UserInfo.getLastName().equals('サイトゲストユーザ')
                    && w.WCMLastModifiedUser__c != null
                    && w.WCMLastModifiedUser__r.Name.equals('サイトゲストユーザ')) {
                    w.WorkField1__c = w.EmployeeName__c;
                } else if (w.WCMLastModifiedUser__c != null) {
                    w.WorkField1__c = w.WCMLastModifiedUser__r.Name;
                } else {
                    w.WorkField1__c = w.LastModifiedBy.Name;
                }
                if (w.WCMLastModifiedDate__c == null) {
                    // WCM最終更新日時がNULLの場合はシステムの最終更新日をセットする
                    w.WCMLastModifiedDate__c = w.LastModifiedDate;
                }
                wcmList.add(w);
            }
System.debug('@@@:' + wcmList);
        }
        */
        
        return null;
    }
    
    public Pagereference openWCMV () {
        
        Pagereference pr = null;
        
        /*
        String strId = ApexPages.currentpage().getParameters().get('id');
        String strFmt = ApexPages.currentpage().getParameters().get('fmt');
        if (!String.isEmpty(strFmt)) {
            if (strFmt.contains('RHD')) {
                pr = new Pagereference('/apex/s2RHDwcmv?id=' + strId);
            } else if (strFmt.contains('RAD')) {
                pr = new Pagereference('/apex/s2RADwcmv?id=' + strId);
            } else {
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.INFO, 'フォーマットがみつかりません。管理者にご連絡をお願い致します。')
                );
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.INFO, 'フォーマットがみつかりません。管理者にご連絡をお願い致します。')
                );
        }        
        */
        return pr;
    }

}