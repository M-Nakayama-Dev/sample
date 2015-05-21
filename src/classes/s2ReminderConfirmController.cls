public class s2ReminderConfirmController {

    // URLキー
    private String URLKey;
        
    //パスワード有効無効フラグ
    public boolean layoutFlg {get; set;}
    
    public string RemId {get; set;}
    public string UserId {get; set;}
    public string UserNumber {get; set;}
    public string UserName {get; set;}
    public string NewPassword {get; set;}
    public string ConPassword {get; set;}
    public string ChangeLimit {get; set;}

    //コンストラクタ
    public s2ReminderConfirmController() {

        //パラメータクエリ(key)取得
        Map<String, String> params = ApexPages.currentPage().getParameters();
        if (params != null && String.isNotBlank(params.get('key'))) {
            this.URLKey = params.get('key');
        }
		system.debug(this.URLKey);
        
        //システム日付のテスト
        //Datetime mydate= Datetime.now().adddays(1);
        String convertedDate = Datetime.now().format('yyyy-MM-dd\'T\'hh:mm:ss.SSS\'Z\'');//フォーマット指定
        System.debug('★convertedDate:'+convertedDate);
        
        //リマインダーオブジェクトの取得
        //発行されたKEYが一致、送信済ステータス、有効期限内
        List<GenericHistory__c> lstHiss = Database.query(
            ' SELECT id, name' +
            ' FROM GenericHistory__c ' +
            ' WHERE Section__c = \'リマインダー\'' +
            '   AND Password__c = \'' + this.URLKey+ '\'' +
            '   AND Enabled__c = true' +
            ' LIMIT 1'
        );
        
        system.debug(lstHiss);
        
        
        /*
        //リマインダーオブジェクトの取得
        //発行されたKEYが一致、送信済ステータス、有効期限内
        List<Reminder__c> lstReminder = Database.query(
            ' SELECT id, name, ChangeLimit__c, User__r.Name, User__r.Number__c' +
            ' FROM Reminder__c ' +
            ' WHERE ProvisionalPassword__c = \'' + this.URLKey+ '\' ' +
            '   AND Status__c = \'送信済\'' +
            '   AND ChangeLimit__c >= ' + convertedDate +
            ' LIMIT 1'
        );
        if (lstReminder.size() == 0) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'リマインダーオブジェクトを取得できなかった', ''));
            layoutFlg = false;
        } else {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, lstReminder[0].ChangeLimit__c + '   '  + convertedDate , ''));
            RemId = lstReminder[0].Id;
            UserId = lstReminder[0].User__c;
            UserName = lstReminder[0].User__r.Name;
            UserNumber = lstReminder[0].User__r.Number__c;
            ChangeLimit = lstReminder[0].ChangeLimit__c.format('yyyy/MM/dd HH:mm:ss', 'JST');
            layoutFlg = true;
        }
		*/

        
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
            if (isPass(NewPassword) != true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    '新パスワードは8文字以上、小英字、大英字、数字、特殊文字' + 
                    '※(_@!?+-*/%"\';:,.)　をそれぞれ１つずつ含む必要があります', ''));
                return null;
            }

            //リマインダーステータス更新(IDで取得)
            for (List<Reminder__c> rems: [SELECT id, Status__c From Reminder__c WHERE id = :RemId]) {
                for(Reminder__c r : rems) {
                    if (r.Status__c == '送信済') 
                    {r.Status__c = '変更済';}
                }
                update rems;
            }

            //新規パスワード登録
            Password__c obj = new Password__c();
            obj.Number__c = UserId;    //参照設定している担当者オブジェクトのID
            obj.Password__c = getmd5hash(NewPassword);
            obj.PasswordLimit__c = datetime.now().adddays(180);	//TODO 有効期限は6か月後
            obj.Enabled__c = true;
            List<Password__c> objPass = new List<Password__c>();
            objPass.add(obj);
            insert objPass;

			//s2CommonControllerの作成            
            List<User__c> lstUser = 
                [select id, name, Number__c from User__c where Number__c = :UserNumber];
            User__c User = null;
            if (lstUser.size() == 0) {
                //レコード存在チェック
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'ユーザID「' + UserNumber + '」は存在しないIDです', ''));
                return null;
            } else {            
                User = lstUser[0];
            }
            
			s2CommonController s2c = new s2CommonController();
            s2c.dto = new SitesCommonDTO();
            s2c.dto.loginUser = User;   
            
            system.debug(s2c.DTO.loginUser);
            
            //ページ遷移            
            return page.s2portalv;
            
            //PageReference pageRef = new PageReference('http://www.recruit.jp/');
            //return pageRef;
            
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