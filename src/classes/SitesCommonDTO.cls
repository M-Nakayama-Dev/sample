/**
 * セッションの代りに利用する共通情報保持クラス
 *
 */
public class SitesCommonDTO {

    public string UserId {get; set;}

    public SitesCommonDTO() {

        /*
        if (this.loginUser == null) {
            for (User__c u : [select id, Number__c, Name
                        from User__c where Number__c = :This.UserId]) {
                this.loginUser = u;
            }
        }
*/
        
    }

    // 担当者情報
    public Account loginUser {get;set;}



    /** ログインしているか */
    public boolean getIsLogin() {
        if (this.loginUser != null
            || isSFDCUser()) {
            return true;
        } else {
            return false;
        }
    }

    // SFDCユーザライセンスを保有しているか？
    public boolean isSFDCUser() {
        return false;
        /*
        if (user != null &&
            (user.SelectAll__c || user.kaigaiHR__c || user.SelectMyCompany__c || user.SelectMember__c)) {
            return true;
        } else {
            return false;
        }
        */
    }
    private static final String BLANK = '';
    // 従業員の原籍会社を取得します。
    public String getShortHomeCompany() {
        return BLANK;
        /*
        if (loginUser == null) {
            return BLANK;
        } else {
            return this.loginUser.ShortHomeCompany__c;
        }
        */
    }

}