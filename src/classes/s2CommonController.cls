/**
 * Sites共通のコントローラークラス
 * このクラスでDTOを取得し、各コンポーネントのBaseコントローラのDTOにVFで参照を渡します。
 *
 */
public class s2CommonController {

    //ユーザID(INPUT)
    public String UserId {get; set;}
    //パスワード(INPUT)
    public transient String Password {get; set;}
    
    // URLキー
    private String URLKey;
        
    //パスワード有効無効フラグ
    public boolean layoutFlg {get; set;}
    
    public string RemId {get; set;}
    public string UserNumber {get; set;}
    public string UserName {get; set;}
    public string NewPassword {get; set;}
    public string ConPassword {get; set;}
    public string ChangeLimit {get; set;}
    
    //共通DTO
    public SitesCommonDTO dto {set;get;}
    
    public class s2LoginException extends Exception {}
    
    //コンストラクタ
    public s2CommonController() {

        /*------------ パスワード再登録用の判断 -------------------*/
        //パラメータクエリ(key)取得
        Map<String, String> params = ApexPages.currentPage().getParameters();
        if (params != null && String.isNotBlank(params.get('key'))) {
            this.URLKey = params.get('key');
        }
        if (!string.isEmpty(this.URLKey)) {
                
            //システム日付のテスト
            //Datetime mydate= Datetime.now().adddays(1);
            String convertedDate = Datetime.now().format('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'');//フォーマット指定
            //System.debug('★convertedDate:'+convertedDate);
            
            //リマインダーオブジェクトの取得
            //発行されたKEYが一致、送信済ステータス、有効期限内
            List<GenericHistory__c> lstHiss = Database.query(
                ' SELECT id, name, Account__c, Account__r.Name, Account__r.EmployeeNo__c, EnabledDate__c' +
                ' FROM GenericHistory__c ' +
                ' WHERE ProvisionalPassword__c = \'' + this.URLKey+ '\' ' +
                '   AND Enabled__c = true' +
                ' LIMIT 1'
            );
            
            if (lstHiss.size() == 0) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'リマインダーオブジェクトを取得できなかった', ''));
                layoutFlg = false;
            } else {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, lstReminder[0].ChangeLimit__c + '   '  + convertedDate , ''));
                RemId = lstHiss[0].Id;
                UserId = lstHiss[0].Account__c;
                UserName = lstHiss[0].Account__r.Name;
                UserNumber = lstHiss[0].Account__r.EmployeeNo__c;
                ChangeLimit = lstHiss[0].EnabledDate__c.format('yyyy/MM/dd HH:mm:ss', 'JST');
                layoutFlg = true;
            }
        }

    }

    //ログイン認証
    public PageReference doLogin() {

        try{

            //警告フラグ
            Boolean ErrorFlg = false;

            //必須チェック
            if (String.isEmpty(UserId)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザIDは必須入力です', ''));
                ErrorFlg = true;
            }
            if (String.isEmpty(Password)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'パスワードは必須入力です', ''));
                ErrorFlg = true;
            }

            if (ErrorFlg) {
                return null;
            }

            //担当者(取引先)オブジェクトの取得
            List<Account> lstAct =
                [SELECT id, name, EmployeeNo__c FROM Account WHERE EmployeeNo__c = :UserId];
			Account Act = null;
            if (lstAct.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザID「' + UserId + '」は存在しないIDです', ''));
                return null;
            } else {
                Act = lstAct[0];
            }
            
            //最新のパスワード取得
            //ステータス「有効」最終作成日の１レコード
            List<GenericHistory__c> lstHiss = [
               select id, name, Password__c, Enabled__c
               from GenericHistory__c
               where Section__c = 'パスワード'
                 and Account__c = :Act.id
               order by CreatedDate DESC
               LIMIT 1
              ];
            GenericHistory__c Hiss = null;
            //TODO 最後のパスワード履歴が有効ではなくなった場合
            //TODO レコードがなかった場合（初回登録）
            if (lstHiss.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '最新のパスワードを取得できませんでした', ''));
                return null;
            } else {
                Hiss = lstHiss[0];
            }
            
            //パスワード合否判定
            if (getmd5hash(Password) != Hiss.Password__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '入力したパスワードに誤りがあります。' + ' 入力したパスワードMD5ハッシュ値：' + getmd5hash(Password), ''));
                return null;
            }

            //パスワード有効チェック（タイムトリガにて有効チェック操作）
            if (Hiss.Enabled__c) {
                
                //DTOに情報設定
                if (dto == null) {
                    dto = new SitesCommonDTO();
                }
                dto.loginUser = Act;                
                //ページ遷移            
                return page.s2portalv;
            
            } else {
                
                //有効期限切れの場合
                //仮パスワードの登録
                GenericHistory__c HRem = new GenericHistory__c();
                Blob b = Crypto.GenerateAESKey(128);    //仮パスワード乱数設定
                String key = EncodingUtil.ConvertTohex(b);
                HRem.Section__c = 'リマインダー';
                HRem.ProvisionalPassword__c = key;    //参照設定している担当者オブジェクトのID
                HRem.URL__c = 'https://' + ApexPages.currentPage().getHeaders().get('Host') +  Page.s2ReminderConfirm.geturl() + '?key=' + key;
                HRem.Enabled__c = true;    //有効
                HRem.Account__c = Act.id;
                HRem.EnabledDate__c = datetime.now().addDays(1); //TODO 期限をきめないといけない、とりあえず１日
                List<GenericHistory__c> lstHRem = new List<GenericHistory__c>();
                lstHRem.add(HRem);
                insert lstHRem;
                                
                //パスワード再設定ページ遷移
                PageReference pageRef = new PageReference(HRem.URL__c);
                pageRef.setRedirect(true);
                return pageRef;                
                
            }

        }
        catch (Exception e) {
            // Handle this exception here
            ApexPages.addMessages(e);
        }

        return null;

    }


    //パスワード登録
    public PageReference doSave() {

        try{
            //パラメータ取得方法　ApexPages.currentPage().getParameters().get('id')
            //警告フラグ
            Boolean ErrorFlg = false;

            //必須チェック
            if (String.isEmpty(NewPassword)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '新パスワードは必須入力です', ''));
                ErrorFlg = true;
            }
            if (String.isEmpty(ConPassword)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '新パスワード(確認)は必須入力です', ''));
                ErrorFlg = true;
            }
            if (ErrorFlg) {
                return null;
            }
            //パスワード一致チェック
            if (NewPassword != ConPassword) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '新パスワードと確認用が一致しません', ''));
                return null;
            }
            //パスワードルールチェック
            //運用ルール：パスワードは、IDと異なり、8桁以上、英数特殊文字を全て含み、6ヶ月以内に更新する
            if (NewPassword == UserNumber) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '新パスワードは社員番号と同じ値は設定できません', ''));
                return null;
            }
            if (isPass(NewPassword) != true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '新パスワードは8文字以上、小英字、大英字、数字、特殊文字' + 
                    '※(_@!?+-*/%"\';:,.)　をそれぞれ１つずつ含む必要があります', ''));
                return null;
            }

            /* ステータスを無効に */
            GenericHistory__c HissEnabled = 
                [SELECT id, Enabled__c from GenericHistory__c WHERE id = :RemId];
            HissEnabled.Enabled__c = False;
            update HissEnabled;
            
            //リマインダーステータス更新(IDで取得)
            /*
            for (List<Reminder__c> rems: [SELECT id, Status__c From Reminder__c WHERE id = :RemId]) {
                for(Reminder__c r : rems) {
                    if (r.Status__c == '送信済') 
                    {r.Status__c = '変更済';}
                }
                update rems;
            }
			*/

            //新規パスワード登録
            GenericHistory__c newHiss = new GenericHistory__c();
            newHiss.Section__c = 'パスワード';
            newHiss.Account__c = UserId;    //参照設定している担当者オブジェクトのID
            newHiss.Password__c = getmd5hash(NewPassword);
            newHiss.EnabledDate__c = datetime.now().adddays(180);	//TODO 有効期限は6か月後
            newHiss.Enabled__c = true;
            List<GenericHistory__c> newlstHiss = new List<GenericHistory__c>();
            newlstHiss.add(newHiss);
            insert newlstHiss;

            //DTOに情報設定
            List<Account> lstAct = 
                [select id, name, EmployeeNo__c from Account where EmployeeNo__c = :UserNumber];
            Account Act = null;
            if (lstAct.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザID「' + UserNumber + '」は存在しないIDです', ''));
                return null;
            } else {            
                Act = lstAct[0];
            }
            if (dto == null) {
                dto = new SitesCommonDTO();
            }
            dto.loginUser = Act;  
            
            //ページ遷移            
            return page.s2portalv;
            
        }

        catch (Exception e) {
            // Handle this exception here
            ApexPages.addMessages(e);
        }

        return null;

    }
    
    //MD5ハッシュ値
    public string getmd5hash(String str){
        String md5str =  EncodingUtil.convertToHex(Crypto.generateDigest('md5', Blob.valueOf(str)));
        return md5str;
    }

    /**
     * パスワード判定
     * @param s 文字列
     * @return true: アルファベット小英字、大英字、数字、特殊文字、いずれか１ずつある8文字以上20以下のキーワード
     */
    public static Boolean isPass(String s) {
        return Pattern.matches(
            '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\' \\_ \\" \\? \\! \\# \\$ \\( \\) \\+ \\- \\* \\/ \\: \\; \\\\ \\, \\. \\@]).{8,20}'
         , s);
    }

    //キャンセルボタン
    public PageReference doCancel() {
        return Page.s2Login;
    }
    
}